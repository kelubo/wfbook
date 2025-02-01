<map version="freeplane 1.9.13">
<!--To view this file, download free mind mapping software Freeplane from https://www.freeplane.org -->
<node TEXT="OpenStack" FOLDED="false" ID="ID_370215170" CREATED="1593501335199" MODIFIED="1593501343501"><hook NAME="MapStyle">
    <properties edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" fit_to_viewport="false" show_icon_for_attributes="true" show_note_icons="true"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ID="ID_271890427" ICON_SIZE="12 pt" COLOR="#000000" STYLE="fork">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="2" TRANSPARENCY="200" DASH="" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_271890427" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
<richcontent CONTENT-TYPE="plain/auto" TYPE="DETAILS"/>
<richcontent TYPE="NOTE" CONTENT-TYPE="plain/auto"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ffffff" TEXT_ALIGN="LEFT"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.selection" BACKGROUND_COLOR="#afd3f7" BORDER_COLOR_LIKE_EDGE="false" BORDER_COLOR="#afd3f7"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important" ID="ID_67550811">
<icon BUILTIN="yes"/>
<arrowlink COLOR="#003399" TRANSPARENCY="255" DESTINATION="ID_67550811"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval" SHAPE_HORIZONTAL_MARGIN="10 pt" SHAPE_VERTICAL_MARGIN="10 pt">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,11"/>
</stylenode>
</stylenode>
</map_styles>
</hook>
<node TEXT="设计理论" POSITION="right" ID="ID_1973634786" CREATED="1683597844792" MODIFIED="1683597850500"/>
<node TEXT="虚拟化技术" POSITION="right" ID="ID_1188737093" CREATED="1683597853150" MODIFIED="1683597861409">
<node TEXT="KVM" ID="ID_495434456" CREATED="1683597880974" MODIFIED="1683597884089"/>
<node TEXT="Xen" ID="ID_1008826799" CREATED="1683597884583" MODIFIED="1683597888056"/>
</node>
<node TEXT="网络架构" POSITION="right" ID="ID_1691424090" CREATED="1683597876494" MODIFIED="1683598013753">
<node TEXT="Flat" ID="ID_1161349739" CREATED="1683598015302" MODIFIED="1683598019144"/>
<node TEXT="Local" ID="ID_375349336" CREATED="1683598020079" MODIFIED="1683598022216"/>
<node TEXT="GRE" ID="ID_1056899356" CREATED="1683598022718" MODIFIED="1683598024616"/>
<node TEXT="VXLAN" ID="ID_567832608" CREATED="1683598025518" MODIFIED="1683598029952"/>
</node>
<node TEXT="组件" POSITION="right" ID="ID_936370289" CREATED="1683597866127" MODIFIED="1683598083208">
<node TEXT="Nova" ID="ID_175395424" CREATED="1683598091838" MODIFIED="1683598094399"/>
<node TEXT="Cinder" ID="ID_1471615615" CREATED="1683598094783" MODIFIED="1683598096896"/>
<node TEXT="Neutron" ID="ID_337329656" CREATED="1683598097254" MODIFIED="1683598100640"/>
<node TEXT="Horizon" ID="ID_788424117" CREATED="1683598101079" MODIFIED="1683598103992"/>
<node TEXT="Swift" ID="ID_613594193" CREATED="1683598104230" MODIFIED="1683598106752"/>
<node TEXT="Keystone" ID="ID_440466830" CREATED="1683598107198" MODIFIED="1683598112040"/>
</node>
<node TEXT="控制器" POSITION="right" ID="ID_1620999886" CREATED="1593502251010" MODIFIED="1593502253825">
<node TEXT="软件依赖" ID="ID_1842018997" CREATED="1593501361242" MODIFIED="1593501367459">
<node TEXT="RabbitMQ" ID="ID_274015411" CREATED="1593501380721" MODIFIED="1593501389194"/>
<node TEXT="Database" ID="ID_1975100207" CREATED="1593502132054" MODIFIED="1593502139143">
<node TEXT="SQLite (默认)" ID="ID_1148608076" CREATED="1593502141988" MODIFIED="1593502161782"/>
<node TEXT="MySQL" ID="ID_1701662553" CREATED="1593502146694" MODIFIED="1593502150514"/>
</node>
</node>
<node TEXT="共享服务" ID="ID_695886231" CREATED="1593502885365" MODIFIED="1593502890725">
<node TEXT="Keystone" ID="ID_737849067" CREATED="1593503111788" MODIFIED="1593503116897"/>
<node TEXT="Glance" ID="ID_1931355648" CREATED="1593503118501" MODIFIED="1593503121366"/>
<node TEXT="Ceilometer" ID="ID_846463002" CREATED="1593503122634" MODIFIED="1593503127211"/>
<node TEXT="Heat" ID="ID_149562237" CREATED="1593503135591" MODIFIED="1593503138134"/>
<node TEXT="Trove" ID="ID_969179575" CREATED="1593503138758" MODIFIED="1593503141081"/>
</node>
</node>
</node>
</map>
