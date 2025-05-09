create table if not exists todos (
  id uuid not null default gen_random_uuid(),
  primary key(id),

  title text not null,
  is_completed boolean not null default false,
  owner_id uuid not null references auth.users on delete cascade,

  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now(),
 
  delete_at timestamp with time zone default null,

  server_created_at timestamp with time zone default now(),
  last_modified_at timestamp with time zone default now()
);

alter table todos enable row level security;

create policy "Users can select their own todos"
  on todos for select 
  using (owner_id = auth.uid());

create policy "Users can insert their own todos"
  on todos for insert 
  with check (owner_id = auth.uid());

create policy "Users can update their own todos"
  on todos for update 
  using (owner_id = auth.uid())
  with check (owner_id = auth.uid());

create policy "Users can delete their own todos"
  on todos for delete 
  using (owner_id = auth.uid());

