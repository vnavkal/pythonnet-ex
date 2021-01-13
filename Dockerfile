FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy the source file and build
COPY Program.cs ./
RUN dotnet publish --runtime linux-x64 -c Release -o out

FROM python:3.8.7-buster AS pythonnet

WORKDIR /app

ARG MONO_VERSION=6.12
ARG PYTHONNET_VERSION=2.5.1

# Install mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && echo "deb http://download.mono-project.com/repo/debian stretch/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official.list \
  && apt-get update \
  && apt-get install -y clang \
  && apt-get install -y mono-devel=${MONO_VERSION}\* \
  && rm -rf /var/lib/apt/lists/* /tmp/*

FROM pythonnet

COPY --from=build-env /app/out .

# Install pythonnet
RUN pip install pycparser \
  && pip install pythonnet==${PYTHONNET_VERSION}

CMD mono ExampleProject.dll
