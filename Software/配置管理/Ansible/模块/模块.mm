<map version="freeplane 1.9.13">
<!--To view this file, download free mind mapping software Freeplane from https://www.freeplane.org -->
<node TEXT="模块" FOLDED="false" ID="ID_696401721" CREATED="1610381621824" MODIFIED="1651126576645" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle">
    <properties fit_to_viewport="false" edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" associatedTemplateLocation="template:/standard-1.6.mm"/>

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
<node TEXT="apt" ID="ID_1714163426" CREATED="1651127429509" MODIFIED="1651127432401"/>
<node TEXT="apt_key" ID="ID_140037870" CREATED="1651127432855" MODIFIED="1651127435536"/>
<node TEXT="apt_repository" ID="ID_1144272118" CREATED="1651127436702" MODIFIED="1651127446208"/>
<node TEXT="command" ID="ID_1519416660" CREATED="1651127449309" MODIFIED="1651127453757"/>
<node TEXT="copy" ID="ID_81743562" CREATED="1651127455109" MODIFIED="1651127457192"/>
<node TEXT="dnf" ID="ID_202333397" CREATED="1651127459310" MODIFIED="1651127460693"/>
<node TEXT="file" ID="ID_1532014062" CREATED="1651127464147" MODIFIED="1651127466897"/>
<node TEXT="git" ID="ID_627919204" CREATED="1651127467332" MODIFIED="1651127472121"/>
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
