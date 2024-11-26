VNG Storage ActiveStorage is a custom service of ActiveStorage to support [VNG Cloud](https://vngcloud.vn). This service is reuse S3 SDK from S3 Service of ActiveStorage.

# Installation

```sh
gem 'vng_storage_active_storage'
```

# Configuration

```yaml
vstorage:
  service: Vstorage
  endpoint: <%= ENV['VCLOUD_ENDPOINT'] %>
  region: <%= ENV['VCLOUD_REGION'] %>
  bucket: <%= ENV['VCLOUD_BUCKET'] %>
  access_key_id: <%= ENV['VCLOUD_ACCESS_KEY'] %>
  secret_access_key: <%= ENV['VCLOUD_SECRET_KEY'] %>
  public: true
  force_path_style: true
  upload:
    project_id: <%= ENV['VCLOUD_PROJECT_ID'] %>
    client_id: <%= ENV['VCLOUD_SERVICE_ACCOUNT_CLIENT_ID'] %>
    client_secret: <%= ENV['VCLOUD_SERVICE_ACCOUNT_CLIENT_SECRET'] %>
```
