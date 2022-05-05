<map version="freeplane 1.9.13">
<!--To view this file, download free mind mapping software Freeplane from https://www.freeplane.org -->
<node TEXT="模块" FOLDED="false" ID="ID_696401721" CREATED="1610381621824" MODIFIED="1651126576645" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle">
    <properties fit_to_viewport="false" edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" associatedTemplateLocation="template:/standard-1.6.mm" show_icon_for_attributes="true" show_note_icons="true"/>

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
<stylenode LOCALIZED_TEXT="defaultstyle.selection" BACKGROUND_COLOR="#4e85f8" BORDER_COLOR_LIKE_EDGE="false" BORDER_COLOR="#4e85f8"/>
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
<hook NAME="AutomaticEdgeColor" COUNTER="9" RULE="ON_BRANCH_CREATION"/>
<node TEXT="amazon.aws" POSITION="right" ID="ID_1299698040" CREATED="1651127158211" MODIFIED="1651127166223">
<edge COLOR="#ff0000"/>
</node>
<node TEXT="ansible.builtin" POSITION="right" ID="ID_843885031" CREATED="1651127166814" MODIFIED="1651127175240">
<edge COLOR="#0000ff"/>
<node TEXT="Modules" ID="ID_92909230" CREATED="1651127311318" MODIFIED="1651127400463">
<node TEXT="add_host" ID="ID_1525159559" CREATED="1651127404236" MODIFIED="1651127416851"/>
<node TEXT="apt_key" ID="ID_140037870" CREATED="1651127432855" MODIFIED="1651127435536"/>
<node TEXT="command" ID="ID_1519416660" CREATED="1651127449309" MODIFIED="1651127453757"/>
<node TEXT="git" ID="ID_627919204" CREATED="1651127467332" MODIFIED="1651127472121"/>
<node TEXT="文件模块" ID="ID_94612666" CREATED="1651743314841" MODIFIED="1651743319247">
<node TEXT="copy" ID="ID_81743562" CREATED="1651127455109" MODIFIED="1651127457192">
<node TEXT="将本地文件复制到受控主机" ID="ID_1615492363" CREATED="1651743350862" MODIFIED="1651743363143"/>
</node>
<node TEXT="file" ID="ID_1532014062" CREATED="1651127464147" MODIFIED="1651127466897">
<node TEXT="设置文件的权限和其他属性" ID="ID_290566559" CREATED="1651743365838" MODIFIED="1651743374794"/>
</node>
<node TEXT="lineinfile" ID="ID_1315495410" CREATED="1651743383902" MODIFIED="1651743388656">
<node TEXT="确认特定行是否在文件中" ID="ID_832448737" CREATED="1651743390006" MODIFIED="1651743411704"/>
</node>
<node TEXT="synchronize" ID="ID_1384083911" CREATED="1651743416189" MODIFIED="1651743425096">
<node TEXT="使用rsync同步内容" ID="ID_1434358733" CREATED="1651743426126" MODIFIED="1651743435936"/>
</node>
</node>
<node TEXT="软件包模块" ID="ID_1137171509" CREATED="1651743460350" MODIFIED="1651743469103">
<node TEXT="apt" ID="ID_1714163426" CREATED="1651127429509" MODIFIED="1651127432401"/>
<node TEXT="apt_repository" ID="ID_1144272118" CREATED="1651127436702" MODIFIED="1651127446208"/>
<node TEXT="dnf" ID="ID_202333397" CREATED="1651127459310" MODIFIED="1651127460693"/>
<node TEXT="gem" ID="ID_1023851179" CREATED="1651743547437" MODIFIED="1651743552798">
<node TEXT="管理 Ruby gem" ID="ID_1429244805" CREATED="1651743552800" MODIFIED="1651743562446"/>
</node>
<node TEXT="package" ID="ID_1433976149" CREATED="1651743472911" MODIFIED="1651743479111">
<node TEXT="使用操作系统本机的自动检测软件包管理器管理软件包" ID="ID_598103950" CREATED="1651743480437" MODIFIED="1651743506207"/>
</node>
<node TEXT="pip" ID="ID_1651533132" CREATED="1651743566391" MODIFIED="1651743568566">
<node TEXT="从 PyPI 管理python软件包" ID="ID_1322797125" CREATED="1651743571999" MODIFIED="1651743601549"/>
</node>
<node TEXT="yum" ID="ID_1398420446" CREATED="1651743516550" MODIFIED="1651743520272"/>
</node>
<node TEXT="系统模块" ID="ID_261028844" CREATED="1651743602646" MODIFIED="1651743618023">
<node TEXT="firewalld" ID="ID_1293671558" CREATED="1651743607957" MODIFIED="1651743623719"/>
<node TEXT="reboot" ID="ID_197722697" CREATED="1651743624230" MODIFIED="1651743626080"/>
<node TEXT="service" ID="ID_666313280" CREATED="1651743627053" MODIFIED="1651743629022"/>
<node TEXT="user" ID="ID_788662529" CREATED="1651743629461" MODIFIED="1651743631241"/>
</node>
<node TEXT="Net Tools 模块" ID="ID_713276679" CREATED="1651743636797" MODIFIED="1651743650687">
<node TEXT="get_url" ID="ID_195271660" CREATED="1651743651942" MODIFIED="1651743666598">
<node TEXT="通过HTTP、HTTPS或FTP下载文件" ID="ID_1341328245" CREATED="1651743668621" MODIFIED="1651743699302"/>
</node>
<node TEXT="nmcli" ID="ID_955536112" CREATED="1651743701077" MODIFIED="1651743707631">
<node TEXT="管理网络" ID="ID_1670870861" CREATED="1651743709701" MODIFIED="1651743716182"/>
</node>
<node TEXT="uri" ID="ID_1456353675" CREATED="1651743718125" MODIFIED="1651743723552">
<node TEXT="与Web服务交互" ID="ID_199916539" CREATED="1651743724880" MODIFIED="1651743737502"/>
</node>
</node>
</node>
</node>
<node TEXT="ansible.netcommon" POSITION="right" ID="ID_1836933604" CREATED="1651127186817" MODIFIED="1651127196099">
<edge COLOR="#00ff00"/>
</node>
<node TEXT="ansible.posix" POSITION="right" ID="ID_1218196042" CREATED="1651127205389" MODIFIED="1651127212062">
<edge COLOR="#ff00ff"/>
</node>
<node TEXT="ansible.utils" POSITION="right" ID="ID_776384699" CREATED="1651127212681" MODIFIED="1651127217083">
<edge COLOR="#00ffff"/>
</node>
<node TEXT="ansible.windows" POSITION="right" ID="ID_1717815538" CREATED="1651127218065" MODIFIED="1651127224145">
<edge COLOR="#7c0000"/>
</node>
<node TEXT="community.general" POSITION="right" ID="ID_1929336158" CREATED="1651127224874" MODIFIED="1651127251802">
<edge COLOR="#00007c"/>
</node>
<node TEXT="community.mysql" POSITION="right" ID="ID_393630768" CREATED="1651127256759" MODIFIED="1651127263913">
<edge COLOR="#007c00"/>
</node>
<node TEXT="community.zabbix" POSITION="right" ID="ID_519980291" CREATED="1651127265010" MODIFIED="1651127277662">
<edge COLOR="#7c007c"/>
</node>
</node>
</map>
