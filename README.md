# Trigger Kernel Builder

This repository contains workflows and scripts to trigger a kernel builder workflow. The kernel builder workflow is designed to compile custom kernels with various configurations, including both with and without KernelSU support.

## Usage

### Adding New Sources

To add new sources to the kernel builder workflow, follow these steps:

1. **Clone Sources**: Clone the sources into the appropriate directory. You can add new sources under the `sources` directory. Each source should have its YAML file containing commands, flags, and configurations.

2. **Update YAML Files**: Update or create YAML files for each new source within the `sources` directory. These files should contain the necessary build commands, flags, and configurations specific to each source.

3. **Ensure Compatibility**: Ensure that the new sources and their respective YAML files are compatible with the kernel build environment and configurations specified in the workflow.

### Secrets

The following secrets need to be configured in your repository:

- `GITHUB_TOKEN`: GitHub token for repository access.
- `TELEGRAM_BOT_TOKEN`: Token for Telegram bot integration.

Make sure to add these secrets to your repository's settings.

### Workflow

The workflow in this repository is triggered on pushes to the `Test` branch and manually via the workflow dispatch event. Here's how it works:

1. **Delete Old Releases and Tags**: Deletes old releases and tags to maintain a clean release history.

2. **Trigger Kernel Builder Workflow**: Triggers the Kernel Builder workflow to compile the custom kernel.

## Workflow Description

The Kernel Builder workflow in this repository is responsible for compiling custom kernels with various configurations. It supports multiple versions and architectures and builds kernels both with and without KernelSU support.

### Jobs

- `trigger_kernel_builder`: This job triggers the Kernel Builder workflow. It follows these steps:
  - Checkout repository.
  - Delete old releases and tags.
  - Trigger the Kernel Builder Workflow.

- `build`: This job compiles the kernel based on the specified version and architecture. It follows these steps:
  - Notification of job start.
  - Environment setup including installing necessary packages and tools.
  - Source cloning and extraction.
  - Compilation of the kernel using the commands specified in the source YAML files.
  - Handling KernelSU support.
  - Creation of AnyKernel3 zip.
  - Making a release on GitHub.
  - Notifications on success or failure of the job.

### Adding a New Kernel

If adding a new kernel, follow these steps to update the workflow:

1. **Add Source YAML**: Create a new YAML file for the new kernel within the `sources` directory. Populate it with the necessary build commands, flags, and configurations specific to the new kernel.

2. **Update Workflow**: Update the `Kernel-Builder.yml` workflow file to include the new kernel. Add the necessary job steps to compile the kernel using the commands specified in the corresponding source YAML file.

## File Structure

The file structure of this repository is organized as follows:

- `kernel`: Contains the kernel source code and related files.
- `scripts`: Contains scripts used in the workflow such as `clone.sh`, `build.sh`, etc.
- `sources`: Contains YAML files for each source, specifying build commands, flags, and configurations.
  - Example:
    - `DivestOS-13.yaml`: Example YAML file for a kernel source.
- `Kernel-Builder.yml`: Contains the workflow definition for the Kernel Builder workflow.
- `README.md`: This file, providing instructions and information about the repository.
