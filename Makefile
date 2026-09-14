ENV_FILE   		:= .env
LOG_DIR    		:= logs
LOG_TIMESTAMP 	:= $(shell date +"%Y-%m-%d_%H-%M-%S")
LOAD_ENV 		:= set -a; [ -f $(ENV_FILE) ] && . ./$(ENV_FILE); set +a

.PHONY: proxmox clean

proxmox:
	@mkdir -p $(LOG_DIR)
	@packer init proxmox.pkr.hcl
	@$(LOAD_ENV) && \
	export PACKER_LOG_PATH="$(LOG_DIR)/build_$(LOG_TIMESTAMP).log" \
	export PACKER_LOG=1 && packer build .

clean:
	@rm -rf $(LOG_DIR)