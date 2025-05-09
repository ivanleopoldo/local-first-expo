create or replace function update_todo(
  todo_id uuid,
  todo_owner_id uuid,
  todo_title varchar,
  todo_is_completed boolean,
  todo_created_at timestamp with time zone,
  todo_updated_at timestamp with time zone
) returns uuid as $$
begin
  update todos
  set title = todo_title,
      owner_id = todo_owner_id,
      is_completed = todo_is_completed,
      updated_at = todo_updated_at,
      last_modified_at = now()
  where id = todo_id;
  
  return todo_id;
end;
$$ language plpgsql;
