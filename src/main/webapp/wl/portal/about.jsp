<%@ page language="java" pageEncoding="utf-8" %>
<%@ include file="head.jsp" %>


 <div class="easyui-layout" style="width:900px;height:100%;margin: 0px auto;">
        <div data-options="region:'north'" style="height:350px;border: none;">
            <div id="slider">
              <a  class="control_next">></a>
              <a  class="control_prev"><</a>
              <ul>
                <li style="background: url('{{STATIC_URL}}wl/img/about/G-BDLink.png') no-repeat center;background-size: contain;"></li>
                <li style="background: url('{{STATIC_URL}}wl/img/about/G-BDGIS.png') no-repeat center;background-size: contain;"></li>
                <li style="background: url('{{STATIC_URL}}wl/img/about/G-BDRS.png') no-repeat center;background-size: contain;"></li>
                <li style="background: url('{{STATIC_URL}}wl/img/about/G-BDEarth.png') no-repeat center;background-size: contain;"></li>
                <li style="background: url('{{STATIC_URL}}wl/img/about/G-BDSpatial.png') no-repeat center;background-size: contain;"></li>
              </ul>  
            </div>
        </div>
        <div data-options="region:'center'" style="border: none;">
            <p>北京众合高科信息技术有限公司，是从事空间大数据技术综合应用的高新技术公司。通过与北京大学
                                的联合创新努力，公司初步形成了集空间数据采集处理、存储管理、分发共享、应用服务等为一体
                                的空间大数据全产业链研发能力，可为军事情报、测绘地理信息、遥感、气象、减灾救灾等不同行业
                                应用提供专题解决方案、关键技术研发、系统开发与集成等一体化服务。</p>
            <p>公司在空间大数据方面具有技术领先优势，形成了“G-BD link空间大数据引擎中间件”、
                “G-BD Earth真三维数据球”、“G-BD Storage剖分存储器”、“G-BD Transfer剖分迁移器”等系列化
                “众合G-BD”产品体系，为海量、多源、异构、结构/非结构空间大数据的统一关联、整合、检索和
                                服务提供应用工具。“众合G-BD”产品体系已在作战态势、军事情报、测绘、气象、减灾（民政）、
                                住建、林业、环保、高分专项、北斗专项等行业得到了推广应用，在电子政务、农业、国土、公安、
                                国安、交通、水利、卫生、统计、地震、海洋、地调、保险等行业形成了技术与市场储备。</p>
            <p>公司拥有一支过硬的技术研发队伍，60%以上员工具有硕士学历，30%以上具有博士学位。
                                公司坚持“全球顶级空间大数据整合搜索工具提供商”的发展战略，通过不懈的努力，
                                已成为国内空间大数据技术研究和系统研发的技术领先企业。</p>
            <!-- <p>公司定位：中国大数据管理软件供应商。</p>
            <p>公司经营策略：以产品为核心、以中间件为样式；抢占标准制高点、研发核心产品；
                                宣传大招品牌、优势单位合作；快速铺开产品、跨越式发展。</p> -->
        </div>
        <div data-options="region:'east'" style="width:250px;border: none;">
            <br/><br/>
            <p>地 址：北京海淀中关村成府路205号</p>
            <p>电 话：010-62754035</p>
            <p>传 真：01062754035</p>
            <p>邮 箱：bjzhgk@163.com</p>
            <p>网 址：www.bjzhgk.com</p>
            <p>邮 编：100871</p>
        </div>
    </div>

<%@ include file="foot.jsp" %>
