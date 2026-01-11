<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Analytics Dashboard | Guan Heng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/admin-dashboard.css">
    <link rel="stylesheet" href="css/visualize.css">
    <script src="js/chart.js"></script>
</head>
<body>

<nav class="navbar">
    <div class="brand-name"><i class="fa-solid fa-chart-pie"></i> KOPITIAM DATA CENTER</div>
    <div class="user-profile"><i class="fa-solid fa-circle-user"></i> Admin Mode</div>
</nav>

<div class="main-content">
    <div class="order-header">
        <a href="admin-dashboard.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
    </div>

    <div class="chart-card">
        <div class="chart-header">
            <div class="header-left">
                <h2><i class="fa-solid fa-money-bill-trend-up"></i> Part 1: Total Revenue</h2>
                <div id="p1-summary" class="summary-badge">Total: RM 0.00</div>
            </div>
            <div class="controls">
                <select id="p1-type" onchange="toggleInput('p1'); loadData('p1');">
                    <option value="week">Weekly</option>
                    <option value="month">Monthly</option>
                </select>
                <input type="week" id="p1-week" onchange="loadData('p1')">
                <input type="month" id="p1-month" style="display:none;" onchange="loadData('p1')">
            </div>
        </div>
        <div class="canvas-container">
            <canvas id="chart-p1"></canvas>
        </div>
    </div>

    <div class="chart-card">
        <div class="chart-header">
            <div class="header-left">
                <h2><i class="fa-solid fa-utensils"></i> Part 2: Product Order Volume</h2>
                <div id="p2-summary" class="summary-badge">Total: 0 items</div>
            </div>
            <div class="controls">
                <select id="p2-type" onchange="toggleInput('p2'); loadData('p2');">
                    <option value="week">Weekly</option>
                    <option value="month">Monthly</option>
                </select>
                <input type="week" id="p2-week" onchange="loadData('p2')">
                <input type="month" id="p2-month" style="display:none;" onchange="loadData('p2')">
                <select id="p2-category" class="chart-filter" onchange="loadData('p2')">
                    <option value="all">All Products</option>
                </select>
            </div>
        </div>
        <div class="canvas-container">
            <canvas id="chart-p2"></canvas>
        </div>
    </div>

    <div class="chart-card">
        <div class="chart-header">
            <div class="header-left">
                <h2><i class="fa-solid fa-tags"></i> Part 3: Revenue by Product</h2>
                <div id="p3-summary" class="summary-badge">Total: RM 0.00</div>
            </div>
            <div class="controls">
                <select id="p3-type" onchange="toggleInput('p3'); loadData('p3');">
                    <option value="week">Weekly</option>
                    <option value="month">Monthly</option>
                </select>
                <input type="week" id="p3-week" onchange="loadData('p3')">
                <input type="month" id="p3-month" style="display:none;" onchange="loadData('p3')">
                <select id="p3-category" class="chart-filter" onchange="loadData('p3')">
                    <option value="all">All Products</option>
                </select>
            </div>
        </div>
        <div class="canvas-container">
            <canvas id="chart-p3"></canvas>
        </div>
    </div>

