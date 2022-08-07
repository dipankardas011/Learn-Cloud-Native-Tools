FROM scratch
ADD x86_64/2b446c1e1fca7b7d82b163a2f71c43cd21fc68afb37403f5ea58b8546022678e.tar.xz /
ADD x86_64/32870e4dd0ac4b0d36c8c2cd1b7f49686012c91a04a6e18ed032088fea706425.tar.xz /
ADD x86_64/ce7377924cbfbca4ce3da1723404023edcfd8d4c65d92eb9acaa664c3e2f5b03.tar.xz /
ADD x86_64/e0cd958e8a8f6cfb19d96fce8fe2f89d391a87675cc46c8123666bd63a5ad028.tar.xz /
ADD x86_64/e9ce7e3784f6ea471ae06e0e56909fd444aac4547ea66588bea2465fbe6ec498.tar.xz /
ADD x86_64/f44a65768aac7fa8c85ca51fd0d7bf3310263f8e94698ff07338e6b01d9c9264.tar.xz /

ENV LANG=en_US.UTF-8
ENV TZ=:/etc/localtime
ENV PATH=/var/lang/bin:/usr/local/bin:/usr/bin/:/bin:/opt/bin
ENV LD_LIBRARY_PATH=/var/lang/lib:/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/opt/lib
ENV LAMBDA_TASK_ROOT=/var/task
ENV LAMBDA_RUNTIME_DIR=/var/runtime

WORKDIR /var/task
COPY . .

ENTRYPOINT ["/lambda-entrypoint.sh"]