<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Analytics Dashboard | Guan Heng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="css/visualize.css">
    <script src="js/chart.js"></script>
</head>
<body>

<nav class="navbar">
    <div class="brand-name"><i class="fa-solid fa-chart-pie"></i> KOPITIAM DATA CENTER</div>
    <div class="user-profile"><i class="fa-solid fa-circle-user"></i> Admin Mode</div>
</nav>

<div class="main-content">

    <div class="chart-card">
        <div class="chart-header">
            <h2><i class="fa-solid fa-money-bill-trend-up"></i> Part 1: Total Revenue</h2>
            <div class="controls">
                <select id="p1-type" onchange="toggleInput('p1')">
                    <option value="week">Weekly</option>
                    <option value="month">Monthly</option>
                </select>
                <input type="week" id="p1-week">
                <input type="month" id="p1-month" style="display:none;">
                <button onclick="loadData('p1')" class="btn-toggle">Update</button>
            </div>
        </div>
        <div class="canvas-container">
            <canvas id="chart-p1"></canvas>
        </div>
    </div>

    <div class="chart-card">
        <div class="chart-header">
            <h2><i class="fa-solid fa-utensils"></i> Part 2: Product Order Volume</h2>
            <div class="controls">
                <select id="p2-type" onchange="toggleInput('p2')">
                    <option value="week">Weekly</option>
                    <option value="month">Monthly</option>
                </select>
                <input type="week" id="p2-week">
                <input type="month" id="p2-month" style="display:none;">

                <select id="p2-category" class="chart-filter">
                    <option value="all">All Products</option>
                </select>
                <button onclick="loadData('p2')" class="btn-toggle">Update</button>
            </div>
        </div>
        <div class="canvas-container">
            <canvas id="chart-p2"></canvas>
        </div>
    </div>

    <div class="chart-card">
        <div class="chart-header">
            <h2><i class="fa-solid fa-tags"></i> Part 3: Revenue by Product</h2>
            <div class="controls">
                <select id="p3-type" onchange="toggleInput('p3')">
                    <option value="week">Weekly</option>
                    <option value="month">Monthly</option>
                </select>
                <input type="week" id="p3-week">
                <input type="month" id="p3-month" style="display:none;">

                <select id="p3-category" class="chart-filter">
                    <option value="all">All Products</option>
                </select>
                <button onclick="loadData('p3')" class="btn-toggle">Update</button>
            </div>
        </div>
        <div class="canvas-container">
            <canvas id="chart-p3"></canvas>
        </div>
    </div>

</div>

