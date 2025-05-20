{$IF defined(IOS) or defined(ANDROID)}
  {$DEFINE IS_MOBILE}
{$ENDIF}

{$IF Defined(CompilarPara_PA) or Defined(CompilarPara_MULTIPA) or Defined(CompilarPara_TGS) or Defined(CompilarPara_ONLINE) or Defined(CompilarPara_TGSMOBILE)}
  {$DEFINE FIREMONKEY}
{$ENDIF}

{$IF (not Defined(IS_MOBILE)) and (not Defined(WIN64))}
  {$DEFINE SuportaQuickRep}
{$ENDIF}

{$IFDEF CompilarPara_PA}
  {$DEFINE CompilarPara_PA_MULTIPA}
  {$IF (not Defined(IS_MOBILE)) and (not Defined(WIN64))}
    {$DEFINE SuportaCodigoBarras}
    {$DEFINE SuportaPortaCom}
  {$ENDIF}
{$ENDIF}

{$IFDEF CompilarPara_MULTIPA}
  {$DEFINE CompilarPara_PA_MULTIPA}
  {$IF (not Defined(IS_MOBILE)) and (not Defined(WIN64))}
    {$DEFINE SuportaCodigoBarras}
    {$DEFINE SuportaPortaCom}
  {$ENDIF}
{$ENDIF CompilarPara_MULTIPA}

{$IFDEF CompilarPara_TGS}
  {$DEFINE CompilarPara_TGS_ONLINE}
{$ENDIF CompilarPara_TGS}

{$IFDEF CompilarPara_ONLINE}
  {$DEFINE CompilarPara_TGS_ONLINE}
  {$DEFINE SuportaPortaCom}
{$ENDIF CompilarPara_ONLINE}

{$IFDEF CompilarPara_SICS}
  {$DEFINE SuportaDLL}
  {$DEFINE SuportaPing}
  {$DEFINE SuportaSMS}
  {$DEFINE SuportaEmail}
  {$DEFINE SuportaPortaCom}
{$ENDIF CompilarPara_SICS}

{$IFDEF CompilarPara_SCC}
  {$DEFINE SuportaDLL}
{$ENDIF CompilarPara_SCC}


{$IFDEF CompilarPara_CALLCENTER}
{$ENDIF CompilarPara_CALLCENTER}

{$IFDEF CompilarPara_TVMONITOR}
  {$DEFINE SuportaDLL}
{$ENDIF CompilarPara_TVMONITOR}

{$IFDEF CompilarPara_TV}
  {$DEFINE CompilarPara_SICSTV}
  {$DEFINE SuportaDLL}
{$ENDIF CompilarPara_TV}

{$IFDEF CompilarPara_CONFIG}
  {$DEFINE SuportaDLL}
  {$DEFINE SuportaPing}
{$ENDIF CompilarPara_CONFIG}

{$IF (Defined(FIREMONKEY) and ((not Defined(VCL)) or (Defined(IS_MOBILE) and (not Defined(VCL)))))}
  {$DEFINE AplicacaoFiremokeySemVCL}
{$ENDIF}
