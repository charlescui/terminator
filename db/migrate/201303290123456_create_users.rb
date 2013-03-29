class CreateUsers < ActiveRecord::Migration
    def change
        create_table "users", :force => true do |t|
            t.string   "name"
            t.string   "login"
            t.string   "crypted_password",                          :null => false
            t.string   "password_salt",                             :null => false
            t.string   "persistence_token",                         :null => false
            t.string   "perishable_token",    :default => "",       :null => false
            t.datetime "created_at"
            t.datetime "updated_at"
            t.datetime "deleted_at"
            t.string   "single_access_token",                       :null => false
        end

        add_index "users", ["login"], :name => "index_users_on_login", :unique => true
        add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true
    end
end