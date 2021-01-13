FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build-env

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy the source file and build
COPY Program.cs .
COPY SomeClass.cs .
RUN dotnet publish -c Release -o out

FROM python:3.8.7-buster AS pythonnet

WORKDIR /app

ARG MONO_VERSION=6.12
ARG PYTHONNET_VERSION=2.5.1

# Install .NET Core SDK
RUN wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb
RUN apt-get update \
  && apt-get install -y apt-transport-https \
  && apt-get install -y dotnet-sdk-3.1 \
  && apt-get install -y aspnetcore-runtime-3.1 \
  && apt-get install -y dotnet-runtime-3.1 \
  && rm -rf /var/lib/apt/lists/* /tmp/*

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

COPY --from=build-env /app/out .

COPY Program.cs .
COPY SomeClass.cs .
COPY *.csproj .
COPY main.py .
CMD ["/bin/sh", "-c", "python main.py"]
