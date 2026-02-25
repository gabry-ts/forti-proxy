# Contributing to forti-proxy

Thank you for contributing! Here's how to get started.

## Workflow

1. **Fork** the repository on GitHub
2. **Clone** your fork locally: `git clone https://github.com/your-username/forti-proxy.git`
3. **Create a branch**: `git checkout -b feature/your-feature-name`
4. **Make your changes** and test them
5. **Commit** your changes with clear commit messages
6. **Push** to your fork: `git push origin feature/your-feature-name`
7. **Open a Pull Request** on the main repository

## Building Locally

Build the Docker image locally:

```bash
docker build -t forti-proxy:latest .
```

Run the container:

```bash
docker run -p 8080:8080 forti-proxy:latest
```

Refer to the main README for additional configuration and usage details.

## Code Standards

- Write clear, descriptive commit messages
- Keep commits focused on a single change
- Test your changes before opening a PR
- Follow existing code style and conventions

Thank you for helping improve forti-proxy!
