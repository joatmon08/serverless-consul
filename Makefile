openfaas:
	(cd faas-nomad && nomad run ./nomad_job_files/faas.hcl)
	(cd faas-nomad && nomad run ./nomad_job_files/monitoring.hcl)
	open http://localhost:3000

db:
	(cd database && docker build -t database:test .)
	docker run -d -p 5432:5432 -e POSTGRES_USER=secret_user -e POSTGRES_PASSWORD=secret_password -e POSTGRES_DB=nyc database:test