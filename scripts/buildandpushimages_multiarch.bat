:: Copyright IBM Corporation 2021
::
::  Licensed under the Apache License, Version 2.0 (the "License");
::   you may not use this file except in compliance with the License.
::   You may obtain a copy of the License at
::
::        http://www.apache.org/licenses/LICENSE-2.0
::
::  Unless required by applicable law or agreed to in writing, software
::  distributed under the License is distributed on an "AS IS" BASIS,
::  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
::  See the License for the specific language governing permissions and
::  limitations under the License.

:: Invoke as buildandpush_multiarchimages.bat <registry_url> <registry_namespace> <comma_separated_platforms>
:: Examples:
:: 1) buildandpush_multiarchimages.bat
:: 2) buildandpush_multiarchimages.bat index.docker.io your_registry_namespace
:: 3) buildandpush_multiarchimages.bat quay.io your_quay_username linux/amd64,linux/arm64,linux/s390x

@echo off
for /F "delims=" %%i in ("%cd%") do set basename="%%~ni"

if not %basename% == "scripts" (
    echo "please run this script from the 'scripts' directory"
    exit 1
)

REM go to the parent directory so that all the relative paths will be correct
cd ..

IF "%3"=="" GOTO DEFAULT_PLATFORMS
SET PLATFORMS=%3%
GOTO REGISTRY

:DEFAULT_PLATFORMS
    SET PLATFORMS=linux/amd64,linux/arm64,linux/s390x,linux/ppc64le
	GOTO REGISTRY

:REGISTRY
    IF "%2"=="" GOTO DEFAULT_REGISTRY
    IF "%1"=="" GOTO DEFAULT_REGISTRY
    SET REGISTRY_URL=%1
    SET REGISTRY_NAMESPACE=%2
    GOTO MAIN

:DEFAULT_REGISTRY
    SET REGISTRY_URL=quay.io
    SET REGISTRY_NAMESPACE=jobinl400ey
	GOTO MAIN

:MAIN
:: Uncomment the below line if you want to enable login before pushing
:: docker login %REGISTRY_URL%

echo "building and pushing image frontend"
pushd source\enterprise-app\frontend
docker buildx build --platform ${PLATFORMS} -f Dockerfile --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/frontend .
popd

echo "building and pushing image gateway"
pushd source\enterprise-app\gateway
docker buildx build --platform ${PLATFORMS} -f Dockerfile --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway .
popd

echo "building and pushing image inventory"
pushd source\enterprise-app\inventory
docker buildx build --platform ${PLATFORMS} -f Dockerfile --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory .
popd

echo "building and pushing image orders"
pushd source\enterprise-app\orders
docker buildx build --platform ${PLATFORMS} -f Dockerfile --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders .
popd

echo "building and pushing image customers"
pushd source\enterprise-app\customers
docker buildx build --platform ${PLATFORMS} -f Dockerfile --push --tag ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers .
popd

echo "done"
