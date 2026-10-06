#!/usr/bin/env bash
# Generates light/dark SVG panels for the profile README into ./assets
set -e
cd "$(dirname "$0")"
mkdir -p assets

FONT="Pretendard, 'Apple SD Gothic Neo', 'Malgun Gothic', 'Noto Sans KR', sans-serif"
UNITY='m12.9288 4.2939 3.7997 2.1929c.1366.077.1415.2905 0 .3675l-4.515 2.6076a.4192.4192 0 0 1-.4246 0L7.274 6.8543c-.139-.0745-.1415-.293 0-.3675l3.7972-2.193V0L1.3758 5.5977V16.793l3.7177-2.1456v-4.3858c-.0025-.1565.1813-.2682.318-.1838l4.5148 2.6076a.4252.4252 0 0 1 .2136.3676v5.2127c.0025.1565-.1813.2682-.3179.1838l-3.7996-2.1929-3.7178 2.1457L12 24l9.6954-5.5977-3.7178-2.1457-3.7996 2.1929c-.1341.082-.3229-.0248-.3179-.1838V13.053c0-.1565.087-.2956.2136-.3676l4.5149-2.6076c.134-.082.3228.0224.3179.1838v4.3858l3.7177 2.1456V5.5977L12.9288 0Z'
CSHARP='M1.194 7.543v8.913c0 1.103.588 2.122 1.544 2.674l7.718 4.456a3.086 3.086 0 0 0 3.088 0l7.718-4.456a3.087 3.087 0 0 0 1.544-2.674V7.543a3.084 3.084 0 0 0-1.544-2.673L13.544.414a3.086 3.086 0 0 0-3.088 0L2.738 4.87a3.085 3.085 0 0 0-1.544 2.673Zm5.403 2.914v3.087a.77.77 0 0 0 .772.772.773.773 0 0 0 .772-.772.773.773 0 0 1 1.317-.546.775.775 0 0 1 .226.546 2.314 2.314 0 1 1-4.631 0v-3.087c0-.615.244-1.203.679-1.637a2.312 2.312 0 0 1 3.274 0c.434.434.678 1.023.678 1.637a.769.769 0 0 1-.226.545.767.767 0 0 1-1.091 0 .77.77 0 0 1-.226-.545.77.77 0 0 0-.772-.772.771.771 0 0 0-.772.772Zm12.35 3.087a.77.77 0 0 1-.772.772h-.772v.772a.773.773 0 0 1-1.544 0v-.772h-1.544v.772a.773.773 0 0 1-1.317.546.775.775 0 0 1-.226-.546v-.772H12a.771.771 0 1 1 0-1.544h.772v-1.543H12a.77.77 0 1 1 0-1.544h.772v-.772a.773.773 0 0 1 1.317-.546.775.775 0 0 1 .226.546v.772h1.544v-.772a.773.773 0 0 1 1.544 0v.772h.772a.772.772 0 0 1 0 1.544h-.772v1.543h.772a.776.776 0 0 1 .772.772Zm-3.088-2.315h-1.544v1.543h1.544v-1.543Z'
GIT='M13.09 23.549a1.54 1.54 0 0 1-2.18 0L.451 13.089a1.54 1.54 0 0 1 0-2.179l7.191-7.19 2.733 2.733a1.85 1.85 0 0 0 .964 2.326v6.66a1.849 1.849 0 1 0 1.54 0V8.957l2.508 2.508a1.85 1.85 0 1 0 1.09-1.09l-2.634-2.634a1.85 1.85 0 0 0-2.378-2.377L8.73 2.63 10.91.451a1.54 1.54 0 0 1 2.179 0l10.459 10.46a1.54 1.54 0 0 1 0 2.179z'

