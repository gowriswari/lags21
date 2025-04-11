# If necessary, uncomment the line below to include explore_source.
# include: "gowri_bq.model.lkml"

view: derived_table1 {
  derived_table: {
  #  persist_for: "2 minutes"
    publish_as_db_view: yes
    sql_trigger_value: SELECT EXTRACT(HOUR FROM CURRENT_TIMESTAMP()) ;;
    explore_source: order_items {
      #bind_all_filters: yes
      filters: [users.state: "Ada"]
      column: count { field: distribution_centers.count }
      column: city { field: users.city }
      column: gender { field: users.gender }
      column: count { field: products.count }
      column: count_actual1 {}
      column: test121 { field: users.test121 }
      column: status {}
      column: state { field: users.state }
      column: id {}
      derived_column: rank {
        sql: RANK() OVER (ORDER BY state DESC) ;;
      }
      #bind_all_filters: yes
    }


  }
  dimension: id {
    type: number
    primary_key: yes
    label: "Events Id"
    description: ""
    sql: ${TABLE}.id ;;
   # sql: ${users.id} ;;
  }
  dimension: count {
    description: ""
    type: number
  }
  dimension: city {
    label: "Events City"
    description: ""
  }
  dimension: gender {
    label: "Events Gender"
    description: ""
  }
  dimension: count_actual1 {
    label: "Events Count Actual1"
    description: ""
    type: number
  }
  dimension: test121 {
    label: "Events Test121"
    description: ""
    type: number
  }
  dimension: status {
    label: "Events Status"
    description: ""
  }
  dimension: state {
    label: "Events State"
    description: ""
  }
}
