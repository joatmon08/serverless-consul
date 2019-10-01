openfaas:
	(cd faas-nomad && nomad run ./nomad_job_files/faas.hcl)
	(cd faas-nomad && nomad run ./nomad_job_files/monitoring.hcl)

db:
	nomad run ./nomad_job_files/database.hcl

function:
	faas-cli build -yaml nyc311.yml
	faas-cli push -yaml nyc311.yml
	faas-cli deploy -yaml nyc311.yml

clean:
	nomad job stop -purge OpenFaaS-nyc311-halloween
	nomad job stop -purge nyc311
	nomad job stop -purge faas-nomadd
	nomad job stop -purge faas-monitoring