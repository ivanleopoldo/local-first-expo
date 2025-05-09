create or replace function create_todo(
  todo_id uuid,
  todo_owner_id uuid,
  todo_title varchar,
  todo_is_completed boolean,
  todo_created_at timestamp with time zone,
  todo_updated_at timestamp with time zone
) returns uuid as $$
declare new_todo_id uuid;
begin
  insert into todos (
    id,
    owner_id,
    title,
    is_completed,
    created_at,
    updated_at
  ) values (
    todo_id,
    todo_owner_id,
    todo_title,
    todo_is_completed,
    todo_created_at,
    todo_updated_at,
    now(),
    now() + interval '1 microsecond'
  ) returning id into new_todo_id;
  return new_todo_id;
end;
$$ language plpgsql;

