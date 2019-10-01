nomad:
	(cd faas-nomad && source ./startNomad.sh)

openfaas:
	(cd faas-nomad && nomad run ./nomad_job_files/faas.hcl)
	(cd faas-nomad && nomad run ./nomad_job_files/monitoring.hcl)

db:
	nomad run ./nomad_job_files/database.hcl

function:
	faas-cli build -yaml nyc311.yml
	faas-cli push -yaml nyc311.yml
	# faas-cli deploy -yaml nyc311.yml

deploy:
	nomad run ./nomad_job_files/nyc311.hcl

clean:
	nomad job stop -purge nyc311-halloween || true
	nomad job stop -purge nyc311 || true
	nomad job stop -purge faas-nomadd || true
	nomad job stop -purge faas-monitoring || true

clean-all: clean
	kill -9 $(ps ax | grep consul | grep -v grep)
	kill -9 $(ps ax | grep nomad | grep -v grep)