theme() {
  if [ "$1" = light ]; then
    BG=#F6F8FA; STROKE=#D0D7DE; ACCENT=#3D4A63; PRI=#1F2328; SEC=#59636E; MUTED=#8C959F
    DOT=#7F77DD; DOT2=#C3C8D0; TILE=#FFFFFF; UNITYC=#000000
  else
    BG=#161B22; STROKE=#30363D; ACCENT=#C9D1E3; PRI=#E6EDF3; SEC=#9198A1; MUTED=#6E7681
    DOT=#9F98EC; DOT2=#484F58; TILE=#0D1117; UNITYC=#FFFFFF
  fi
}

# Section header: $1=theme $2=file $3=korean title $4=english label $5=label x
header() {
  theme "$1"
  cat > "assets/$2-$1.svg" <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="880" height="64" viewBox="0 0 880 64" font-family="$FONT">
  <text x="2" y="38" font-size="24" font-weight="800" fill="$ACCENT">$3</text>
  <text x="$5" y="37" font-size="11" font-weight="600" letter-spacing="2" fill="$MUTED">$4</text>
  <line x1="0" y1="56" x2="880" y2="56" stroke="$STROKE" stroke-width="1"/>
  <line x1="0" y1="56" x2="44" y2="56" stroke="$DOT" stroke-width="3"/>
</svg>
EOF
}

# Timeline entry: $1=y $2=dot color $3=date $4=title $5=sub $6=x
entry() {
  local x=$6
  cat <<EOF
  <circle cx="$x" cy="$1" r="5.5" fill="$2"/>
  <text x="$((x+20))" y="$(( $1 + 4 ))" font-size="12" fill="$MUTED">$3</text>
  <text x="$((x+20))" y="$(( $1 + 29 ))" font-size="18" font-weight="700" fill="$PRI">$4</text>
  <text x="$((x+20))" y="$(( $1 + 50 ))" font-size="13" fill="$SEC">$5</text>
EOF
}

# Skill tile: $1=x $2=icon path $3=icon color $4=label
tile() {
  cat <<EOF
  <rect x="$1" y="322" width="64" height="64" rx="14" fill="$TILE" stroke="$STROKE"/>
  <g transform="translate($(( $1 + 16 )) 338) scale(1.3333)"><path d="$2" fill="$3"/></g>
  <text x="$(( $1 + 32 ))" y="408" font-size="13" font-weight="700" text-anchor="middle" fill="$PRI">$4</text>
EOF
}

education() {
  theme "$1"
  {
  cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="880" height="440" viewBox="0 0 880 440" font-family="$FONT">
  <rect x="0.5" y="0.5" width="879" height="439" rx="18" fill="$BG" stroke="$STROKE"/>
  <text x="40" y="54" font-size="13" font-weight="600" letter-spacing="3" fill="$SEC">EDUCATION</text>
  <text x="40" y="98" font-size="38" font-weight="800" fill="$ACCENT">이력사항</text>
  <line x1="40" y1="122" x2="840" y2="122" stroke="$STROKE"/>

  <text x="40" y="166" font-size="20" font-weight="800" fill="$PRI">학력</text>
  <text x="88" y="165" font-size="10" font-weight="600" letter-spacing="1.5" fill="$MUTED">EDUCATION</text>
  <line x1="40" y1="180" x2="440" y2="180" stroke="$STROKE"/>
  <line x1="40" y1="180" x2="72" y2="180" stroke="$ACCENT" stroke-width="2.5"/>
  <line x1="46" y1="212" x2="46" y2="352" stroke="$STROKE" stroke-width="1.5"/>
EOF
  entry 212 "$DOT"  "2026.03 — 2026.10" "경일 IT아카데미" "교육과정 수료" 46
  entry 282 "$DOT2" "2020.03 — 2026.08" "한림대학교" "빅데이터 &amp; IT컨텐츠 전공 · 졸업" 46
  entry 352 "$DOT2" "2017.03 — 2020.02" "퇴계원고등학교" "졸업" 46
  cat <<EOF

  <text x="490" y="166" font-size="20" font-weight="800" fill="$PRI">외부활동</text>
  <text x="576" y="165" font-size="10" font-weight="600" letter-spacing="1.5" fill="$MUTED">ACTIVITY</text>
  <line x1="490" y1="180" x2="840" y2="180" stroke="$STROKE"/>
  <line x1="490" y1="180" x2="522" y2="180" stroke="$ACCENT" stroke-width="2.5"/>
EOF
  entry 212 "$DOT" "2026.05 — 현재" "동아리 61315 GameLab" "" 496
  cat <<EOF

  <text x="490" y="290" font-size="20" font-weight="800" fill="$PRI">기술</text>
  <text x="538" y="289" font-size="10" font-weight="600" letter-spacing="1.5" fill="$MUTED">SKILLS</text>
  <line x1="490" y1="304" x2="840" y2="304" stroke="$STROKE"/>
  <line x1="490" y1="304" x2="522" y2="304" stroke="$ACCENT" stroke-width="2.5"/>
EOF
  tile 490 "$UNITY"  "$UNITYC" "Unity"
  tile 578 "$CSHARP" "#8F4BD6" "C#"
  tile 666 "$GIT"    "#F05032" "Git"
  echo '</svg>'
  } > "assets/education-$1.svg"
}

