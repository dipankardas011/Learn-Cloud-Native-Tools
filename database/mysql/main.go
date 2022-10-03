package main

import (
	"database/sql"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	fmt.Println("Welcome!")
	db, err := sql.Open("mysql", "root:dipankar@tcp(mysql:3306)/abcd")

	if err != nil {
		panic(err)
	}
	defer db.Close()

	useDB, err := db.Query("INSERT INTO test VALUES (2, 'TEST')")

	if err != nil {
		panic(err)
	}

	fmt.Println(useDB)
	result, err := db.Query("SELECT * from test")
	if err != nil {
		panic(err)
	}

	for result.Next() {
		var a int
		var b string

		err = result.Scan(&a, &b)
		if err != nil {
			panic(err)
		}
		fmt.Println(a, " ", b)
	}

	defer result.Close()

	defer useDB.Close()

}
