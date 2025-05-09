create or replace function push(
  changes jsonb,
  todo_owner_id uuid
) returns void as $$
declare
  new_todo jsonb;
  updated_todo jsonb;
begin
  for new_todo in select jsonb_array_elements((changes->'todos'->'created')) loop perform create_todo(
    (new_todo->>'id')::uuid,
    todo_owner_id::uuid,
    (new_todo->>'title'),
    epoch_to_timestamp(new_todo->>'created_at'),
    epoch_to_timestamp(new_todo->>'updated_at')
  );
  end loop;

  with changes_data as (
    select jsonb_array_elements_text(changes->'todos'->'deleted')::uuid as deleted
  )

  update todos
  set deleted_at = now(),
      last_modified_at = now()
  from changes_data
  where todos.id = changes_data.deleted;

  for updated_todo in select jsonb_array_elements((changes->'todos'->'updated')) loop perform update_todo(
    (updated_todo->>'id')::uuid,
    todo_owner_id::uuid,
    (updated_todo->>'title'),
    (updated_todo->>'is_completed')::boolean,
    epoch_to_timestamp(updated_todo->>'updated_at')
  );
  end loop;
end;
$$ language plpgsql;
