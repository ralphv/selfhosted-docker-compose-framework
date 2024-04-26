hello:
	@echo "Hello, Self hosted docker compose framework, check README.md"

trivy:
	./utils/trivy.sh

update:
	git pull && docker compose pull && docker compose up -d --build --remove-orphans
