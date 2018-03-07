<%-- 
    Document   : COFIDE_Char
    Created on : 28-may-2016, 16:31:35
    Author     : juliomondragon
--%>

<html>
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script>
        $(function () {
            $(document).ready(function () {
                // Build the chart
                $('#container').highcharts({
                    chart: {type: 'pie'},
                    series: [{
                            data: [{
                                    name: 'Vendidos',
                                    y: 40,
                                }, {
                                    name: 'DIsponibles',
                                    y: 10
                                }]
                        }]
                });
            });
        });
    </script> 
    <body>
        <div id="container" style="min-width: 310px; height: 400px; max-width: 600px; margin: 0 auto"></div>
    </body>
</html>