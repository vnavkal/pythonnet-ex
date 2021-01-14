FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build-env

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy the source files and build
COPY Program.cs .
COPY SomeClass.cs .
RUN dotnet publish -c Release -o out --runtime linux-x64

FROM python:3.8.7-buster AS pythonnet

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

FROM pythonnet

# Install .NET Core Runtime
RUN wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb \
  && apt-get update \
  && apt-get install -y apt-transport-https \
  && apt-get install -y dotnet-runtime-3.1 \
  && rm -rf /var/lib/apt/lists/* /tmp/*

COPY --from=build-env /app/out .

COPY CSMain.cs .
COPY main.py .

# For some reason, `import clr` raises an error when the .dll's are in the working directory.
# So we change WORKDIR before running the python script.
WORKDIR /

CMD ["/bin/sh", "-c", "python /app/main.py"]
