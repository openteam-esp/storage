Settings.define 's3.access_key_id',           :env_var => 'S3_ACCESS_KEY_ID'
Settings.define 's3.secret_access_key',       :env_var => 'S3_SECRET_ACCESS_KEY'
Settings.define 's3.bucket_name',             :env_var => 'S3_BUCKET_NAME'

Settings.resolve!
