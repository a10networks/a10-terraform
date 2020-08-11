FROM hashicorp/terraform:0.12.24

ENV BASE_DIR_PATH main/new_infra/HA/

COPY . .

##VOLUME ./$BASE_DIR_PATH

WORKDIR ./$BASE_DIR_PATH

RUN terraform init

