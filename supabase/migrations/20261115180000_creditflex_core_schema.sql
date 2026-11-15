begin;
create table public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null default '' check (char_length(display_name)<=120),
 created_at timestamptz not null default now()
);
create table public.memberships (
 user_id uuid primary key references auth.users(id) on delete cascade,
 status text not null check (status in ('inactive','active','past_due','canceled')),
 access_until timestamptz,
 updated_at timestamptz not null default now()
);
create table public.courses (
 id uuid primary key default gen_random_uuid(),
 slug text unique not null, title text not null, description text not null,
 published boolean not null default false
);
create table public.lessons (
 id uuid primary key default gen_random_uuid(),
 course_id uuid not null references public.courses(id) on delete cascade,
 position integer not null check(position>0), title text not null, content text not null,
 is_preview boolean not null default false, published boolean not null default false,
 unique(course_id,position)
);
create table public.lesson_progress (
 user_id uuid not null references auth.users(id) on delete cascade,
 lesson_id uuid not null references public.lessons(id) on delete cascade,
 completed_at timestamptz not null default now(),
 primary key(user_id,lesson_id)
);
create table public.disputes (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 bureau text not null check(bureau in ('equifax','experian','transunion','furnisher')),
 creditor_name text not null check(char_length(creditor_name) between 1 and 200),
 reason text not null check(char_length(reason) between 1 and 4000),
 status text not null default 'draft' check(status in ('draft','sent','responded','resolved','closed')),
 created_at timestamptz not null default now(),
 unique(id,user_id)
);
create table public.dispute_letters (
 id uuid primary key default gen_random_uuid(),
 dispute_id uuid not null, user_id uuid not null,
 body text not null check(char_length(body) between 1 and 20000),
 created_at timestamptz not null default now(),
 foreign key(dispute_id,user_id) references public.disputes(id,user_id) on delete cascade
);
create table public.credit_card_offers (
 id uuid primary key default gen_random_uuid(),
 issuer text not null, product_name text not null,
 official_url text not null check(official_url ~ '^https://'),
 terms_url text not null check(terms_url ~ '^https://'),
 verified_at timestamptz not null, published boolean not null default false,
 unique(issuer,product_name)
);
create index disputes_user_idx on public.disputes(user_id);
create index letters_user_idx on public.dispute_letters(user_id);
create index progress_lesson_idx on public.lesson_progress(lesson_id);
create function public.has_active_membership() returns boolean language sql stable security invoker set search_path = '' as $$
 select exists(select 1 from public.memberships where user_id=(select auth.uid()) and status='active' and access_until>now())
$$;
revoke all on function public.has_active_membership() from public;
grant execute on function public.has_active_membership() to authenticated;
alter table public.profiles enable row level security;
alter table public.memberships enable row level security;
alter table public.courses enable row level security;
alter table public.lessons enable row level security;
alter table public.lesson_progress enable row level security;
alter table public.disputes enable row level security;
alter table public.dispute_letters enable row level security;
alter table public.credit_card_offers enable row level security;
revoke all on public.profiles,public.memberships,public.courses,public.lessons,public.lesson_progress,public.disputes,public.dispute_letters,public.credit_card_offers from anon,authenticated;
grant select,insert,update on public.profiles to authenticated;
grant select on public.memberships to authenticated;
grant select on public.courses,public.lessons,public.credit_card_offers to anon,authenticated;
grant select,insert on public.lesson_progress to authenticated;
grant select,insert,update on public.disputes to authenticated;
grant select,insert on public.dispute_letters to authenticated;
create policy profile_read on public.profiles for select to authenticated using(id=(select auth.uid()));
create policy profile_insert on public.profiles for insert to authenticated with check(id=(select auth.uid()));
create policy profile_update on public.profiles for update to authenticated using(id=(select auth.uid())) with check(id=(select auth.uid()));
create policy membership_read on public.memberships for select to authenticated using(user_id=(select auth.uid()));
create policy course_read on public.courses for select to anon,authenticated using(published);
create policy preview_read on public.lessons for select to anon,authenticated using(published and is_preview and exists(select 1 from public.courses c where c.id=course_id and c.published));
create policy paid_read on public.lessons for select to authenticated using(published and (select public.has_active_membership()) and exists(select 1 from public.courses c where c.id=course_id and c.published));
create policy progress_read on public.lesson_progress for select to authenticated using(user_id=(select auth.uid()));
create policy progress_insert on public.lesson_progress for insert to authenticated with check(user_id=(select auth.uid()) and exists(select 1 from public.lessons l where l.id=lesson_id));
create policy dispute_read on public.disputes for select to authenticated using(user_id=(select auth.uid()));
create policy dispute_insert on public.disputes for insert to authenticated with check(user_id=(select auth.uid()) and (select public.has_active_membership()));
create policy dispute_update on public.disputes for update to authenticated using(user_id=(select auth.uid()) and (select public.has_active_membership())) with check(user_id=(select auth.uid()) and (select public.has_active_membership()));
create policy letter_read on public.dispute_letters for select to authenticated using(user_id=(select auth.uid()));
create policy letter_insert on public.dispute_letters for insert to authenticated with check(user_id=(select auth.uid()) and (select public.has_active_membership()));
create policy offers_read on public.credit_card_offers for select to anon,authenticated using(published);
commit;