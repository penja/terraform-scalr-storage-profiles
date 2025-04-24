# Common Module for Scalr Storage Profiles

This module contains shared variables used by all the Scalr storage profile modules.

## Purpose

The common module provides a centralized place for variables that are used across multiple storage profile modules:

- `scalr_hostname`: The hostname of the Scalr server
- `scalr_account_name`: The name of your Scalr account
- `scalr_token`: The API token for authenticating with Scalr

## Usage

This module is used internally by the other storage profile modules and doesn't need to be used directly. When you use one of the storage profile modules (AWS S3, Azure Resource Manager, or Google Cloud Storage), it will automatically use this common module.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| scalr_hostname | The hostname of the Scalr server. | `string` | `"scalr.io"` | no |
| scalr_account_name | Scalr account name | `string` | n/a | yes |
| scalr_token | Optional Scalr access token for the curl request. For security, do not hardcode this value in your configuration. Use environment variables or other secure methods instead. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| scalr_hostname | The hostname of the Scalr server. |
| scalr_account_name | Scalr account name |
| scalr_token | Scalr access token for the curl request. |