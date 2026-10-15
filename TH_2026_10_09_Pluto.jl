### A Pluto.jl notebook ###
# v1.0.4

using Markdown
using InteractiveUtils

# ╔═╡ 09102026-0000-4000-8000-000000000001
begin
    READ_DATA = true
    RUN_APP = true
    ROOT_DATA = joinpath(@__DIR__, "data")
end

# ╔═╡ 09102026-0000-4000-8000-000000000002
AppCore = let
    sandbox = Module(:ThucHanhNgay0910)
    Base.include(sandbox, joinpath(@__DIR__, "TH_2026_10_09_Sinh_vien.jl"))
    Base.invokelatest(getfield, sandbox, :GiaoDon)
end

# ╔═╡ 09102026-0000-4000-8000-000000000003
"""Mục tiêu: giải thích một luồng từ CSV đến giao đơn. Hoàn thiện bốn hàm trong file Julia chung; tạo dữ liệu bằng chế độ --data trước khi bật READ_DATA và RUN_APP. Bổ sung các ô ghi ý tưởng, giả mã, điều kiện áp dụng, chi phí và liên kết GitHub."""

# ╔═╡ 09102026-0000-4000-8000-000000000004
ho_so = AppCore.profile("N24DCDT105")

# ╔═╡ 09102026-0000-4000-8000-000000000005
du_lieu = READ_DATA ? AppCore.read_data(joinpath(ROOT_DATA,"N24DCDT105")) : nothing

# ╔═╡ 09102026-0000-4000-8000-000000000006
bao_cao = !RUN_APP || du_lieu === nothing ? nothing : let
    s = AppCore.build_session(du_lieu.orders,du_lieu.edges,ho_so)
    r = AppCore.plan!(s)
    trace = NamedTuple[]
    save(label) = push!(trace,(buoc=label,queue=AppCore.queue_values(s.pending),
                              stack=copy(s.completed),spent=s.spent,earned=s.earned))
    save("Sau lập kế hoạch")
    AppCore.deliver!(s); save("Sau giao một đơn")
    AppCore.undo!(s); save("Sau hoàn tác")
    while s.pending.count > 0
        AppCore.deliver!(s)
    end
    save("Sau giao hết")
    (chi_phi=copy(s.costs),tuyen=deepcopy(s.routes),chon=copy(s.selected_ids),
     loi_ich_toi_uu=r.optimal.value,truy_vet=trace,bat_bien=AppCore.check_invariants(s))
end

# ╔═╡ 09102026-0000-4000-8000-000000000007
md"""
### Giải thích thuật toán quy hoạch động

MSSV: N24DCDT105

F(i,b) là lợi ích tối đa khi xét i đơn hàng đầu tiên
với ngân sách thời gian b.

- Không chọn đơn i: F(i-1,b).
- Chọn đơn i: F(i-1,b-w_i) + v_i.
- Lấy phương án có lợi ích lớn nhất.

Trong Julia, ô F(i,b) được lưu ở table[i+1,b+1]
do chỉ số mảng bắt đầu từ 1.

Nhánh chọn sử dụng hàng i-1 để tránh chọn
một đơn hàng nhiều lần.

Kết quả thực nghiệm:
- Ngân sách: 30.
- Đơn tối ưu: [5,2,7,9,6].
- Thời gian sử dụng: 29.
- Lợi ích tối ưu: 44.
- DP = 44, tham lam = 44, vét cạn = 44.
"""

# ╔═╡ 09102026-0000-4000-8000-000000000008
md"""
## Minh chứng hoàn thành bài thực hành

**MSSV:** N24DCDT105

### 1. Kết quả kiểm thử

- Merge Sort: 8/8 đạt.
- Binary Search: 5/5 đạt.
- BFS: 7/7 đạt.
- Knapsack: 12/12 đạt.
- Kiểm thử dữ liệu: 12/12 đạt.
- Kiểm thử ứng dụng: 16/16 đạt.

**Tổng cộng: 60/60 phép kiểm thử đạt.**

### 2. Kết quả giao hàng

- Số đơn hàng: 10.
- Ngân sách: 30.
- Đơn được chọn: [5, 2, 7, 9, 6].
- Số đơn đã giao: 5.
- Tổng thời gian sử dụng: 29.
- Tổng lợi ích: 44.
- Kiểm tra bất biến: true.

### 3. Các file minh chứng

- TH_2026_10_09_Sinh_vien.jl
- TH_2026_10_09_Kiem_thu.jl
- TH_2026_10_09_Pluto.jl
- data/N24DCDT105/ket_qua.csv
- ket_qua_kiem_thu.txt

### 4. GitHub

- Repository URL: Chưa cập nhật.
- Commit SHA: Chưa cập nhật.
"""

# ╔═╡ 09102026-0000-4000-8000-000000000009
if RUN_APP && bao_cao !== nothing
    println("Kết quả từ cùng lõi ứng dụng Julia:")
    show(stdout, "text/plain", bao_cao)
    println()
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.7"
manifest_format = "2.0"
project_hash = "71853c6197a6a7f222db0f1978c7cb232b87c5ee"

[deps]
"""

# ╔═╡ Cell order:
# ╠═09102026-0000-4000-8000-000000000001
# ╠═09102026-0000-4000-8000-000000000002
# ╠═09102026-0000-4000-8000-000000000003
# ╠═09102026-0000-4000-8000-000000000004
# ╠═09102026-0000-4000-8000-000000000005
# ╠═09102026-0000-4000-8000-000000000006
# ╠═09102026-0000-4000-8000-000000000007
# ╠═09102026-0000-4000-8000-000000000008
# ╠═09102026-0000-4000-8000-000000000009
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
