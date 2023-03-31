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

:: Invoke as buildimages.bat <container_runtime>
:: Examples:
:: 1) buildimages.bat
:: 2) buildimages.bat podman

@echo off
for /F "delims=" %%i in ("%cd%") do set basename="%%~ni"

if not %basename% == "scripts" (
    echo "please run this script from the 'scripts' directory"
    exit 1
)

IF "%1"=="" GOTO DEFAULT_CONTAINER_RUNTIME
SET CONTAINER_RUNTIME=%1%
GOTO DOCKER_CONTAINER_RUNTIME

:DEFAULT_CONTAINER_RUNTIME
    SET CONTAINER_RUNTIME=docker
	GOTO MAIN

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
REM go to the parent directory so that all the relative paths will be correct
cd ..

echo "building image frontend"
pushd source\enterprise-app\frontend
%CONTAINER_RUNTIME% build -f Dockerfile -t frontend .
popd

echo "building image gateway"
pushd source\enterprise-app\gateway
%CONTAINER_RUNTIME% build -f Dockerfile -t gateway .
popd

echo "building image inventory"
pushd source\enterprise-app\inventory
%CONTAINER_RUNTIME% build -f Dockerfile -t inventory .
popd

echo "building image orders"
pushd source\enterprise-app\orders
%CONTAINER_RUNTIME% build -f Dockerfile -t orders .
popd

echo "building image customers"
pushd source\enterprise-app\customers
%CONTAINER_RUNTIME% build -f Dockerfile -t customers .
popd

echo "done"

:SKIP