# Project card (vertical, 300x252): $1=theme $2=key $3=no $4=title $5=subtitle $6=meta $7=placeholder color $8=placeholder text
# Uses assets/projects/<key>.png|.jpg as the still image when present, otherwise a placeholder.
# The play GIF (assets/projects/<key>.gif) is shown by the README's <details> toggle, not inside the card.
card() {
  local th=$1; theme "$1"; local key=$2 no=$3 title=$4 sub=$5 meta=$6 ph=$7 phtext=$8
  local img="" f
  for f in "assets/projects/$key.png" "assets/projects/$key.jpg"; do
    [ -f "$f" ] || continue
    local mime="image/${f##*.}"; [ "$mime" = image/jpg ] && mime=image/jpeg
    img="<image x=\"0\" y=\"0\" width=\"300\" height=\"170\" preserveAspectRatio=\"xMidYMid slice\" href=\"data:$mime;base64,$(base64 -w0 "$f")\"/>"
    break
  done
  [ -z "$img" ] && img="<rect x=\"0\" y=\"0\" width=\"300\" height=\"170\" fill=\"$ph\"/>
    <text x=\"150\" y=\"92\" font-size=\"20\" font-weight=\"800\" text-anchor=\"middle\" fill=\"#FFFFFF\" fill-opacity=\"0.9\">$phtext</text>"
  cat > "assets/card-$key-$th.svg" <<EOF2
<svg xmlns="http://www.w3.org/2000/svg" width="300" height="252" viewBox="0 0 300 252" font-family="$FONT">
  <defs><clipPath id="clip"><rect x="0" y="0" width="300" height="252" rx="16"/></clipPath></defs>
  <g clip-path="url(#clip)">
    <rect x="0" y="0" width="300" height="252" fill="$BG"/>
    $img
  </g>
  <rect x="0.5" y="0.5" width="299" height="251" rx="16" fill="none" stroke="$STROKE"/>
  <text x="16" y="205" font-size="13" font-weight="800" fill="$DOT">$no</text>
  <text x="40" y="206" font-size="18" font-weight="800" fill="$PRI">$title</text>
  <text x="284" y="205" font-size="11" font-weight="600" text-anchor="end" fill="$MUTED">$meta</text>
  <text x="40" y="230" font-size="12" fill="$SEC">$sub</text>
</svg>
EOF2
}

for t in light dark; do
  card $t clumsy "01" "우당탕 방범대" "3D 뱀서라이크 액션" "팀 4인 · 4주" "#085041" "Clumsy Defense Force"
  card $t pixelchroma "02" "Pixel Chroma" "2D 도트 색칠 숨바꼭질 · 멀티" "팀 4인 · 10주" "#3C3489" "Pixel Chroma"
  card $t lastember "03" "Last Ember" "소울라이크 3D 액션" "개인 · 3주" "#633806" "Last Ember"
  education $t
  header $t projects "프로젝트" "PROJECTS" 112
  header $t journey "걸어온 길" "JOURNEY" 122
done
ls assets
