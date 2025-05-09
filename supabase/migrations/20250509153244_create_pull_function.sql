create or replace function pull(
  todo_owner_id uuid,
  last_pulled_at bigint default 0
) returns jsonb as $$
declare 
  _ts timestamp with time zone;
  _todos jsonb;
begin
  select jsonb_build_object(
    'created', '[]'::jsonb,
    'updated', coalesce(
      jsonb_agg(
        jsonb_build_object(
          'id', id,
          'title', title,
          'is_completed', is_completed,
          'created_at', created_at,
          'updated_at', updated_at
        )
      ) filter (
          where t.deleted_at is null and t.last_modified_at > _ts and t.owner_id = todo_owner_id
      ), '[]'::jsonb
    ),
    'deleted', coalesce(
      jsonb_agg(
        to_jsonb(t.id)
      ) filter (
        where t.deleted_at is null and t.last_modified_at > _ts and t.owner_id = todo_owner_id
      )
    )
  ) into _todos from todos t;

  return jsonb_build_object(
    'changes', jsonb_build_object(
      'todos', _todos
    ),
    'timestamp', timestamp_to_epoch(now())
  );
end;
$$ language plpgsql;
