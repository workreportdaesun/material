-- 자재발주서(order.html) 기능에 필요한 테이블.
-- Supabase SQL Editor에서 이 파일 내용을 그대로 실행해주세요.

create table if not exists public.material_orders (
  id            bigserial primary key,
  request_no    text not null,          -- 청구서번호 (예: 2026-06-24-A)
  site_name     text,                   -- 현장명
  recipient     text,                   -- 수령자
  site_contact  text,                   -- 현장연락처
  address       text,                   -- 화물 & 주소
  items         jsonb not null default '[]'::jsonb,
  -- items 배열 원소 형태:
  -- {cat, name, spec, material, unit, qty, price, need_date, vendor}
  --  cat=자재분류코드(1~10), name=품명, spec=규격, material=재질 및 기타사양,
  --  unit=단위, qty=금회청구량, price=계약단가, need_date=입고요청일, vendor=비고(승인업체)
  remarks       text,                   -- 특이사항
  created_by    text,
  created_at    timestamptz not null default now()
);

create index if not exists material_orders_request_no_idx on public.material_orders (request_no);
create index if not exists material_orders_created_at_idx on public.material_orders (created_at desc);

comment on table public.material_orders is
  '자재발주서(청구서) — 한 건당 한 행, 품목은 items(jsonb) 배열로 저장. [[project_material_inspection_report_plan]] 연장선.';

-- RLS — 이 앱은 계정 연동 없이 publishable(anon) 키로만 접속한다(다른 material/report 테이블과 동일 모델).
-- 화면 단계 보호(role-gate)일 뿐 DB 접근 자체를 막지는 않는다.
alter table public.material_orders enable row level security;
drop policy if exists material_orders_anon_all on public.material_orders;
create policy material_orders_anon_all on public.material_orders
  for all to anon, authenticated using (true) with check (true);
