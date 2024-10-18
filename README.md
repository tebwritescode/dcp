**Description**

This script automates the process of building and pushing a Docker image to DockerHub, while incrementally tracking the version number. It uses the directory name as the default local image name, but allows for customization through command-line arguments.

The script builds the Docker image with a version tag in the format `MM.DD.YY.<counter>`, where `<counter>` is an incremental value stored in a file. The image is then tagged with additional tags on DockerHub (`latest` and `tebwritescode/<image_name>:<date>.<counter>`).

**Usage**

To use this script, save it to a file (e.g., `build_and_push_docker_image.sh`) and make it executable by running `chmod +x build_and_push_docker_image.sh`.

You can run the script in three different modes:

1. **No arguments**: The script will use the directory name as both the local image name and Docker image name.
```bash
dcp
```
2. **One argument**: The script will use the parent directory name for the local image name, but allow you to specify a custom Docker image name using the first command-line argument.
```bash
dcp <DOCKER_IMAGE_NAME>
```
3. **Two arguments**: You can specify both the local image name and the Docker image name as separate command-line arguments.
```bash
dcp <LOCAL_IMAGE_NAME> <DOCKER_IMAGE_NAME>
```

**Example Output**

When you run the script, it will output something like this:
```
Docker image built with tag: myimage:02.14.21.1
Docker image tagged: tebwritescode/myimage:02.14.21.1
Docker image tagged: tebwritescode/myimage:latest
Docker image pushed: tebwritescode/myimage:02.14.21.1
Docker image pushed: tebwritescode/myimage:latest

Local Image Name: myimage
Docker Image Name: myimage
```
Note that the exact output may vary depending on your directory name and DockerHub credentials.

**Assumptions**

This script assumes you have Docker installed on your system, as well as the `docker` command in your PATH. Additionally, it requires a valid DockerHub account with access to the repository where you want to push your image.

**Downloading the Script**

Create folders
mkdir /opt/dcp
mkdir /opt/dcp/counters

You can download this script by running:
```bash
curl -sSO https://github.com/tebwritescode/dcp/blob/14d5d8d8126f94e9867152339f1ee644ee9e1c1e/dcp.sh > /opt/dcp/dcp.sh && chmod +x /opt/dcp/dcp.sh
```
**Setting up an Alias**

To make it easier to use this script, you can set up an alias by adding the following line to your shell configuration file (e.g., `~/.bashrc` or `~/.zshrc`):
```bash
alias dcp='/opt/dcp/dcp.sh'
```
Once you've added this alias, you can simply run `dcp` instead of typing out the full script name.

**Using the Alias**

To use the `dcp` alias, simply type:
```bash
dcp [optional arguments]
```
For example:
```bash
dcp myimage latest
```
This will build and push a Docker image with the tag `tebwritescode/myimage:latest`.
