package main

import (
	"context"
	"fmt"
	"log"
	"math"
	"net/http"
	"time"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/exporters/jaeger"
	"go.opentelemetry.io/otel/sdk/resource"
	tracesdk "go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.10.0"
)

const (
	service     = "simple-demo-tracing"
	environment = "production"
	id          = 1
)

var (
	tp *tracesdk.TracerProvider
)

func sleepy(ctx context.Context) {
	tr := otel.Tracer("/say-hello/sleepy")
	_, span := tr.Start(ctx, "sleep")
	span.SpanContext()

	defer span.End()

	sleepTime := 2 * time.Second
	span.SetAttributes(attribute.Int("sleep.duration", int(sleepTime)))
	time.Sleep(sleepTime)

}

func bar(ctx context.Context) {
	// Use the global TracerProvider.
	tr := otel.Tracer("/say-hello/bar")
	ctx11, span := tr.Start(ctx, "bar")
	span.SpanContext()

	span.SetAttributes(attribute.Key("foo->bar").String("direction-flow"))
	defer span.End()

	func(ctx context.Context) {
		tr := otel.Tracer("component-bar2")
		_, span := tr.Start(ctx, "bar22")
		span.SetAttributes(attribute.Key("foo->bar->bar22").String("direction-flow"))
		defer span.End()

		fmt.Println("Inner")
		time.Sleep(5 * time.Second)
	}(ctx11)
	time.Sleep(5 * time.Second)
}

// httpHandler is an HTTP handler function that is going to be instrumented.
func httpHandler(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	tr := tp.Tracer("/say-hello")
	ctx, span := tr.Start(ctx, "say-hello")
	defer span.End()

	fmt.Fprintf(w, "Hello, World! I am instrumented automatically!")
	// ctx := r.Context()
	bar(ctx)
	sleepy(ctx)
}

func greetMeth(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	tr := tp.Tracer("/greet")
	_, span := tr.Start(ctx, "Nice day")
	defer span.End()

	w.WriteHeader(200)
	fmt.Fprintf(w, "Today is a nice day PI= %.10f", math.Pi)
}

func main() {
	// Register our TracerProvider as the global so any imported
	// instrumentation in the future will default to using it.
	// ctx, cancel := context.WithCancel(context.Background())
	// defer cancel()

	// // defer func(ctx context.Context) {
	// // 	// Do not make the application hang when it is shutdown.
	// // 	ctx, cancel = context.WithTimeout(ctx, time.Second*5)
	// // 	defer cancel()
	// // 	if err := tp.Shutdown(ctx); err != nil {
	// // 		log.Fatal(err)
	// // 	}
	// // }(ctx)
	// tr := tp.Tracer("component-main")

	// ctx, span := tr.Start(ctx, "foo")
	// defer span.End()
	// bar(ctx)

	// ------------------------------------------
	loadConfigs()
	// Wrap your httpHandler function.
	http.HandleFunc("/say-hello", httpHandler)
	http.HandleFunc("/greet", greetMeth)
	// handler := http.HandlerFunc(httpHandler)
	// wrappedHandler := otelhttp.NewHandler(handler, "hello-instrumented")
	// http.Handle("/say-hello", wrappedHandler)

	// And start the HTTP serve.
	log.Fatal(http.ListenAndServe(":3030", nil))
}

func tracerProvider(url string) (*tracesdk.TracerProvider, error) {
	// Create the Jaeger exporter
	exp, err := jaeger.New(jaeger.WithCollectorEndpoint(jaeger.WithEndpoint(url)))
	if err != nil {
		return nil, err
	}
	tp := tracesdk.NewTracerProvider(
		// Always be sure to batch in production.
		tracesdk.WithBatcher(exp),
		// Record information about this application in a Resource.
		tracesdk.WithResource(resource.NewWithAttributes(
			semconv.SchemaURL,
			semconv.ServiceNameKey.String(service),
			attribute.String("environment", environment),
			attribute.Int64("ID", id),
		)),
	)
	return tp, nil
}

func loadConfigs() {
	var err error
	tp, err = tracerProvider("http://localhost:14268/api/traces")
	if err != nil {
		log.Fatal(err)
	}
	otel.SetTracerProvider(tp)
	// ctx, cancel := context.WithCancel(context.Background())
	// defer cancel()
}
