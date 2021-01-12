FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build-env

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy the source files and build
COPY Program.cs .
COPY SomeClass.cs .
RUN dotnet publish -c Release -o out --runtime linux-x64

FROM python:3.8.7-buster

WORKDIR /app

ARG MONO_VERSION=6.12
ARG PYTHONNET_VERSION=2.5.1

# Install mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && echo "deb http://download.mono-project.com/repo/debian stretch/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official.list \
  && apt-get update \
  && apt-get install -y clang \
  && apt-get install -y gdb \
  && apt-get install -y mono-devel=${MONO_VERSION}\* \
  && rm -rf /var/lib/apt/lists/* /tmp/*

# Install pythonnet
RUN pip install pycparser \
  && pip install pythonnet==${PYTHONNET_VERSION}

# Copy dll's that were built in a container containing the dotnet SDK
COPY --from=build-env /app/out .

# This is the Python file in which we'll trigger the pythonnet addReference error.
COPY main.py .

# For some reason, `import clr` raises an error when the .dll's are in the working directory.
# So we change WORKDIR before running the python script.
WORKDIR /

CMD ["/bin/sh", "-c", "MONO_LOG_LEVEL=debug python /app/main.py"]
