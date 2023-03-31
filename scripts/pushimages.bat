:: Copyright IBM Corporation 2021
::
::  Licensed under the Apache License, Version 2.0 (the "License");
::  you may not use this file except in compliance with the License.
::  You may obtain a copy of the License at
::
::        http://www.apache.org/licenses/LICENSE-2.0
::
::  Unless required by applicable law or agreed to in writing, software
::  distributed under the License is distributed on an "AS IS" BASIS,
::  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
::  See the License for the specific language governing permissions and
::  limitations under the License.

:: Invoke as pushimages.bat <registry_url> <registry_namespace> <container_runtime>
:: Examples:
:: 1) pushimages.bat
:: 2) pushimages.bat quay.io your_quay_username
:: 3) pushimages.bat index.docker.io your_registry_namespace podman

@echo off
IF "%3"=="" GOTO DEFAULT_CONTAINER_RUNTIME
SET CONTAINER_RUNTIME=%3%
GOTO REGISTRY

:DEFAULT_CONTAINER_RUNTIME
    SET CONTAINER_RUNTIME=docker
	GOTO REGISTRY

:REGISTRY
    IF "%2"=="" GOTO DEFAULT_REGISTRY
    IF "%1"=="" GOTO DEFAULT_REGISTRY
    SET REGISTRY_URL=%1
    SET REGISTRY_NAMESPACE=%2
    GOTO DOCKER_CONTAINER_RUNTIME

:DEFAULT_REGISTRY
    SET REGISTRY_URL=quay.io
    SET REGISTRY_NAMESPACE=jobinl400ey
	GOTO DOCKER_CONTAINER_RUNTIME

:DOCKER_CONTAINER_RUNTIME
	IF NOT "%CONTAINER_RUNTIME%" == "docker" GOTO PODMAN_CONTAINER_RUNTIME
	GOTO MAIN

:PODMAN_CONTAINER_RUNTIME
	IF NOT "%CONTAINER_RUNTIME%" == "podman" GOTO UNSUPPORTED_BUILD_SYSTEM
	GOTO MAIN

:UNSUPPORTED_BUILD_SYSTEM
    echo 'Unsupported build system passed as an argument for pushing the images.'
    GOTO SKIP

:MAIN
:: Uncomment the below line if you want to enable login before pushing
:: %CONTAINER_RUNTIME% login %REGISTRY_URL%

echo "pushing image customers"
%CONTAINER_RUNTIME% tag customers %REGISTRY_URL%/%REGISTRY_NAMESPACE%/customers
%CONTAINER_RUNTIME% push %REGISTRY_URL%/%REGISTRY_NAMESPACE%/customers

echo "pushing image frontend"
%CONTAINER_RUNTIME% tag frontend %REGISTRY_URL%/%REGISTRY_NAMESPACE%/frontend
%CONTAINER_RUNTIME% push %REGISTRY_URL%/%REGISTRY_NAMESPACE%/frontend

echo "pushing image orders"
%CONTAINER_RUNTIME% tag orders %REGISTRY_URL%/%REGISTRY_NAMESPACE%/orders
%CONTAINER_RUNTIME% push %REGISTRY_URL%/%REGISTRY_NAMESPACE%/orders

echo "pushing image inventory"
%CONTAINER_RUNTIME% tag inventory %REGISTRY_URL%/%REGISTRY_NAMESPACE%/inventory
%CONTAINER_RUNTIME% push %REGISTRY_URL%/%REGISTRY_NAMESPACE%/inventory

echo "pushing image gateway"
%CONTAINER_RUNTIME% tag gateway %REGISTRY_URL%/%REGISTRY_NAMESPACE%/gateway
%CONTAINER_RUNTIME% push %REGISTRY_URL%/%REGISTRY_NAMESPACE%/gateway

echo "done"

:SKIP
