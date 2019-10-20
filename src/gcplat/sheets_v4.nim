
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Sheets
## version: v4
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Reads and writes Google Sheets.
## 
## https://developers.google.com/sheets/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "sheets"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SheetsSpreadsheetsCreate_578619 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsCreate_578621(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SheetsSpreadsheetsCreate_578620(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("prettyPrint")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "prettyPrint", valid_578747
  var valid_578748 = query.getOrDefault("oauth_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "oauth_token", valid_578748
  var valid_578749 = query.getOrDefault("$.xgafv")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = newJString("1"))
  if valid_578749 != nil:
    section.add "$.xgafv", valid_578749
  var valid_578750 = query.getOrDefault("alt")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = newJString("json"))
  if valid_578750 != nil:
    section.add "alt", valid_578750
  var valid_578751 = query.getOrDefault("uploadType")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "uploadType", valid_578751
  var valid_578752 = query.getOrDefault("quotaUser")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "quotaUser", valid_578752
  var valid_578753 = query.getOrDefault("callback")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "callback", valid_578753
  var valid_578754 = query.getOrDefault("fields")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "fields", valid_578754
  var valid_578755 = query.getOrDefault("access_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "access_token", valid_578755
  var valid_578756 = query.getOrDefault("upload_protocol")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "upload_protocol", valid_578756
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578780: Call_SheetsSpreadsheetsCreate_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ## 
  let valid = call_578780.validator(path, query, header, formData, body)
  let scheme = call_578780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578780.url(scheme.get, call_578780.host, call_578780.base,
                         call_578780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578780, url, valid)

proc call*(call_578851: Call_SheetsSpreadsheetsCreate_578619; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsCreate
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578852 = newJObject()
  var body_578854 = newJObject()
  add(query_578852, "key", newJString(key))
  add(query_578852, "prettyPrint", newJBool(prettyPrint))
  add(query_578852, "oauth_token", newJString(oauthToken))
  add(query_578852, "$.xgafv", newJString(Xgafv))
  add(query_578852, "alt", newJString(alt))
  add(query_578852, "uploadType", newJString(uploadType))
  add(query_578852, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578854 = body
  add(query_578852, "callback", newJString(callback))
  add(query_578852, "fields", newJString(fields))
  add(query_578852, "access_token", newJString(accessToken))
  add(query_578852, "upload_protocol", newJString(uploadProtocol))
  result = call_578851.call(nil, query_578852, nil, nil, body_578854)

var sheetsSpreadsheetsCreate* = Call_SheetsSpreadsheetsCreate_578619(
    name: "sheetsSpreadsheetsCreate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com", route: "/v4/spreadsheets",
    validator: validate_SheetsSpreadsheetsCreate_578620, base: "/",
    url: url_SheetsSpreadsheetsCreate_578621, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsGet_578893 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsGet_578895(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsGet_578894(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the spreadsheet at the given ID.
  ## The caller must specify the spreadsheet ID.
  ## 
  ## By default, data within grids will not be returned.
  ## You can include grid data one of two ways:
  ## 
  ## * Specify a field mask listing your desired fields using the `fields` URL
  ## parameter in HTTP
  ## 
  ## * Set the includeGridData
  ## URL parameter to true.  If a field mask is set, the `includeGridData`
  ## parameter is ignored
  ## 
  ## For large spreadsheets, it is recommended to retrieve only the specific
  ## fields of the spreadsheet that you want.
  ## 
  ## To retrieve only subsets of the spreadsheet, use the
  ## ranges URL parameter.
  ## Multiple ranges can be specified.  Limiting the range will
  ## return only the portions of the spreadsheet that intersect the requested
  ## ranges. Ranges are specified using A1 notation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The spreadsheet to request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_578910 = path.getOrDefault("spreadsheetId")
  valid_578910 = validateParameter(valid_578910, JString, required = true,
                                 default = nil)
  if valid_578910 != nil:
    section.add "spreadsheetId", valid_578910
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ranges: JArray
  ##         : The ranges to retrieve from the spreadsheet.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeGridData: JBool
  ##                  : True if grid data should be returned.
  ## This parameter is ignored if a field mask was set in the request.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578911 = query.getOrDefault("key")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "key", valid_578911
  var valid_578912 = query.getOrDefault("ranges")
  valid_578912 = validateParameter(valid_578912, JArray, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "ranges", valid_578912
  var valid_578913 = query.getOrDefault("prettyPrint")
  valid_578913 = validateParameter(valid_578913, JBool, required = false,
                                 default = newJBool(true))
  if valid_578913 != nil:
    section.add "prettyPrint", valid_578913
  var valid_578914 = query.getOrDefault("oauth_token")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "oauth_token", valid_578914
  var valid_578915 = query.getOrDefault("includeGridData")
  valid_578915 = validateParameter(valid_578915, JBool, required = false, default = nil)
  if valid_578915 != nil:
    section.add "includeGridData", valid_578915
  var valid_578916 = query.getOrDefault("$.xgafv")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("1"))
  if valid_578916 != nil:
    section.add "$.xgafv", valid_578916
  var valid_578917 = query.getOrDefault("alt")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("json"))
  if valid_578917 != nil:
    section.add "alt", valid_578917
  var valid_578918 = query.getOrDefault("uploadType")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "uploadType", valid_578918
  var valid_578919 = query.getOrDefault("quotaUser")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "quotaUser", valid_578919
  var valid_578920 = query.getOrDefault("callback")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "callback", valid_578920
  var valid_578921 = query.getOrDefault("fields")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "fields", valid_578921
  var valid_578922 = query.getOrDefault("access_token")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "access_token", valid_578922
  var valid_578923 = query.getOrDefault("upload_protocol")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "upload_protocol", valid_578923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578924: Call_SheetsSpreadsheetsGet_578893; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the spreadsheet at the given ID.
  ## The caller must specify the spreadsheet ID.
  ## 
  ## By default, data within grids will not be returned.
  ## You can include grid data one of two ways:
  ## 
  ## * Specify a field mask listing your desired fields using the `fields` URL
  ## parameter in HTTP
  ## 
  ## * Set the includeGridData
  ## URL parameter to true.  If a field mask is set, the `includeGridData`
  ## parameter is ignored
  ## 
  ## For large spreadsheets, it is recommended to retrieve only the specific
  ## fields of the spreadsheet that you want.
  ## 
  ## To retrieve only subsets of the spreadsheet, use the
  ## ranges URL parameter.
  ## Multiple ranges can be specified.  Limiting the range will
  ## return only the portions of the spreadsheet that intersect the requested
  ## ranges. Ranges are specified using A1 notation.
  ## 
  let valid = call_578924.validator(path, query, header, formData, body)
  let scheme = call_578924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578924.url(scheme.get, call_578924.host, call_578924.base,
                         call_578924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578924, url, valid)

proc call*(call_578925: Call_SheetsSpreadsheetsGet_578893; spreadsheetId: string;
          key: string = ""; ranges: JsonNode = nil; prettyPrint: bool = true;
          oauthToken: string = ""; includeGridData: bool = false; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsGet
  ## Returns the spreadsheet at the given ID.
  ## The caller must specify the spreadsheet ID.
  ## 
  ## By default, data within grids will not be returned.
  ## You can include grid data one of two ways:
  ## 
  ## * Specify a field mask listing your desired fields using the `fields` URL
  ## parameter in HTTP
  ## 
  ## * Set the includeGridData
  ## URL parameter to true.  If a field mask is set, the `includeGridData`
  ## parameter is ignored
  ## 
  ## For large spreadsheets, it is recommended to retrieve only the specific
  ## fields of the spreadsheet that you want.
  ## 
  ## To retrieve only subsets of the spreadsheet, use the
  ## ranges URL parameter.
  ## Multiple ranges can be specified.  Limiting the range will
  ## return only the portions of the spreadsheet that intersect the requested
  ## ranges. Ranges are specified using A1 notation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ranges: JArray
  ##         : The ranges to retrieve from the spreadsheet.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeGridData: bool
  ##                  : True if grid data should be returned.
  ## This parameter is ignored if a field mask was set in the request.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The spreadsheet to request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578926 = newJObject()
  var query_578927 = newJObject()
  add(query_578927, "key", newJString(key))
  if ranges != nil:
    query_578927.add "ranges", ranges
  add(query_578927, "prettyPrint", newJBool(prettyPrint))
  add(query_578927, "oauth_token", newJString(oauthToken))
  add(query_578927, "includeGridData", newJBool(includeGridData))
  add(query_578927, "$.xgafv", newJString(Xgafv))
  add(query_578927, "alt", newJString(alt))
  add(query_578927, "uploadType", newJString(uploadType))
  add(query_578927, "quotaUser", newJString(quotaUser))
  add(query_578927, "callback", newJString(callback))
  add(path_578926, "spreadsheetId", newJString(spreadsheetId))
  add(query_578927, "fields", newJString(fields))
  add(query_578927, "access_token", newJString(accessToken))
  add(query_578927, "upload_protocol", newJString(uploadProtocol))
  result = call_578925.call(path_578926, query_578927, nil, nil, nil)

var sheetsSpreadsheetsGet* = Call_SheetsSpreadsheetsGet_578893(
    name: "sheetsSpreadsheetsGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com", route: "/v4/spreadsheets/{spreadsheetId}",
    validator: validate_SheetsSpreadsheetsGet_578894, base: "/",
    url: url_SheetsSpreadsheetsGet_578895, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsDeveloperMetadataGet_578928 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsDeveloperMetadataGet_578930(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  assert "metadataId" in path, "`metadataId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/developerMetadata/"),
               (kind: VariableSegment, value: "metadataId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsDeveloperMetadataGet_578929(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the developer metadata with the specified ID.
  ## The caller must specify the spreadsheet ID and the developer metadata's
  ## unique metadataId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metadataId: JInt (required)
  ##             : The ID of the developer metadata to retrieve.
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to retrieve metadata from.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `metadataId` field"
  var valid_578931 = path.getOrDefault("metadataId")
  valid_578931 = validateParameter(valid_578931, JInt, required = true, default = nil)
  if valid_578931 != nil:
    section.add "metadataId", valid_578931
  var valid_578932 = path.getOrDefault("spreadsheetId")
  valid_578932 = validateParameter(valid_578932, JString, required = true,
                                 default = nil)
  if valid_578932 != nil:
    section.add "spreadsheetId", valid_578932
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578933 = query.getOrDefault("key")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "key", valid_578933
  var valid_578934 = query.getOrDefault("prettyPrint")
  valid_578934 = validateParameter(valid_578934, JBool, required = false,
                                 default = newJBool(true))
  if valid_578934 != nil:
    section.add "prettyPrint", valid_578934
  var valid_578935 = query.getOrDefault("oauth_token")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "oauth_token", valid_578935
  var valid_578936 = query.getOrDefault("$.xgafv")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("1"))
  if valid_578936 != nil:
    section.add "$.xgafv", valid_578936
  var valid_578937 = query.getOrDefault("alt")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("json"))
  if valid_578937 != nil:
    section.add "alt", valid_578937
  var valid_578938 = query.getOrDefault("uploadType")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "uploadType", valid_578938
  var valid_578939 = query.getOrDefault("quotaUser")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "quotaUser", valid_578939
  var valid_578940 = query.getOrDefault("callback")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "callback", valid_578940
  var valid_578941 = query.getOrDefault("fields")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "fields", valid_578941
  var valid_578942 = query.getOrDefault("access_token")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "access_token", valid_578942
  var valid_578943 = query.getOrDefault("upload_protocol")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "upload_protocol", valid_578943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578944: Call_SheetsSpreadsheetsDeveloperMetadataGet_578928;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the developer metadata with the specified ID.
  ## The caller must specify the spreadsheet ID and the developer metadata's
  ## unique metadataId.
  ## 
  let valid = call_578944.validator(path, query, header, formData, body)
  let scheme = call_578944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578944.url(scheme.get, call_578944.host, call_578944.base,
                         call_578944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578944, url, valid)

proc call*(call_578945: Call_SheetsSpreadsheetsDeveloperMetadataGet_578928;
          metadataId: int; spreadsheetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsDeveloperMetadataGet
  ## Returns the developer metadata with the specified ID.
  ## The caller must specify the spreadsheet ID and the developer metadata's
  ## unique metadataId.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   metadataId: int (required)
  ##             : The ID of the developer metadata to retrieve.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve metadata from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578946 = newJObject()
  var query_578947 = newJObject()
  add(query_578947, "key", newJString(key))
  add(query_578947, "prettyPrint", newJBool(prettyPrint))
  add(query_578947, "oauth_token", newJString(oauthToken))
  add(query_578947, "$.xgafv", newJString(Xgafv))
  add(path_578946, "metadataId", newJInt(metadataId))
  add(query_578947, "alt", newJString(alt))
  add(query_578947, "uploadType", newJString(uploadType))
  add(query_578947, "quotaUser", newJString(quotaUser))
  add(query_578947, "callback", newJString(callback))
  add(path_578946, "spreadsheetId", newJString(spreadsheetId))
  add(query_578947, "fields", newJString(fields))
  add(query_578947, "access_token", newJString(accessToken))
  add(query_578947, "upload_protocol", newJString(uploadProtocol))
  result = call_578945.call(path_578946, query_578947, nil, nil, nil)

var sheetsSpreadsheetsDeveloperMetadataGet* = Call_SheetsSpreadsheetsDeveloperMetadataGet_578928(
    name: "sheetsSpreadsheetsDeveloperMetadataGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/developerMetadata/{metadataId}",
    validator: validate_SheetsSpreadsheetsDeveloperMetadataGet_578929, base: "/",
    url: url_SheetsSpreadsheetsDeveloperMetadataGet_578930,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsDeveloperMetadataSearch_578948 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsDeveloperMetadataSearch_578950(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/developerMetadata:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsDeveloperMetadataSearch_578949(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all developer metadata matching the specified DataFilter.
  ## If the provided DataFilter represents a DeveloperMetadataLookup object,
  ## this will return all DeveloperMetadata entries selected by it. If the
  ## DataFilter represents a location in a spreadsheet, this will return all
  ## developer metadata associated with locations intersecting that region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to retrieve metadata from.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_578951 = path.getOrDefault("spreadsheetId")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "spreadsheetId", valid_578951
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578952 = query.getOrDefault("key")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "key", valid_578952
  var valid_578953 = query.getOrDefault("prettyPrint")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(true))
  if valid_578953 != nil:
    section.add "prettyPrint", valid_578953
  var valid_578954 = query.getOrDefault("oauth_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "oauth_token", valid_578954
  var valid_578955 = query.getOrDefault("$.xgafv")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("1"))
  if valid_578955 != nil:
    section.add "$.xgafv", valid_578955
  var valid_578956 = query.getOrDefault("alt")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("json"))
  if valid_578956 != nil:
    section.add "alt", valid_578956
  var valid_578957 = query.getOrDefault("uploadType")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "uploadType", valid_578957
  var valid_578958 = query.getOrDefault("quotaUser")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "quotaUser", valid_578958
  var valid_578959 = query.getOrDefault("callback")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "callback", valid_578959
  var valid_578960 = query.getOrDefault("fields")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "fields", valid_578960
  var valid_578961 = query.getOrDefault("access_token")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "access_token", valid_578961
  var valid_578962 = query.getOrDefault("upload_protocol")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "upload_protocol", valid_578962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578964: Call_SheetsSpreadsheetsDeveloperMetadataSearch_578948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all developer metadata matching the specified DataFilter.
  ## If the provided DataFilter represents a DeveloperMetadataLookup object,
  ## this will return all DeveloperMetadata entries selected by it. If the
  ## DataFilter represents a location in a spreadsheet, this will return all
  ## developer metadata associated with locations intersecting that region.
  ## 
  let valid = call_578964.validator(path, query, header, formData, body)
  let scheme = call_578964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578964.url(scheme.get, call_578964.host, call_578964.base,
                         call_578964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578964, url, valid)

proc call*(call_578965: Call_SheetsSpreadsheetsDeveloperMetadataSearch_578948;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsDeveloperMetadataSearch
  ## Returns all developer metadata matching the specified DataFilter.
  ## If the provided DataFilter represents a DeveloperMetadataLookup object,
  ## this will return all DeveloperMetadata entries selected by it. If the
  ## DataFilter represents a location in a spreadsheet, this will return all
  ## developer metadata associated with locations intersecting that region.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve metadata from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578966 = newJObject()
  var query_578967 = newJObject()
  var body_578968 = newJObject()
  add(query_578967, "key", newJString(key))
  add(query_578967, "prettyPrint", newJBool(prettyPrint))
  add(query_578967, "oauth_token", newJString(oauthToken))
  add(query_578967, "$.xgafv", newJString(Xgafv))
  add(query_578967, "alt", newJString(alt))
  add(query_578967, "uploadType", newJString(uploadType))
  add(query_578967, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578968 = body
  add(query_578967, "callback", newJString(callback))
  add(path_578966, "spreadsheetId", newJString(spreadsheetId))
  add(query_578967, "fields", newJString(fields))
  add(query_578967, "access_token", newJString(accessToken))
  add(query_578967, "upload_protocol", newJString(uploadProtocol))
  result = call_578965.call(path_578966, query_578967, nil, nil, body_578968)

var sheetsSpreadsheetsDeveloperMetadataSearch* = Call_SheetsSpreadsheetsDeveloperMetadataSearch_578948(
    name: "sheetsSpreadsheetsDeveloperMetadataSearch", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/developerMetadata:search",
    validator: validate_SheetsSpreadsheetsDeveloperMetadataSearch_578949,
    base: "/", url: url_SheetsSpreadsheetsDeveloperMetadataSearch_578950,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsSheetsCopyTo_578969 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsSheetsCopyTo_578971(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  assert "sheetId" in path, "`sheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/sheets/"),
               (kind: VariableSegment, value: "sheetId"),
               (kind: ConstantSegment, value: ":copyTo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsSheetsCopyTo_578970(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Copies a single sheet from a spreadsheet to another spreadsheet.
  ## Returns the properties of the newly created sheet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sheetId: JInt (required)
  ##          : The ID of the sheet to copy.
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet containing the sheet to copy.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sheetId` field"
  var valid_578972 = path.getOrDefault("sheetId")
  valid_578972 = validateParameter(valid_578972, JInt, required = true, default = nil)
  if valid_578972 != nil:
    section.add "sheetId", valid_578972
  var valid_578973 = path.getOrDefault("spreadsheetId")
  valid_578973 = validateParameter(valid_578973, JString, required = true,
                                 default = nil)
  if valid_578973 != nil:
    section.add "spreadsheetId", valid_578973
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578974 = query.getOrDefault("key")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "key", valid_578974
  var valid_578975 = query.getOrDefault("prettyPrint")
  valid_578975 = validateParameter(valid_578975, JBool, required = false,
                                 default = newJBool(true))
  if valid_578975 != nil:
    section.add "prettyPrint", valid_578975
  var valid_578976 = query.getOrDefault("oauth_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "oauth_token", valid_578976
  var valid_578977 = query.getOrDefault("$.xgafv")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("1"))
  if valid_578977 != nil:
    section.add "$.xgafv", valid_578977
  var valid_578978 = query.getOrDefault("alt")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = newJString("json"))
  if valid_578978 != nil:
    section.add "alt", valid_578978
  var valid_578979 = query.getOrDefault("uploadType")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "uploadType", valid_578979
  var valid_578980 = query.getOrDefault("quotaUser")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "quotaUser", valid_578980
  var valid_578981 = query.getOrDefault("callback")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "callback", valid_578981
  var valid_578982 = query.getOrDefault("fields")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "fields", valid_578982
  var valid_578983 = query.getOrDefault("access_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "access_token", valid_578983
  var valid_578984 = query.getOrDefault("upload_protocol")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "upload_protocol", valid_578984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578986: Call_SheetsSpreadsheetsSheetsCopyTo_578969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a single sheet from a spreadsheet to another spreadsheet.
  ## Returns the properties of the newly created sheet.
  ## 
  let valid = call_578986.validator(path, query, header, formData, body)
  let scheme = call_578986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578986.url(scheme.get, call_578986.host, call_578986.base,
                         call_578986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578986, url, valid)

proc call*(call_578987: Call_SheetsSpreadsheetsSheetsCopyTo_578969; sheetId: int;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsSheetsCopyTo
  ## Copies a single sheet from a spreadsheet to another spreadsheet.
  ## Returns the properties of the newly created sheet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sheetId: int (required)
  ##          : The ID of the sheet to copy.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet containing the sheet to copy.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578988 = newJObject()
  var query_578989 = newJObject()
  var body_578990 = newJObject()
  add(query_578989, "key", newJString(key))
  add(query_578989, "prettyPrint", newJBool(prettyPrint))
  add(query_578989, "oauth_token", newJString(oauthToken))
  add(path_578988, "sheetId", newJInt(sheetId))
  add(query_578989, "$.xgafv", newJString(Xgafv))
  add(query_578989, "alt", newJString(alt))
  add(query_578989, "uploadType", newJString(uploadType))
  add(query_578989, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578990 = body
  add(query_578989, "callback", newJString(callback))
  add(path_578988, "spreadsheetId", newJString(spreadsheetId))
  add(query_578989, "fields", newJString(fields))
  add(query_578989, "access_token", newJString(accessToken))
  add(query_578989, "upload_protocol", newJString(uploadProtocol))
  result = call_578987.call(path_578988, query_578989, nil, nil, body_578990)

var sheetsSpreadsheetsSheetsCopyTo* = Call_SheetsSpreadsheetsSheetsCopyTo_578969(
    name: "sheetsSpreadsheetsSheetsCopyTo", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/sheets/{sheetId}:copyTo",
    validator: validate_SheetsSpreadsheetsSheetsCopyTo_578970, base: "/",
    url: url_SheetsSpreadsheetsSheetsCopyTo_578971, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesUpdate_579014 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsValuesUpdate_579016(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  assert "range" in path, "`range` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values/"),
               (kind: VariableSegment, value: "range")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesUpdate_579015(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets values in a range of a spreadsheet.
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  ##   range: JString (required)
  ##        : The A1 notation of the values to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579017 = path.getOrDefault("spreadsheetId")
  valid_579017 = validateParameter(valid_579017, JString, required = true,
                                 default = nil)
  if valid_579017 != nil:
    section.add "spreadsheetId", valid_579017
  var valid_579018 = path.getOrDefault("range")
  valid_579018 = validateParameter(valid_579018, JString, required = true,
                                 default = nil)
  if valid_579018 != nil:
    section.add "range", valid_579018
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   responseValueRenderOption: JString
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   responseDateTimeRenderOption: JString
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is
  ## DateTimeRenderOption.SERIAL_NUMBER.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: JBool
  ##                          : Determines if the update response should include the values
  ## of the cells that were updated. By default, responses
  ## do not include the updated values.
  ## If the range to write was larger than than the range actually written,
  ## the response will include all values in the requested range (excluding
  ## trailing empty rows and columns).
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   valueInputOption: JString
  ##                   : How the input data should be interpreted.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579019 = query.getOrDefault("key")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "key", valid_579019
  var valid_579020 = query.getOrDefault("prettyPrint")
  valid_579020 = validateParameter(valid_579020, JBool, required = false,
                                 default = newJBool(true))
  if valid_579020 != nil:
    section.add "prettyPrint", valid_579020
  var valid_579021 = query.getOrDefault("oauth_token")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "oauth_token", valid_579021
  var valid_579022 = query.getOrDefault("$.xgafv")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = newJString("1"))
  if valid_579022 != nil:
    section.add "$.xgafv", valid_579022
  var valid_579023 = query.getOrDefault("responseValueRenderOption")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_579023 != nil:
    section.add "responseValueRenderOption", valid_579023
  var valid_579024 = query.getOrDefault("responseDateTimeRenderOption")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_579024 != nil:
    section.add "responseDateTimeRenderOption", valid_579024
  var valid_579025 = query.getOrDefault("alt")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = newJString("json"))
  if valid_579025 != nil:
    section.add "alt", valid_579025
  var valid_579026 = query.getOrDefault("uploadType")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "uploadType", valid_579026
  var valid_579027 = query.getOrDefault("includeValuesInResponse")
  valid_579027 = validateParameter(valid_579027, JBool, required = false, default = nil)
  if valid_579027 != nil:
    section.add "includeValuesInResponse", valid_579027
  var valid_579028 = query.getOrDefault("quotaUser")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "quotaUser", valid_579028
  var valid_579029 = query.getOrDefault("callback")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "callback", valid_579029
  var valid_579030 = query.getOrDefault("valueInputOption")
  valid_579030 = validateParameter(valid_579030, JString, required = false, default = newJString(
      "INPUT_VALUE_OPTION_UNSPECIFIED"))
  if valid_579030 != nil:
    section.add "valueInputOption", valid_579030
  var valid_579031 = query.getOrDefault("fields")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "fields", valid_579031
  var valid_579032 = query.getOrDefault("access_token")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "access_token", valid_579032
  var valid_579033 = query.getOrDefault("upload_protocol")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "upload_protocol", valid_579033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579035: Call_SheetsSpreadsheetsValuesUpdate_579014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets values in a range of a spreadsheet.
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.
  ## 
  let valid = call_579035.validator(path, query, header, formData, body)
  let scheme = call_579035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579035.url(scheme.get, call_579035.host, call_579035.base,
                         call_579035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579035, url, valid)

proc call*(call_579036: Call_SheetsSpreadsheetsValuesUpdate_579014;
          spreadsheetId: string; range: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          responseValueRenderOption: string = "FORMATTED_VALUE";
          responseDateTimeRenderOption: string = "SERIAL_NUMBER";
          alt: string = "json"; uploadType: string = "";
          includeValuesInResponse: bool = false; quotaUser: string = "";
          body: JsonNode = nil; callback: string = "";
          valueInputOption: string = "INPUT_VALUE_OPTION_UNSPECIFIED";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesUpdate
  ## Sets values in a range of a spreadsheet.
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   responseValueRenderOption: string
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   responseDateTimeRenderOption: string
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is
  ## DateTimeRenderOption.SERIAL_NUMBER.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: bool
  ##                          : Determines if the update response should include the values
  ## of the cells that were updated. By default, responses
  ## do not include the updated values.
  ## If the range to write was larger than than the range actually written,
  ## the response will include all values in the requested range (excluding
  ## trailing empty rows and columns).
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   range: string (required)
  ##        : The A1 notation of the values to update.
  ##   valueInputOption: string
  ##                   : How the input data should be interpreted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579037 = newJObject()
  var query_579038 = newJObject()
  var body_579039 = newJObject()
  add(query_579038, "key", newJString(key))
  add(query_579038, "prettyPrint", newJBool(prettyPrint))
  add(query_579038, "oauth_token", newJString(oauthToken))
  add(query_579038, "$.xgafv", newJString(Xgafv))
  add(query_579038, "responseValueRenderOption",
      newJString(responseValueRenderOption))
  add(query_579038, "responseDateTimeRenderOption",
      newJString(responseDateTimeRenderOption))
  add(query_579038, "alt", newJString(alt))
  add(query_579038, "uploadType", newJString(uploadType))
  add(query_579038, "includeValuesInResponse", newJBool(includeValuesInResponse))
  add(query_579038, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579039 = body
  add(query_579038, "callback", newJString(callback))
  add(path_579037, "spreadsheetId", newJString(spreadsheetId))
  add(path_579037, "range", newJString(range))
  add(query_579038, "valueInputOption", newJString(valueInputOption))
  add(query_579038, "fields", newJString(fields))
  add(query_579038, "access_token", newJString(accessToken))
  add(query_579038, "upload_protocol", newJString(uploadProtocol))
  result = call_579036.call(path_579037, query_579038, nil, nil, body_579039)

var sheetsSpreadsheetsValuesUpdate* = Call_SheetsSpreadsheetsValuesUpdate_579014(
    name: "sheetsSpreadsheetsValuesUpdate", meth: HttpMethod.HttpPut,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}",
    validator: validate_SheetsSpreadsheetsValuesUpdate_579015, base: "/",
    url: url_SheetsSpreadsheetsValuesUpdate_579016, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesGet_578991 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsValuesGet_578993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  assert "range" in path, "`range` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values/"),
               (kind: VariableSegment, value: "range")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesGet_578992(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a range of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and a range.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   range: JString (required)
  ##        : The A1 notation of the values to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_578994 = path.getOrDefault("spreadsheetId")
  valid_578994 = validateParameter(valid_578994, JString, required = true,
                                 default = nil)
  if valid_578994 != nil:
    section.add "spreadsheetId", valid_578994
  var valid_578995 = path.getOrDefault("range")
  valid_578995 = validateParameter(valid_578995, JString, required = true,
                                 default = nil)
  if valid_578995 != nil:
    section.add "range", valid_578995
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   majorDimension: JString
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dateTimeRenderOption: JString
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   valueRenderOption: JString
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  section = newJObject()
  var valid_578996 = query.getOrDefault("key")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "key", valid_578996
  var valid_578997 = query.getOrDefault("prettyPrint")
  valid_578997 = validateParameter(valid_578997, JBool, required = false,
                                 default = newJBool(true))
  if valid_578997 != nil:
    section.add "prettyPrint", valid_578997
  var valid_578998 = query.getOrDefault("oauth_token")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "oauth_token", valid_578998
  var valid_578999 = query.getOrDefault("majorDimension")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = newJString("DIMENSION_UNSPECIFIED"))
  if valid_578999 != nil:
    section.add "majorDimension", valid_578999
  var valid_579000 = query.getOrDefault("$.xgafv")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = newJString("1"))
  if valid_579000 != nil:
    section.add "$.xgafv", valid_579000
  var valid_579001 = query.getOrDefault("alt")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("json"))
  if valid_579001 != nil:
    section.add "alt", valid_579001
  var valid_579002 = query.getOrDefault("uploadType")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "uploadType", valid_579002
  var valid_579003 = query.getOrDefault("quotaUser")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "quotaUser", valid_579003
  var valid_579004 = query.getOrDefault("dateTimeRenderOption")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_579004 != nil:
    section.add "dateTimeRenderOption", valid_579004
  var valid_579005 = query.getOrDefault("callback")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "callback", valid_579005
  var valid_579006 = query.getOrDefault("fields")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "fields", valid_579006
  var valid_579007 = query.getOrDefault("access_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "access_token", valid_579007
  var valid_579008 = query.getOrDefault("upload_protocol")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "upload_protocol", valid_579008
  var valid_579009 = query.getOrDefault("valueRenderOption")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_579009 != nil:
    section.add "valueRenderOption", valid_579009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579010: Call_SheetsSpreadsheetsValuesGet_578991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a range of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and a range.
  ## 
  let valid = call_579010.validator(path, query, header, formData, body)
  let scheme = call_579010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579010.url(scheme.get, call_579010.host, call_579010.base,
                         call_579010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579010, url, valid)

proc call*(call_579011: Call_SheetsSpreadsheetsValuesGet_578991;
          spreadsheetId: string; range: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          majorDimension: string = "DIMENSION_UNSPECIFIED"; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          dateTimeRenderOption: string = "SERIAL_NUMBER"; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          valueRenderOption: string = "FORMATTED_VALUE"): Recallable =
  ## sheetsSpreadsheetsValuesGet
  ## Returns a range of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and a range.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   majorDimension: string
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dateTimeRenderOption: string
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   range: string (required)
  ##        : The A1 notation of the values to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   valueRenderOption: string
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  var path_579012 = newJObject()
  var query_579013 = newJObject()
  add(query_579013, "key", newJString(key))
  add(query_579013, "prettyPrint", newJBool(prettyPrint))
  add(query_579013, "oauth_token", newJString(oauthToken))
  add(query_579013, "majorDimension", newJString(majorDimension))
  add(query_579013, "$.xgafv", newJString(Xgafv))
  add(query_579013, "alt", newJString(alt))
  add(query_579013, "uploadType", newJString(uploadType))
  add(query_579013, "quotaUser", newJString(quotaUser))
  add(query_579013, "dateTimeRenderOption", newJString(dateTimeRenderOption))
  add(query_579013, "callback", newJString(callback))
  add(path_579012, "spreadsheetId", newJString(spreadsheetId))
  add(path_579012, "range", newJString(range))
  add(query_579013, "fields", newJString(fields))
  add(query_579013, "access_token", newJString(accessToken))
  add(query_579013, "upload_protocol", newJString(uploadProtocol))
  add(query_579013, "valueRenderOption", newJString(valueRenderOption))
  result = call_579011.call(path_579012, query_579013, nil, nil, nil)

var sheetsSpreadsheetsValuesGet* = Call_SheetsSpreadsheetsValuesGet_578991(
    name: "sheetsSpreadsheetsValuesGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}",
    validator: validate_SheetsSpreadsheetsValuesGet_578992, base: "/",
    url: url_SheetsSpreadsheetsValuesGet_578993, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesAppend_579040 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsValuesAppend_579042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  assert "range" in path, "`range` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values/"),
               (kind: VariableSegment, value: "range"),
               (kind: ConstantSegment, value: ":append")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesAppend_579041(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Appends values to a spreadsheet. The input range is used to search for
  ## existing data and find a "table" within that range. Values will be
  ## appended to the next row of the table, starting with the first column of
  ## the table. See the
  ## [guide](/sheets/api/guides/values#appending_values)
  ## and
  ## [sample code](/sheets/api/samples/writing#append_values)
  ## for specific details of how tables are detected and data is appended.
  ## 
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.  The `valueInputOption` only
  ## controls how the input data will be added to the sheet (column-wise or
  ## row-wise), it does not influence what cell the data starts being written
  ## to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  ##   range: JString (required)
  ##        : The A1 notation of a range to search for a logical table of data.
  ## Values will be appended after the last row of the table.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579043 = path.getOrDefault("spreadsheetId")
  valid_579043 = validateParameter(valid_579043, JString, required = true,
                                 default = nil)
  if valid_579043 != nil:
    section.add "spreadsheetId", valid_579043
  var valid_579044 = path.getOrDefault("range")
  valid_579044 = validateParameter(valid_579044, JString, required = true,
                                 default = nil)
  if valid_579044 != nil:
    section.add "range", valid_579044
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   insertDataOption: JString
  ##                   : How the input data should be inserted.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   responseValueRenderOption: JString
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   responseDateTimeRenderOption: JString
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: JBool
  ##                          : Determines if the update response should include the values
  ## of the cells that were appended. By default, responses
  ## do not include the updated values.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   valueInputOption: JString
  ##                   : How the input data should be interpreted.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579045 = query.getOrDefault("key")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "key", valid_579045
  var valid_579046 = query.getOrDefault("insertDataOption")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("OVERWRITE"))
  if valid_579046 != nil:
    section.add "insertDataOption", valid_579046
  var valid_579047 = query.getOrDefault("prettyPrint")
  valid_579047 = validateParameter(valid_579047, JBool, required = false,
                                 default = newJBool(true))
  if valid_579047 != nil:
    section.add "prettyPrint", valid_579047
  var valid_579048 = query.getOrDefault("oauth_token")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "oauth_token", valid_579048
  var valid_579049 = query.getOrDefault("$.xgafv")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = newJString("1"))
  if valid_579049 != nil:
    section.add "$.xgafv", valid_579049
  var valid_579050 = query.getOrDefault("responseValueRenderOption")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_579050 != nil:
    section.add "responseValueRenderOption", valid_579050
  var valid_579051 = query.getOrDefault("responseDateTimeRenderOption")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_579051 != nil:
    section.add "responseDateTimeRenderOption", valid_579051
  var valid_579052 = query.getOrDefault("alt")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = newJString("json"))
  if valid_579052 != nil:
    section.add "alt", valid_579052
  var valid_579053 = query.getOrDefault("uploadType")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "uploadType", valid_579053
  var valid_579054 = query.getOrDefault("includeValuesInResponse")
  valid_579054 = validateParameter(valid_579054, JBool, required = false, default = nil)
  if valid_579054 != nil:
    section.add "includeValuesInResponse", valid_579054
  var valid_579055 = query.getOrDefault("quotaUser")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "quotaUser", valid_579055
  var valid_579056 = query.getOrDefault("callback")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "callback", valid_579056
  var valid_579057 = query.getOrDefault("valueInputOption")
  valid_579057 = validateParameter(valid_579057, JString, required = false, default = newJString(
      "INPUT_VALUE_OPTION_UNSPECIFIED"))
  if valid_579057 != nil:
    section.add "valueInputOption", valid_579057
  var valid_579058 = query.getOrDefault("fields")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "fields", valid_579058
  var valid_579059 = query.getOrDefault("access_token")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "access_token", valid_579059
  var valid_579060 = query.getOrDefault("upload_protocol")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "upload_protocol", valid_579060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579062: Call_SheetsSpreadsheetsValuesAppend_579040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Appends values to a spreadsheet. The input range is used to search for
  ## existing data and find a "table" within that range. Values will be
  ## appended to the next row of the table, starting with the first column of
  ## the table. See the
  ## [guide](/sheets/api/guides/values#appending_values)
  ## and
  ## [sample code](/sheets/api/samples/writing#append_values)
  ## for specific details of how tables are detected and data is appended.
  ## 
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.  The `valueInputOption` only
  ## controls how the input data will be added to the sheet (column-wise or
  ## row-wise), it does not influence what cell the data starts being written
  ## to.
  ## 
  let valid = call_579062.validator(path, query, header, formData, body)
  let scheme = call_579062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579062.url(scheme.get, call_579062.host, call_579062.base,
                         call_579062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579062, url, valid)

proc call*(call_579063: Call_SheetsSpreadsheetsValuesAppend_579040;
          spreadsheetId: string; range: string; key: string = "";
          insertDataOption: string = "OVERWRITE"; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          responseValueRenderOption: string = "FORMATTED_VALUE";
          responseDateTimeRenderOption: string = "SERIAL_NUMBER";
          alt: string = "json"; uploadType: string = "";
          includeValuesInResponse: bool = false; quotaUser: string = "";
          body: JsonNode = nil; callback: string = "";
          valueInputOption: string = "INPUT_VALUE_OPTION_UNSPECIFIED";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesAppend
  ## Appends values to a spreadsheet. The input range is used to search for
  ## existing data and find a "table" within that range. Values will be
  ## appended to the next row of the table, starting with the first column of
  ## the table. See the
  ## [guide](/sheets/api/guides/values#appending_values)
  ## and
  ## [sample code](/sheets/api/samples/writing#append_values)
  ## for specific details of how tables are detected and data is appended.
  ## 
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.  The `valueInputOption` only
  ## controls how the input data will be added to the sheet (column-wise or
  ## row-wise), it does not influence what cell the data starts being written
  ## to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   insertDataOption: string
  ##                   : How the input data should be inserted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   responseValueRenderOption: string
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   responseDateTimeRenderOption: string
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: bool
  ##                          : Determines if the update response should include the values
  ## of the cells that were appended. By default, responses
  ## do not include the updated values.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   range: string (required)
  ##        : The A1 notation of a range to search for a logical table of data.
  ## Values will be appended after the last row of the table.
  ##   valueInputOption: string
  ##                   : How the input data should be interpreted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579064 = newJObject()
  var query_579065 = newJObject()
  var body_579066 = newJObject()
  add(query_579065, "key", newJString(key))
  add(query_579065, "insertDataOption", newJString(insertDataOption))
  add(query_579065, "prettyPrint", newJBool(prettyPrint))
  add(query_579065, "oauth_token", newJString(oauthToken))
  add(query_579065, "$.xgafv", newJString(Xgafv))
  add(query_579065, "responseValueRenderOption",
      newJString(responseValueRenderOption))
  add(query_579065, "responseDateTimeRenderOption",
      newJString(responseDateTimeRenderOption))
  add(query_579065, "alt", newJString(alt))
  add(query_579065, "uploadType", newJString(uploadType))
  add(query_579065, "includeValuesInResponse", newJBool(includeValuesInResponse))
  add(query_579065, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579066 = body
  add(query_579065, "callback", newJString(callback))
  add(path_579064, "spreadsheetId", newJString(spreadsheetId))
  add(path_579064, "range", newJString(range))
  add(query_579065, "valueInputOption", newJString(valueInputOption))
  add(query_579065, "fields", newJString(fields))
  add(query_579065, "access_token", newJString(accessToken))
  add(query_579065, "upload_protocol", newJString(uploadProtocol))
  result = call_579063.call(path_579064, query_579065, nil, nil, body_579066)

var sheetsSpreadsheetsValuesAppend* = Call_SheetsSpreadsheetsValuesAppend_579040(
    name: "sheetsSpreadsheetsValuesAppend", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}:append",
    validator: validate_SheetsSpreadsheetsValuesAppend_579041, base: "/",
    url: url_SheetsSpreadsheetsValuesAppend_579042, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesClear_579067 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsValuesClear_579069(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  assert "range" in path, "`range` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values/"),
               (kind: VariableSegment, value: "range"),
               (kind: ConstantSegment, value: ":clear")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesClear_579068(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Clears values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and range.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  ##   range: JString (required)
  ##        : The A1 notation of the values to clear.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579070 = path.getOrDefault("spreadsheetId")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "spreadsheetId", valid_579070
  var valid_579071 = path.getOrDefault("range")
  valid_579071 = validateParameter(valid_579071, JString, required = true,
                                 default = nil)
  if valid_579071 != nil:
    section.add "range", valid_579071
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579072 = query.getOrDefault("key")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "key", valid_579072
  var valid_579073 = query.getOrDefault("prettyPrint")
  valid_579073 = validateParameter(valid_579073, JBool, required = false,
                                 default = newJBool(true))
  if valid_579073 != nil:
    section.add "prettyPrint", valid_579073
  var valid_579074 = query.getOrDefault("oauth_token")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "oauth_token", valid_579074
  var valid_579075 = query.getOrDefault("$.xgafv")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = newJString("1"))
  if valid_579075 != nil:
    section.add "$.xgafv", valid_579075
  var valid_579076 = query.getOrDefault("alt")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("json"))
  if valid_579076 != nil:
    section.add "alt", valid_579076
  var valid_579077 = query.getOrDefault("uploadType")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "uploadType", valid_579077
  var valid_579078 = query.getOrDefault("quotaUser")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "quotaUser", valid_579078
  var valid_579079 = query.getOrDefault("callback")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "callback", valid_579079
  var valid_579080 = query.getOrDefault("fields")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "fields", valid_579080
  var valid_579081 = query.getOrDefault("access_token")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "access_token", valid_579081
  var valid_579082 = query.getOrDefault("upload_protocol")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "upload_protocol", valid_579082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579084: Call_SheetsSpreadsheetsValuesClear_579067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and range.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  let valid = call_579084.validator(path, query, header, formData, body)
  let scheme = call_579084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579084.url(scheme.get, call_579084.host, call_579084.base,
                         call_579084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579084, url, valid)

proc call*(call_579085: Call_SheetsSpreadsheetsValuesClear_579067;
          spreadsheetId: string; range: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesClear
  ## Clears values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and range.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   range: string (required)
  ##        : The A1 notation of the values to clear.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579086 = newJObject()
  var query_579087 = newJObject()
  var body_579088 = newJObject()
  add(query_579087, "key", newJString(key))
  add(query_579087, "prettyPrint", newJBool(prettyPrint))
  add(query_579087, "oauth_token", newJString(oauthToken))
  add(query_579087, "$.xgafv", newJString(Xgafv))
  add(query_579087, "alt", newJString(alt))
  add(query_579087, "uploadType", newJString(uploadType))
  add(query_579087, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579088 = body
  add(query_579087, "callback", newJString(callback))
  add(path_579086, "spreadsheetId", newJString(spreadsheetId))
  add(path_579086, "range", newJString(range))
  add(query_579087, "fields", newJString(fields))
  add(query_579087, "access_token", newJString(accessToken))
  add(query_579087, "upload_protocol", newJString(uploadProtocol))
  result = call_579085.call(path_579086, query_579087, nil, nil, body_579088)

var sheetsSpreadsheetsValuesClear* = Call_SheetsSpreadsheetsValuesClear_579067(
    name: "sheetsSpreadsheetsValuesClear", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}:clear",
    validator: validate_SheetsSpreadsheetsValuesClear_579068, base: "/",
    url: url_SheetsSpreadsheetsValuesClear_579069, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchClear_579089 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsValuesBatchClear_579091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values:batchClear")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchClear_579090(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579092 = path.getOrDefault("spreadsheetId")
  valid_579092 = validateParameter(valid_579092, JString, required = true,
                                 default = nil)
  if valid_579092 != nil:
    section.add "spreadsheetId", valid_579092
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579093 = query.getOrDefault("key")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "key", valid_579093
  var valid_579094 = query.getOrDefault("prettyPrint")
  valid_579094 = validateParameter(valid_579094, JBool, required = false,
                                 default = newJBool(true))
  if valid_579094 != nil:
    section.add "prettyPrint", valid_579094
  var valid_579095 = query.getOrDefault("oauth_token")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "oauth_token", valid_579095
  var valid_579096 = query.getOrDefault("$.xgafv")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("1"))
  if valid_579096 != nil:
    section.add "$.xgafv", valid_579096
  var valid_579097 = query.getOrDefault("alt")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = newJString("json"))
  if valid_579097 != nil:
    section.add "alt", valid_579097
  var valid_579098 = query.getOrDefault("uploadType")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "uploadType", valid_579098
  var valid_579099 = query.getOrDefault("quotaUser")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "quotaUser", valid_579099
  var valid_579100 = query.getOrDefault("callback")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "callback", valid_579100
  var valid_579101 = query.getOrDefault("fields")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "fields", valid_579101
  var valid_579102 = query.getOrDefault("access_token")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "access_token", valid_579102
  var valid_579103 = query.getOrDefault("upload_protocol")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "upload_protocol", valid_579103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579105: Call_SheetsSpreadsheetsValuesBatchClear_579089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  let valid = call_579105.validator(path, query, header, formData, body)
  let scheme = call_579105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579105.url(scheme.get, call_579105.host, call_579105.base,
                         call_579105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579105, url, valid)

proc call*(call_579106: Call_SheetsSpreadsheetsValuesBatchClear_579089;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesBatchClear
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579107 = newJObject()
  var query_579108 = newJObject()
  var body_579109 = newJObject()
  add(query_579108, "key", newJString(key))
  add(query_579108, "prettyPrint", newJBool(prettyPrint))
  add(query_579108, "oauth_token", newJString(oauthToken))
  add(query_579108, "$.xgafv", newJString(Xgafv))
  add(query_579108, "alt", newJString(alt))
  add(query_579108, "uploadType", newJString(uploadType))
  add(query_579108, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579109 = body
  add(query_579108, "callback", newJString(callback))
  add(path_579107, "spreadsheetId", newJString(spreadsheetId))
  add(query_579108, "fields", newJString(fields))
  add(query_579108, "access_token", newJString(accessToken))
  add(query_579108, "upload_protocol", newJString(uploadProtocol))
  result = call_579106.call(path_579107, query_579108, nil, nil, body_579109)

var sheetsSpreadsheetsValuesBatchClear* = Call_SheetsSpreadsheetsValuesBatchClear_579089(
    name: "sheetsSpreadsheetsValuesBatchClear", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchClear",
    validator: validate_SheetsSpreadsheetsValuesBatchClear_579090, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchClear_579091, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_579110 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsValuesBatchClearByDataFilter_579112(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values:batchClearByDataFilter")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchClearByDataFilter_579111(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters. Ranges matching any of the specified data
  ## filters will be cleared.  Only values are cleared -- all other properties
  ## of the cell (such as formatting, data validation, etc..) are kept.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579113 = path.getOrDefault("spreadsheetId")
  valid_579113 = validateParameter(valid_579113, JString, required = true,
                                 default = nil)
  if valid_579113 != nil:
    section.add "spreadsheetId", valid_579113
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579114 = query.getOrDefault("key")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "key", valid_579114
  var valid_579115 = query.getOrDefault("prettyPrint")
  valid_579115 = validateParameter(valid_579115, JBool, required = false,
                                 default = newJBool(true))
  if valid_579115 != nil:
    section.add "prettyPrint", valid_579115
  var valid_579116 = query.getOrDefault("oauth_token")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "oauth_token", valid_579116
  var valid_579117 = query.getOrDefault("$.xgafv")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = newJString("1"))
  if valid_579117 != nil:
    section.add "$.xgafv", valid_579117
  var valid_579118 = query.getOrDefault("alt")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = newJString("json"))
  if valid_579118 != nil:
    section.add "alt", valid_579118
  var valid_579119 = query.getOrDefault("uploadType")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "uploadType", valid_579119
  var valid_579120 = query.getOrDefault("quotaUser")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "quotaUser", valid_579120
  var valid_579121 = query.getOrDefault("callback")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "callback", valid_579121
  var valid_579122 = query.getOrDefault("fields")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "fields", valid_579122
  var valid_579123 = query.getOrDefault("access_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "access_token", valid_579123
  var valid_579124 = query.getOrDefault("upload_protocol")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "upload_protocol", valid_579124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579126: Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_579110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters. Ranges matching any of the specified data
  ## filters will be cleared.  Only values are cleared -- all other properties
  ## of the cell (such as formatting, data validation, etc..) are kept.
  ## 
  let valid = call_579126.validator(path, query, header, formData, body)
  let scheme = call_579126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579126.url(scheme.get, call_579126.host, call_579126.base,
                         call_579126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579126, url, valid)

proc call*(call_579127: Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_579110;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesBatchClearByDataFilter
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters. Ranges matching any of the specified data
  ## filters will be cleared.  Only values are cleared -- all other properties
  ## of the cell (such as formatting, data validation, etc..) are kept.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579128 = newJObject()
  var query_579129 = newJObject()
  var body_579130 = newJObject()
  add(query_579129, "key", newJString(key))
  add(query_579129, "prettyPrint", newJBool(prettyPrint))
  add(query_579129, "oauth_token", newJString(oauthToken))
  add(query_579129, "$.xgafv", newJString(Xgafv))
  add(query_579129, "alt", newJString(alt))
  add(query_579129, "uploadType", newJString(uploadType))
  add(query_579129, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579130 = body
  add(query_579129, "callback", newJString(callback))
  add(path_579128, "spreadsheetId", newJString(spreadsheetId))
  add(query_579129, "fields", newJString(fields))
  add(query_579129, "access_token", newJString(accessToken))
  add(query_579129, "upload_protocol", newJString(uploadProtocol))
  result = call_579127.call(path_579128, query_579129, nil, nil, body_579130)

var sheetsSpreadsheetsValuesBatchClearByDataFilter* = Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_579110(
    name: "sheetsSpreadsheetsValuesBatchClearByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchClearByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchClearByDataFilter_579111,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchClearByDataFilter_579112,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchGet_579131 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsValuesBatchGet_579133(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values:batchGet")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchGet_579132(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579134 = path.getOrDefault("spreadsheetId")
  valid_579134 = validateParameter(valid_579134, JString, required = true,
                                 default = nil)
  if valid_579134 != nil:
    section.add "spreadsheetId", valid_579134
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ranges: JArray
  ##         : The A1 notation of the values to retrieve.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   majorDimension: JString
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dateTimeRenderOption: JString
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   valueRenderOption: JString
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  section = newJObject()
  var valid_579135 = query.getOrDefault("key")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "key", valid_579135
  var valid_579136 = query.getOrDefault("ranges")
  valid_579136 = validateParameter(valid_579136, JArray, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "ranges", valid_579136
  var valid_579137 = query.getOrDefault("prettyPrint")
  valid_579137 = validateParameter(valid_579137, JBool, required = false,
                                 default = newJBool(true))
  if valid_579137 != nil:
    section.add "prettyPrint", valid_579137
  var valid_579138 = query.getOrDefault("oauth_token")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "oauth_token", valid_579138
  var valid_579139 = query.getOrDefault("majorDimension")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = newJString("DIMENSION_UNSPECIFIED"))
  if valid_579139 != nil:
    section.add "majorDimension", valid_579139
  var valid_579140 = query.getOrDefault("$.xgafv")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = newJString("1"))
  if valid_579140 != nil:
    section.add "$.xgafv", valid_579140
  var valid_579141 = query.getOrDefault("alt")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = newJString("json"))
  if valid_579141 != nil:
    section.add "alt", valid_579141
  var valid_579142 = query.getOrDefault("uploadType")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "uploadType", valid_579142
  var valid_579143 = query.getOrDefault("quotaUser")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "quotaUser", valid_579143
  var valid_579144 = query.getOrDefault("dateTimeRenderOption")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_579144 != nil:
    section.add "dateTimeRenderOption", valid_579144
  var valid_579145 = query.getOrDefault("callback")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "callback", valid_579145
  var valid_579146 = query.getOrDefault("fields")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "fields", valid_579146
  var valid_579147 = query.getOrDefault("access_token")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "access_token", valid_579147
  var valid_579148 = query.getOrDefault("upload_protocol")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "upload_protocol", valid_579148
  var valid_579149 = query.getOrDefault("valueRenderOption")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_579149 != nil:
    section.add "valueRenderOption", valid_579149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579150: Call_SheetsSpreadsheetsValuesBatchGet_579131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## 
  let valid = call_579150.validator(path, query, header, formData, body)
  let scheme = call_579150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579150.url(scheme.get, call_579150.host, call_579150.base,
                         call_579150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579150, url, valid)

proc call*(call_579151: Call_SheetsSpreadsheetsValuesBatchGet_579131;
          spreadsheetId: string; key: string = ""; ranges: JsonNode = nil;
          prettyPrint: bool = true; oauthToken: string = "";
          majorDimension: string = "DIMENSION_UNSPECIFIED"; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          dateTimeRenderOption: string = "SERIAL_NUMBER"; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          valueRenderOption: string = "FORMATTED_VALUE"): Recallable =
  ## sheetsSpreadsheetsValuesBatchGet
  ## Returns one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ranges: JArray
  ##         : The A1 notation of the values to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   majorDimension: string
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dateTimeRenderOption: string
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   valueRenderOption: string
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  var path_579152 = newJObject()
  var query_579153 = newJObject()
  add(query_579153, "key", newJString(key))
  if ranges != nil:
    query_579153.add "ranges", ranges
  add(query_579153, "prettyPrint", newJBool(prettyPrint))
  add(query_579153, "oauth_token", newJString(oauthToken))
  add(query_579153, "majorDimension", newJString(majorDimension))
  add(query_579153, "$.xgafv", newJString(Xgafv))
  add(query_579153, "alt", newJString(alt))
  add(query_579153, "uploadType", newJString(uploadType))
  add(query_579153, "quotaUser", newJString(quotaUser))
  add(query_579153, "dateTimeRenderOption", newJString(dateTimeRenderOption))
  add(query_579153, "callback", newJString(callback))
  add(path_579152, "spreadsheetId", newJString(spreadsheetId))
  add(query_579153, "fields", newJString(fields))
  add(query_579153, "access_token", newJString(accessToken))
  add(query_579153, "upload_protocol", newJString(uploadProtocol))
  add(query_579153, "valueRenderOption", newJString(valueRenderOption))
  result = call_579151.call(path_579152, query_579153, nil, nil, nil)

var sheetsSpreadsheetsValuesBatchGet* = Call_SheetsSpreadsheetsValuesBatchGet_579131(
    name: "sheetsSpreadsheetsValuesBatchGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchGet",
    validator: validate_SheetsSpreadsheetsValuesBatchGet_579132, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchGet_579133, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_579154 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsValuesBatchGetByDataFilter_579156(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values:batchGetByDataFilter")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchGetByDataFilter_579155(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns one or more ranges of values that match the specified data filters.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters.  Ranges that match any of the data filters in
  ## the request will be returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579157 = path.getOrDefault("spreadsheetId")
  valid_579157 = validateParameter(valid_579157, JString, required = true,
                                 default = nil)
  if valid_579157 != nil:
    section.add "spreadsheetId", valid_579157
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579158 = query.getOrDefault("key")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "key", valid_579158
  var valid_579159 = query.getOrDefault("prettyPrint")
  valid_579159 = validateParameter(valid_579159, JBool, required = false,
                                 default = newJBool(true))
  if valid_579159 != nil:
    section.add "prettyPrint", valid_579159
  var valid_579160 = query.getOrDefault("oauth_token")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "oauth_token", valid_579160
  var valid_579161 = query.getOrDefault("$.xgafv")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("1"))
  if valid_579161 != nil:
    section.add "$.xgafv", valid_579161
  var valid_579162 = query.getOrDefault("alt")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = newJString("json"))
  if valid_579162 != nil:
    section.add "alt", valid_579162
  var valid_579163 = query.getOrDefault("uploadType")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "uploadType", valid_579163
  var valid_579164 = query.getOrDefault("quotaUser")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "quotaUser", valid_579164
  var valid_579165 = query.getOrDefault("callback")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "callback", valid_579165
  var valid_579166 = query.getOrDefault("fields")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "fields", valid_579166
  var valid_579167 = query.getOrDefault("access_token")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "access_token", valid_579167
  var valid_579168 = query.getOrDefault("upload_protocol")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "upload_protocol", valid_579168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579170: Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_579154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns one or more ranges of values that match the specified data filters.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters.  Ranges that match any of the data filters in
  ## the request will be returned.
  ## 
  let valid = call_579170.validator(path, query, header, formData, body)
  let scheme = call_579170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579170.url(scheme.get, call_579170.host, call_579170.base,
                         call_579170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579170, url, valid)

proc call*(call_579171: Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_579154;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesBatchGetByDataFilter
  ## Returns one or more ranges of values that match the specified data filters.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters.  Ranges that match any of the data filters in
  ## the request will be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579172 = newJObject()
  var query_579173 = newJObject()
  var body_579174 = newJObject()
  add(query_579173, "key", newJString(key))
  add(query_579173, "prettyPrint", newJBool(prettyPrint))
  add(query_579173, "oauth_token", newJString(oauthToken))
  add(query_579173, "$.xgafv", newJString(Xgafv))
  add(query_579173, "alt", newJString(alt))
  add(query_579173, "uploadType", newJString(uploadType))
  add(query_579173, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579174 = body
  add(query_579173, "callback", newJString(callback))
  add(path_579172, "spreadsheetId", newJString(spreadsheetId))
  add(query_579173, "fields", newJString(fields))
  add(query_579173, "access_token", newJString(accessToken))
  add(query_579173, "upload_protocol", newJString(uploadProtocol))
  result = call_579171.call(path_579172, query_579173, nil, nil, body_579174)

var sheetsSpreadsheetsValuesBatchGetByDataFilter* = Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_579154(
    name: "sheetsSpreadsheetsValuesBatchGetByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchGetByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchGetByDataFilter_579155,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchGetByDataFilter_579156,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchUpdate_579175 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsValuesBatchUpdate_579177(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: "/values:batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchUpdate_579176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## ValueRanges.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579178 = path.getOrDefault("spreadsheetId")
  valid_579178 = validateParameter(valid_579178, JString, required = true,
                                 default = nil)
  if valid_579178 != nil:
    section.add "spreadsheetId", valid_579178
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579179 = query.getOrDefault("key")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "key", valid_579179
  var valid_579180 = query.getOrDefault("prettyPrint")
  valid_579180 = validateParameter(valid_579180, JBool, required = false,
                                 default = newJBool(true))
  if valid_579180 != nil:
    section.add "prettyPrint", valid_579180
  var valid_579181 = query.getOrDefault("oauth_token")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "oauth_token", valid_579181
  var valid_579182 = query.getOrDefault("$.xgafv")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = newJString("1"))
  if valid_579182 != nil:
    section.add "$.xgafv", valid_579182
  var valid_579183 = query.getOrDefault("alt")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = newJString("json"))
  if valid_579183 != nil:
    section.add "alt", valid_579183
  var valid_579184 = query.getOrDefault("uploadType")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "uploadType", valid_579184
  var valid_579185 = query.getOrDefault("quotaUser")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "quotaUser", valid_579185
  var valid_579186 = query.getOrDefault("callback")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "callback", valid_579186
  var valid_579187 = query.getOrDefault("fields")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "fields", valid_579187
  var valid_579188 = query.getOrDefault("access_token")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "access_token", valid_579188
  var valid_579189 = query.getOrDefault("upload_protocol")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "upload_protocol", valid_579189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579191: Call_SheetsSpreadsheetsValuesBatchUpdate_579175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## ValueRanges.
  ## 
  let valid = call_579191.validator(path, query, header, formData, body)
  let scheme = call_579191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579191.url(scheme.get, call_579191.host, call_579191.base,
                         call_579191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579191, url, valid)

proc call*(call_579192: Call_SheetsSpreadsheetsValuesBatchUpdate_579175;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesBatchUpdate
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## ValueRanges.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579193 = newJObject()
  var query_579194 = newJObject()
  var body_579195 = newJObject()
  add(query_579194, "key", newJString(key))
  add(query_579194, "prettyPrint", newJBool(prettyPrint))
  add(query_579194, "oauth_token", newJString(oauthToken))
  add(query_579194, "$.xgafv", newJString(Xgafv))
  add(query_579194, "alt", newJString(alt))
  add(query_579194, "uploadType", newJString(uploadType))
  add(query_579194, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579195 = body
  add(query_579194, "callback", newJString(callback))
  add(path_579193, "spreadsheetId", newJString(spreadsheetId))
  add(query_579194, "fields", newJString(fields))
  add(query_579194, "access_token", newJString(accessToken))
  add(query_579194, "upload_protocol", newJString(uploadProtocol))
  result = call_579192.call(path_579193, query_579194, nil, nil, body_579195)

var sheetsSpreadsheetsValuesBatchUpdate* = Call_SheetsSpreadsheetsValuesBatchUpdate_579175(
    name: "sheetsSpreadsheetsValuesBatchUpdate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchUpdate",
    validator: validate_SheetsSpreadsheetsValuesBatchUpdate_579176, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchUpdate_579177, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_579196 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_579198(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"), (
        kind: ConstantSegment, value: "/values:batchUpdateByDataFilter")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_579197(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## DataFilterValueRanges.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The ID of the spreadsheet to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579199 = path.getOrDefault("spreadsheetId")
  valid_579199 = validateParameter(valid_579199, JString, required = true,
                                 default = nil)
  if valid_579199 != nil:
    section.add "spreadsheetId", valid_579199
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579200 = query.getOrDefault("key")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "key", valid_579200
  var valid_579201 = query.getOrDefault("prettyPrint")
  valid_579201 = validateParameter(valid_579201, JBool, required = false,
                                 default = newJBool(true))
  if valid_579201 != nil:
    section.add "prettyPrint", valid_579201
  var valid_579202 = query.getOrDefault("oauth_token")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "oauth_token", valid_579202
  var valid_579203 = query.getOrDefault("$.xgafv")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = newJString("1"))
  if valid_579203 != nil:
    section.add "$.xgafv", valid_579203
  var valid_579204 = query.getOrDefault("alt")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = newJString("json"))
  if valid_579204 != nil:
    section.add "alt", valid_579204
  var valid_579205 = query.getOrDefault("uploadType")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "uploadType", valid_579205
  var valid_579206 = query.getOrDefault("quotaUser")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "quotaUser", valid_579206
  var valid_579207 = query.getOrDefault("callback")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "callback", valid_579207
  var valid_579208 = query.getOrDefault("fields")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "fields", valid_579208
  var valid_579209 = query.getOrDefault("access_token")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "access_token", valid_579209
  var valid_579210 = query.getOrDefault("upload_protocol")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "upload_protocol", valid_579210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579212: Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_579196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## DataFilterValueRanges.
  ## 
  let valid = call_579212.validator(path, query, header, formData, body)
  let scheme = call_579212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579212.url(scheme.get, call_579212.host, call_579212.base,
                         call_579212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579212, url, valid)

proc call*(call_579213: Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_579196;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsValuesBatchUpdateByDataFilter
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## DataFilterValueRanges.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579214 = newJObject()
  var query_579215 = newJObject()
  var body_579216 = newJObject()
  add(query_579215, "key", newJString(key))
  add(query_579215, "prettyPrint", newJBool(prettyPrint))
  add(query_579215, "oauth_token", newJString(oauthToken))
  add(query_579215, "$.xgafv", newJString(Xgafv))
  add(query_579215, "alt", newJString(alt))
  add(query_579215, "uploadType", newJString(uploadType))
  add(query_579215, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579216 = body
  add(query_579215, "callback", newJString(callback))
  add(path_579214, "spreadsheetId", newJString(spreadsheetId))
  add(query_579215, "fields", newJString(fields))
  add(query_579215, "access_token", newJString(accessToken))
  add(query_579215, "upload_protocol", newJString(uploadProtocol))
  result = call_579213.call(path_579214, query_579215, nil, nil, body_579216)

var sheetsSpreadsheetsValuesBatchUpdateByDataFilter* = Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_579196(
    name: "sheetsSpreadsheetsValuesBatchUpdateByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchUpdateByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_579197,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_579198,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsBatchUpdate_579217 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsBatchUpdate_579219(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: ":batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsBatchUpdate_579218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Applies one or more updates to the spreadsheet.
  ## 
  ## Each request is validated before
  ## being applied. If any request is not valid then the entire request will
  ## fail and nothing will be applied.
  ## 
  ## Some requests have replies to
  ## give you some information about how
  ## they are applied. The replies will mirror the requests.  For example,
  ## if you applied 4 updates and the 3rd one had a reply, then the
  ## response will have 2 empty replies, the actual reply, and another empty
  ## reply, in that order.
  ## 
  ## Due to the collaborative nature of spreadsheets, it is not guaranteed that
  ## the spreadsheet will reflect exactly your changes after this completes,
  ## however it is guaranteed that the updates in the request will be
  ## applied together atomically. Your changes may be altered with respect to
  ## collaborator changes. If there are no collaborators, the spreadsheet
  ## should reflect your changes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The spreadsheet to apply the updates to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579220 = path.getOrDefault("spreadsheetId")
  valid_579220 = validateParameter(valid_579220, JString, required = true,
                                 default = nil)
  if valid_579220 != nil:
    section.add "spreadsheetId", valid_579220
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579221 = query.getOrDefault("key")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "key", valid_579221
  var valid_579222 = query.getOrDefault("prettyPrint")
  valid_579222 = validateParameter(valid_579222, JBool, required = false,
                                 default = newJBool(true))
  if valid_579222 != nil:
    section.add "prettyPrint", valid_579222
  var valid_579223 = query.getOrDefault("oauth_token")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "oauth_token", valid_579223
  var valid_579224 = query.getOrDefault("$.xgafv")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = newJString("1"))
  if valid_579224 != nil:
    section.add "$.xgafv", valid_579224
  var valid_579225 = query.getOrDefault("alt")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = newJString("json"))
  if valid_579225 != nil:
    section.add "alt", valid_579225
  var valid_579226 = query.getOrDefault("uploadType")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "uploadType", valid_579226
  var valid_579227 = query.getOrDefault("quotaUser")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "quotaUser", valid_579227
  var valid_579228 = query.getOrDefault("callback")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "callback", valid_579228
  var valid_579229 = query.getOrDefault("fields")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "fields", valid_579229
  var valid_579230 = query.getOrDefault("access_token")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "access_token", valid_579230
  var valid_579231 = query.getOrDefault("upload_protocol")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "upload_protocol", valid_579231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579233: Call_SheetsSpreadsheetsBatchUpdate_579217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Applies one or more updates to the spreadsheet.
  ## 
  ## Each request is validated before
  ## being applied. If any request is not valid then the entire request will
  ## fail and nothing will be applied.
  ## 
  ## Some requests have replies to
  ## give you some information about how
  ## they are applied. The replies will mirror the requests.  For example,
  ## if you applied 4 updates and the 3rd one had a reply, then the
  ## response will have 2 empty replies, the actual reply, and another empty
  ## reply, in that order.
  ## 
  ## Due to the collaborative nature of spreadsheets, it is not guaranteed that
  ## the spreadsheet will reflect exactly your changes after this completes,
  ## however it is guaranteed that the updates in the request will be
  ## applied together atomically. Your changes may be altered with respect to
  ## collaborator changes. If there are no collaborators, the spreadsheet
  ## should reflect your changes.
  ## 
  let valid = call_579233.validator(path, query, header, formData, body)
  let scheme = call_579233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579233.url(scheme.get, call_579233.host, call_579233.base,
                         call_579233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579233, url, valid)

proc call*(call_579234: Call_SheetsSpreadsheetsBatchUpdate_579217;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsBatchUpdate
  ## Applies one or more updates to the spreadsheet.
  ## 
  ## Each request is validated before
  ## being applied. If any request is not valid then the entire request will
  ## fail and nothing will be applied.
  ## 
  ## Some requests have replies to
  ## give you some information about how
  ## they are applied. The replies will mirror the requests.  For example,
  ## if you applied 4 updates and the 3rd one had a reply, then the
  ## response will have 2 empty replies, the actual reply, and another empty
  ## reply, in that order.
  ## 
  ## Due to the collaborative nature of spreadsheets, it is not guaranteed that
  ## the spreadsheet will reflect exactly your changes after this completes,
  ## however it is guaranteed that the updates in the request will be
  ## applied together atomically. Your changes may be altered with respect to
  ## collaborator changes. If there are no collaborators, the spreadsheet
  ## should reflect your changes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The spreadsheet to apply the updates to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579235 = newJObject()
  var query_579236 = newJObject()
  var body_579237 = newJObject()
  add(query_579236, "key", newJString(key))
  add(query_579236, "prettyPrint", newJBool(prettyPrint))
  add(query_579236, "oauth_token", newJString(oauthToken))
  add(query_579236, "$.xgafv", newJString(Xgafv))
  add(query_579236, "alt", newJString(alt))
  add(query_579236, "uploadType", newJString(uploadType))
  add(query_579236, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579237 = body
  add(query_579236, "callback", newJString(callback))
  add(path_579235, "spreadsheetId", newJString(spreadsheetId))
  add(query_579236, "fields", newJString(fields))
  add(query_579236, "access_token", newJString(accessToken))
  add(query_579236, "upload_protocol", newJString(uploadProtocol))
  result = call_579234.call(path_579235, query_579236, nil, nil, body_579237)

var sheetsSpreadsheetsBatchUpdate* = Call_SheetsSpreadsheetsBatchUpdate_579217(
    name: "sheetsSpreadsheetsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}:batchUpdate",
    validator: validate_SheetsSpreadsheetsBatchUpdate_579218, base: "/",
    url: url_SheetsSpreadsheetsBatchUpdate_579219, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsGetByDataFilter_579238 = ref object of OpenApiRestCall_578348
proc url_SheetsSpreadsheetsGetByDataFilter_579240(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId"),
               (kind: ConstantSegment, value: ":getByDataFilter")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsGetByDataFilter_579239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the spreadsheet at the given ID.
  ## The caller must specify the spreadsheet ID.
  ## 
  ## This method differs from GetSpreadsheet in that it allows selecting
  ## which subsets of spreadsheet data to return by specifying a
  ## dataFilters parameter.
  ## Multiple DataFilters can be specified.  Specifying one or
  ## more data filters will return the portions of the spreadsheet that
  ## intersect ranges matched by any of the filters.
  ## 
  ## By default, data within grids will not be returned.
  ## You can include grid data one of two ways:
  ## 
  ## * Specify a field mask listing your desired fields using the `fields` URL
  ## parameter in HTTP
  ## 
  ## * Set the includeGridData
  ## parameter to true.  If a field mask is set, the `includeGridData`
  ## parameter is ignored
  ## 
  ## For large spreadsheets, it is recommended to retrieve only the specific
  ## fields of the spreadsheet that you want.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   spreadsheetId: JString (required)
  ##                : The spreadsheet to request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `spreadsheetId` field"
  var valid_579241 = path.getOrDefault("spreadsheetId")
  valid_579241 = validateParameter(valid_579241, JString, required = true,
                                 default = nil)
  if valid_579241 != nil:
    section.add "spreadsheetId", valid_579241
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579242 = query.getOrDefault("key")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "key", valid_579242
  var valid_579243 = query.getOrDefault("prettyPrint")
  valid_579243 = validateParameter(valid_579243, JBool, required = false,
                                 default = newJBool(true))
  if valid_579243 != nil:
    section.add "prettyPrint", valid_579243
  var valid_579244 = query.getOrDefault("oauth_token")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "oauth_token", valid_579244
  var valid_579245 = query.getOrDefault("$.xgafv")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = newJString("1"))
  if valid_579245 != nil:
    section.add "$.xgafv", valid_579245
  var valid_579246 = query.getOrDefault("alt")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = newJString("json"))
  if valid_579246 != nil:
    section.add "alt", valid_579246
  var valid_579247 = query.getOrDefault("uploadType")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "uploadType", valid_579247
  var valid_579248 = query.getOrDefault("quotaUser")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "quotaUser", valid_579248
  var valid_579249 = query.getOrDefault("callback")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "callback", valid_579249
  var valid_579250 = query.getOrDefault("fields")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "fields", valid_579250
  var valid_579251 = query.getOrDefault("access_token")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "access_token", valid_579251
  var valid_579252 = query.getOrDefault("upload_protocol")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "upload_protocol", valid_579252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579254: Call_SheetsSpreadsheetsGetByDataFilter_579238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the spreadsheet at the given ID.
  ## The caller must specify the spreadsheet ID.
  ## 
  ## This method differs from GetSpreadsheet in that it allows selecting
  ## which subsets of spreadsheet data to return by specifying a
  ## dataFilters parameter.
  ## Multiple DataFilters can be specified.  Specifying one or
  ## more data filters will return the portions of the spreadsheet that
  ## intersect ranges matched by any of the filters.
  ## 
  ## By default, data within grids will not be returned.
  ## You can include grid data one of two ways:
  ## 
  ## * Specify a field mask listing your desired fields using the `fields` URL
  ## parameter in HTTP
  ## 
  ## * Set the includeGridData
  ## parameter to true.  If a field mask is set, the `includeGridData`
  ## parameter is ignored
  ## 
  ## For large spreadsheets, it is recommended to retrieve only the specific
  ## fields of the spreadsheet that you want.
  ## 
  let valid = call_579254.validator(path, query, header, formData, body)
  let scheme = call_579254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579254.url(scheme.get, call_579254.host, call_579254.base,
                         call_579254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579254, url, valid)

proc call*(call_579255: Call_SheetsSpreadsheetsGetByDataFilter_579238;
          spreadsheetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sheetsSpreadsheetsGetByDataFilter
  ## Returns the spreadsheet at the given ID.
  ## The caller must specify the spreadsheet ID.
  ## 
  ## This method differs from GetSpreadsheet in that it allows selecting
  ## which subsets of spreadsheet data to return by specifying a
  ## dataFilters parameter.
  ## Multiple DataFilters can be specified.  Specifying one or
  ## more data filters will return the portions of the spreadsheet that
  ## intersect ranges matched by any of the filters.
  ## 
  ## By default, data within grids will not be returned.
  ## You can include grid data one of two ways:
  ## 
  ## * Specify a field mask listing your desired fields using the `fields` URL
  ## parameter in HTTP
  ## 
  ## * Set the includeGridData
  ## parameter to true.  If a field mask is set, the `includeGridData`
  ## parameter is ignored
  ## 
  ## For large spreadsheets, it is recommended to retrieve only the specific
  ## fields of the spreadsheet that you want.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   spreadsheetId: string (required)
  ##                : The spreadsheet to request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579256 = newJObject()
  var query_579257 = newJObject()
  var body_579258 = newJObject()
  add(query_579257, "key", newJString(key))
  add(query_579257, "prettyPrint", newJBool(prettyPrint))
  add(query_579257, "oauth_token", newJString(oauthToken))
  add(query_579257, "$.xgafv", newJString(Xgafv))
  add(query_579257, "alt", newJString(alt))
  add(query_579257, "uploadType", newJString(uploadType))
  add(query_579257, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579258 = body
  add(query_579257, "callback", newJString(callback))
  add(path_579256, "spreadsheetId", newJString(spreadsheetId))
  add(query_579257, "fields", newJString(fields))
  add(query_579257, "access_token", newJString(accessToken))
  add(query_579257, "upload_protocol", newJString(uploadProtocol))
  result = call_579255.call(path_579256, query_579257, nil, nil, body_579258)

var sheetsSpreadsheetsGetByDataFilter* = Call_SheetsSpreadsheetsGetByDataFilter_579238(
    name: "sheetsSpreadsheetsGetByDataFilter", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}:getByDataFilter",
    validator: validate_SheetsSpreadsheetsGetByDataFilter_579239, base: "/",
    url: url_SheetsSpreadsheetsGetByDataFilter_579240, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