</div>
<script>
    const getCommonOptions = (unit = "RM") => ({
        responsive: true,
        maintainAspectRatio: false,
        interaction: { mode: 'index', intersect: false },
        plugins: {
            legend: { labels: { color: '#ccc' } },
            tooltip: {
                backgroundColor: 'rgba(28, 33, 53, 0.9)',
                callbacks: { label: (ctx) => ctx.dataset.label + ": " + (unit === "RM" ? "RM " + ctx.parsed.y.toFixed(2) : ctx.parsed.y + " items") }
            }
        },
        scales: {
            x: { ticks: { color: '#888' }, grid: { display: false } },
            y: { beginAtZero: true, ticks: { color: '#888', callback: (v) => unit === "RM" ? "RM " + v : v }, grid: { color: '#2a304d' } }
        }
    });

    let chartP1, chartP2, chartP3;

    function getISOWeek(date) {
        const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
        const dayNum = d.getUTCDay() || 7;
        d.setUTCDate(d.getUTCDate() + 4 - dayNum);
        const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
        const weekNo = Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
        return d.getUTCFullYear() + "-W" + weekNo.toString().padStart(2, '0');
    }

    document.addEventListener('DOMContentLoaded', () => {
        chartP1 = new Chart(document.getElementById('chart-p1').getContext('2d'), { type: 'line', data: {labels: [], datasets: [{label: 'Total Revenue', borderColor: '#d4af37', data: []}]}, options: getCommonOptions("RM") });
        chartP2 = new Chart(document.getElementById('chart-p2').getContext('2d'), { type: 'line', data: {labels: [], datasets: []}, options: getCommonOptions("items") });
        chartP3 = new Chart(document.getElementById('chart-p3').getContext('2d'), { type: 'line', data: {labels: [], datasets: []}, options: getCommonOptions("RM") });

        const now = new Date();
        const curM = now.toISOString().substring(0, 7);
        const curW = getISOWeek(now);
        ['p1', 'p2', 'p3'].forEach(p => {
            document.getElementById(p + '-month').value = curM;
            document.getElementById(p + '-week').value = curW;
        });

        fetch('VisualizeServlet?action=getProducts').then(res => res.json()).then(data => {
            ['p2-category', 'p3-category'].forEach(id => data.products.forEach(p => document.getElementById(id).add(new Option(p, p))));
            loadData('p1'); loadData('p2'); loadData('p3');
        });
    });

    function toggleInput(p) {
        const type = document.getElementById(p + '-type').value;
        document.getElementById(p + '-week').style.display = (type === 'week' ? 'inline-block' : 'none');
        document.getElementById(p + '-month').style.display = (type === 'month' ? 'inline-block' : 'none');
    }

    function loadData(partId) {
        const type = document.getElementById(partId + '-type').value;
        const period = document.getElementById(partId + '-' + type).value;
        const category = document.getElementById(partId + '-category')?.value || 'all';
        if (!period) return;

        fetch(`VisualizeServlet?part=${partId}&type=${type}&period=${period}&category=${category}`)
            .then(res => res.json())
            .then(data => {
                const now = new Date();
                let finalLabels = [];
                let targetYear, targetMonth;

                if (type === 'month') {
                    [targetYear, targetMonth] = period.split('-').map(Number);
                    let days = new Date(targetYear, targetMonth, 0).getDate();
                    for (let d = 1; d <= days; d++) finalLabels.push(d.toString());
                } else {
                    finalLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                }

                const isFuture = (idx) => {
                    if (type === 'month') {
                        const curY = now.getFullYear(), curM = now.getMonth() + 1, curD = now.getDate();
                        if (targetYear > curY) return true;
                        if (targetYear === curY && targetMonth > curM) return true;
                        return (targetYear === curY && targetMonth === curM && (idx + 1) > curD);
                    } else {
                        const curW = getISOWeek(now), isoDay = now.getDay() || 7;
                        if (period > curW) return true;
                        return (period === curW && (idx + 1) > isoDay);
                    }
                };

                if (partId === 'p1') {
                    let vals = finalLabels.map((_, i) => isFuture(i) ? null : 0);
                    data.labels.forEach((day, i) => {
                        let idx = parseInt(day) - 1;
                        if (idx >= 0 && idx < vals.length) vals[idx] = data.values[i];
                    });
                    const total = vals.reduce((a, b) => a + (b || 0), 0);
                    document.getElementById('p1-summary').innerText = `Total: RM ${total.toLocaleString(undefined, {minimumFractionDigits: 2})}`;
                    updateSingleChart(chartP1, finalLabels, vals, 'Total Revenue');
                } else {
                    let chartObj = (partId === 'p2' ? chartP2 : chartP3);
                    let datasets = {};
                    for (let prod in data.datasets) {
                        let vals = finalLabels.map((_, i) => isFuture(i) ? null : 0);
                        data.labels.forEach((day, i) => {
                            let idx = parseInt(day) - 1;
                            if (idx >= 0 && idx < vals.length) vals[idx] = data.datasets[prod][i];
                        });
                        datasets[prod] = vals;
                    }
                    let grandTotal = 0;
                    for (let prod in datasets) {
                        grandTotal += datasets[prod].reduce((a, b) => a + (b || 0), 0);
                    }

                    const unit = (partId === 'p2') ? "items" : "RM";
                    const displayTotal = (unit === "RM") ? `Total: RM ${grandTotal.toLocaleString(undefined, {minimumFractionDigits: 2})}` : `Total: ${grandTotal} items`;
                    document.getElementById(partId + '-summary').innerText = displayTotal;
                    updateMultiChart(chartObj, { labels: finalLabels, datasets });
                }
            });
    }

    function updateSingleChart(chart, labels, values, label) {
        chart.data.labels = labels;
        chart.data.datasets[0].data = values;
        chart.data.datasets[0].label = label;
        chart.update();
    }

    function updateMultiChart(chart, data) {
        chart.data.labels = data.labels;
        chart.data.datasets = [];
        const getColor = (s) => {
            let h = 0; for (let i = 0; i < s.length; i++) h = s.charCodeAt(i) + ((h << 5) - h);
            return `hsl(${Math.abs(h) % 360}, 70%, 50%)`;
        };
        for (let key in data.datasets) {
            let c = getColor(key);
            chart.data.datasets.push({ label: key, data: data.datasets[key], borderColor: c, backgroundColor: c, tension: 0.4, fill: false, spanGaps: false });
        }
        chart.update();
    }
</script>
</body>
</html>