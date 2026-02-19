class AddServiceNameToActiveStorageBlobs < ActiveRecord::Migration[6.1]
  def up
    return if column_exists?(:active_storage_blobs, :service_name)

    add_column :active_storage_blobs, :service_name, :string

    ActiveStorage::Blob.reset_column_information
    service_name = ActiveStorage::Blob.service&.name || "local"
    ActiveStorage::Blob.unscoped.where(service_name: nil).update_all(service_name: service_name)

    change_column_null :active_storage_blobs, :service_name, false
  end

  def down
    return unless column_exists?(:active_storage_blobs, :service_name)

    remove_column :active_storage_blobs, :service_name
  end
end