<script>
    // 1. 全局图表基础配置 (移除写死的 RM，改为动态单位)
    const getCommonOptions = (unit = "RM") => ({
        responsive: true,
        maintainAspectRatio: false,
        interaction: {
            mode: 'index',
            intersect: false
        },
        plugins: {
            legend: { labels: { color: '#ccc' } },
            tooltip: {
                enabled: true,
                backgroundColor: 'rgba(28, 33, 53, 0.9)',
                callbacks: {
                    label: function(context) {
                        let label = context.dataset.label || '';
                        let value = context.parsed.y;
                        return label + ": " + (unit === "RM" ? "RM " + value.toFixed(2) : value + " items");
                    }
                }
            }
        },
        scales: {
            x: { ticks: { color: '#888' }, grid: { display: false } },
            y: {
                beginAtZero: true,
                ticks: {
                    color: '#888',
                    callback: function (value) {
                        return unit === "RM" ? "RM " + value : value;
                    }
                },
                grid: { color: '#2a304d' }
            }
        }
    });

    // 2. 声明全局变量 (确保 loadData 能访问)
    let chartP1, chartP2, chartP3;

    // 3. 页面加载完成后初始化
    document.addEventListener('DOMContentLoaded', function() {
        // P1 初始化 (总营收 - Line)
        const ctx1 = document.getElementById('chart-p1').getContext('2d');
        chartP1 = new Chart(ctx1, {
            type: 'line',
            data: {labels: [], datasets: [{label: 'Total Revenue', borderColor: '#d4af37', data: [], tension: 0.4, fill: false}]},
            options: getCommonOptions("RM")
        });

        // P2 初始化 (销售量 - Line) - 注意：去掉 const，直接赋值给全局变量
        const ctx2 = document.getElementById('chart-p2').getContext('2d'); // 确保 HTML 里 ID 是 chart-p2
        chartP2 = new Chart(ctx2, {
            type: 'line',
            data: { labels: [], datasets: [] },
            options: getCommonOptions("items")
        });

        // P3 初始化 (分类/产品营收 - Line)
        const ctx3 = document.getElementById('chart-p3').getContext('2d'); // 确保 HTML 里 ID 是 chart-p3
        chartP3 = new Chart(ctx3, {
            type: 'line',
            data: { labels: [], datasets: [] },
            options: getCommonOptions("RM")
        });

        // 动态填充 P2 和 P3 的产品下拉框
        fetch('VisualizeServlet?action=getProducts')
            .then(response => response.json())
            .then(data => {
                ['p2-category', 'p3-category'].forEach(id => {
                    const select = document.getElementById(id);
                    if(!select) return;
                    select.options.length = 1; // 只留 All Categories
                    data.products.forEach(prod => {
                        const opt = new Option(prod, prod);
                        select.add(opt);
                    });
                });
            });
    });

    // 4. 切换周/月输入
    function toggleInput(partId) {
        const type = document.getElementById(partId + '-type').value;
        document.getElementById(partId + '-week').style.display = (type === 'week') ? 'inline-block' : 'none';
        document.getElementById(partId + '-month').style.display = (type === 'month') ? 'inline-block' : 'none';
    }

    // 5. 加载数据
    function loadData(partId) {
        const type = document.getElementById(partId + '-type').value;
        const period = document.getElementById(partId + '-' + type).value;

        // 获取分类/产品过滤器 (P2和P3现在都有了)
        let extraParams = "";
        const filterEl = document.getElementById(partId + '-category');
        if (filterEl) {
            extraParams = `&category=${filterEl.value}`;
        }

        if (!period) { alert("Please select a date!"); return; }

        fetch(`VisualizeServlet?part=${partId}&type=${type}&period=${period}${extraParams}`)
            .then(response => response.json())
            .then(data => {
                if (partId === 'p1') {
                    updateSingleChart(chartP1, data.labels, data.values, 'Total Revenue');
                } else if (partId === 'p2') {
                    updateMultiChart(chartP2, data);
                } else if (partId === 'p3') {
                    updateMultiChart(chartP3, data);
                }
            })
            .catch(err => console.error("Fetch error:", err));
    }

    // 6. 更新单线条图表 (P1)
    function updateSingleChart(chart, labels, values, labelName) {
        chart.data.labels = labels;
        chart.data.datasets[0].data = values;
        chart.data.datasets[0].label = labelName;
        chart.update();
    }

    // 7. 更新多线条图表 (P2 & P3)
    function updateMultiChart(chart, data) {
        chart.data.labels = data.labels;
        chart.data.datasets = [];

        // 自动颜色生成器
        const getDynamicColor = (str) => {
            let hash = 0;
            for (let i = 0; i < str.length; i++) {
                hash = str.charCodeAt(i) + ((hash << 5) - hash);
            }
            return `hsl(${Math.abs(hash) % 360}, 70%, 50%)`;
        };

        if (data.datasets) {
            for (let key in data.datasets) {
                const color = getDynamicColor(key);
                chart.data.datasets.push({
                    label: key,
                    data: data.datasets[key],
                    borderColor: color,
                    backgroundColor: color,
                    borderWidth: 2,
                    tension: 0.4,
                    pointRadius: 4,
                    fill: false
                });
            }
        }
        chart.update();
    }
</script>

</body>
</html>