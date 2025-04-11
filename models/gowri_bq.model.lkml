connection: "gowri-bigquery"
#label: "Gowri testing"
# include all the views
include: "/views/**/*.view.lkml"
#include: "/views/distribution_centers.view.lkml"
#include: "/test.view.lkml"
#include: "/test1.dashboard.lookml"
#include: "/test1/test_model.model.lkml"

fiscal_month_offset: 3

named_value_format: gowri_testing {
  value_format: "\"€\"0.000,\" K\""
  strict_value_format: yes
}

datagroup: gowri_bq_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  sql_trigger: SELECT EXTRACT(HOUR FROM CURRENT_TIMESTAMP()) ;;
  max_cache_age: "1 hour"
}

persist_with: gowri_bq_default_datagroup
#access_grant: test1 {
#  user_attribute: test_attribute
#  allowed_values: [ "Ada" ]
#}

explore: products {
  sql_table_name: looker-support-test-project.vpenumallu_BQ2.products ;;
  #group_label: "Online Store Queries"
  view_label: "PRODUCTS"
 # fields: [products.brand,distribution_centers.id,distribution_centers.name]
  join: distribution_centers {
 sql_table_name: looker-support-test-project.vpenumallu_BQ2.distribution_centers ;;
# fields: [distribution_centers.name]
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: events {
 # sql_always_where: ${created_date} > '2025-01-01' ;;
sql_always_where: users.city = "Ada";;
#always_join: [users]
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
 #view_label: "Job owner"
  view_label: "Events"
# Place in `gowri_bq` model

      query: testing1 {
        label: "quick start testing"
        dimensions: [user_id, users.age, users.city, users.gender]
        measures: [products.count]
        filters: [users.age: ">30"]
        pivots: [users.city]
      }


  join: users {
   view_label: "Events"
    #view_label: "Order Items"
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    view_label: "Events inventory"
    sql_where: ${inventory_items.cost}>100 ;;
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    view_label: "Events"
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
    #fields: [products.id]
  }

  join: orders {
   view_label: "Events inventory"
    #required_access_grants: [test1]
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
    relationship: many_to_one
    #fields: []
  }

  join: distribution_centers {
    #view_label: "Job owner1"
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

}

explore: sdt {}

explore: users {
  #required_access_grants: [test1]
  cancel_grouping_fields: [users.age]
  access_filter: {
    field: users.city
    user_attribute: allowed_states
  }
  #sql_always_having:${users.test121} >10 ;;
}

explore: orders {
  #extension: required
 # view_label: "ORDERS"
always_filter: {
  filters: [orders.gender: "f",users.city: "Ada"]
}
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: distribution_centers {
  #view_name: distribution_centers
  view_label: "DIST"
  #extension: required
}
explore: derived_table1 {}
explore: inventory_items {
# view_label: "IVS"
fields: [inventory_items*]
#extends: [orders,users]
#hidden: no
  #join: products {
  #  type: left_outer
   # sql_on: ${inventory_items.product_id} = ${products.id} ;;
    #relationship: many_to_one
  #}

  #join: distribution_centers {
   # type: left_outer
    #sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    #relationship: many_to_one
  #}
}
# Place in `gowri_bq` model
# Place in `gowri_bq` model


# Place in `gowri_bq` model
