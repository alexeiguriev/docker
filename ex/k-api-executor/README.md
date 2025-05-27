# Deployment Instructions

## build the docker images
```sh
make build
```
**check if docker images created**
```sh
docker images
```
shloud be the images: 'api-image' and 'executor-image'

## Deploying with Helm

1. **Install with helm**
    ```sh
    make helm-install
    ```
    or
    ```sh
    make helm-install STAGE=prod
    ```

2. **To uninstall**:
    ```sh
    make helm-uninstall
    ```

## Deploying with Kubernetes Manifests

1. **Apply Manifests**:
    ```sh
    make deploy
    ```

2. **To remove the deployment**:
    ```sh
    make clean
    ```

## Deploying skaffold

1. **build docker images**:
    ```sh
    skaffold build
    ```

2. **Build and deploy**:
    ```sh
    skaffold run
    ```
    
3. **Deploy existing docker images**:
    ```sh
    skaffold deploy --images api-image=api-image:<tag> --images executor-image=executor-image:<tag>
    ```

## Test
    `
    make test

    or

    make curl
    
    or

    make curl-service-node
    `

# For more detailed -> check the Makefile