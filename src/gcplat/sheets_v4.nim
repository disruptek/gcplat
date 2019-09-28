
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "sheets"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SheetsSpreadsheetsCreate_579690 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsCreate_579692(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SheetsSpreadsheetsCreate_579691(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("quotaUser")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "quotaUser", valid_579806
  var valid_579820 = query.getOrDefault("alt")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = newJString("json"))
  if valid_579820 != nil:
    section.add "alt", valid_579820
  var valid_579821 = query.getOrDefault("oauth_token")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "oauth_token", valid_579821
  var valid_579822 = query.getOrDefault("callback")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "callback", valid_579822
  var valid_579823 = query.getOrDefault("access_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "access_token", valid_579823
  var valid_579824 = query.getOrDefault("uploadType")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "uploadType", valid_579824
  var valid_579825 = query.getOrDefault("key")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "key", valid_579825
  var valid_579826 = query.getOrDefault("$.xgafv")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = newJString("1"))
  if valid_579826 != nil:
    section.add "$.xgafv", valid_579826
  var valid_579827 = query.getOrDefault("prettyPrint")
  valid_579827 = validateParameter(valid_579827, JBool, required = false,
                                 default = newJBool(true))
  if valid_579827 != nil:
    section.add "prettyPrint", valid_579827
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

proc call*(call_579851: Call_SheetsSpreadsheetsCreate_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ## 
  let valid = call_579851.validator(path, query, header, formData, body)
  let scheme = call_579851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579851.url(scheme.get, call_579851.host, call_579851.base,
                         call_579851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579851, url, valid)

proc call*(call_579922: Call_SheetsSpreadsheetsCreate_579690;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsCreate
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579923 = newJObject()
  var body_579925 = newJObject()
  add(query_579923, "upload_protocol", newJString(uploadProtocol))
  add(query_579923, "fields", newJString(fields))
  add(query_579923, "quotaUser", newJString(quotaUser))
  add(query_579923, "alt", newJString(alt))
  add(query_579923, "oauth_token", newJString(oauthToken))
  add(query_579923, "callback", newJString(callback))
  add(query_579923, "access_token", newJString(accessToken))
  add(query_579923, "uploadType", newJString(uploadType))
  add(query_579923, "key", newJString(key))
  add(query_579923, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579925 = body
  add(query_579923, "prettyPrint", newJBool(prettyPrint))
  result = call_579922.call(nil, query_579923, nil, nil, body_579925)

var sheetsSpreadsheetsCreate* = Call_SheetsSpreadsheetsCreate_579690(
    name: "sheetsSpreadsheetsCreate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com", route: "/v4/spreadsheets",
    validator: validate_SheetsSpreadsheetsCreate_579691, base: "/",
    url: url_SheetsSpreadsheetsCreate_579692, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsGet_579964 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsGet_579966(protocol: Scheme; host: string; base: string;
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

proc validate_SheetsSpreadsheetsGet_579965(path: JsonNode; query: JsonNode;
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
  var valid_579981 = path.getOrDefault("spreadsheetId")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "spreadsheetId", valid_579981
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   includeGridData: JBool
  ##                  : True if grid data should be returned.
  ## This parameter is ignored if a field mask was set in the request.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   ranges: JArray
  ##         : The ranges to retrieve from the spreadsheet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579982 = query.getOrDefault("upload_protocol")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "upload_protocol", valid_579982
  var valid_579983 = query.getOrDefault("fields")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "fields", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("includeGridData")
  valid_579986 = validateParameter(valid_579986, JBool, required = false, default = nil)
  if valid_579986 != nil:
    section.add "includeGridData", valid_579986
  var valid_579987 = query.getOrDefault("oauth_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "oauth_token", valid_579987
  var valid_579988 = query.getOrDefault("callback")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "callback", valid_579988
  var valid_579989 = query.getOrDefault("access_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "access_token", valid_579989
  var valid_579990 = query.getOrDefault("uploadType")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "uploadType", valid_579990
  var valid_579991 = query.getOrDefault("ranges")
  valid_579991 = validateParameter(valid_579991, JArray, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "ranges", valid_579991
  var valid_579992 = query.getOrDefault("key")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "key", valid_579992
  var valid_579993 = query.getOrDefault("$.xgafv")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("1"))
  if valid_579993 != nil:
    section.add "$.xgafv", valid_579993
  var valid_579994 = query.getOrDefault("prettyPrint")
  valid_579994 = validateParameter(valid_579994, JBool, required = false,
                                 default = newJBool(true))
  if valid_579994 != nil:
    section.add "prettyPrint", valid_579994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579995: Call_SheetsSpreadsheetsGet_579964; path: JsonNode;
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
  let valid = call_579995.validator(path, query, header, formData, body)
  let scheme = call_579995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579995.url(scheme.get, call_579995.host, call_579995.base,
                         call_579995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579995, url, valid)

proc call*(call_579996: Call_SheetsSpreadsheetsGet_579964; spreadsheetId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; includeGridData: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          ranges: JsonNode = nil; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   includeGridData: bool
  ##                  : True if grid data should be returned.
  ## This parameter is ignored if a field mask was set in the request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   ranges: JArray
  ##         : The ranges to retrieve from the spreadsheet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The spreadsheet to request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579997 = newJObject()
  var query_579998 = newJObject()
  add(query_579998, "upload_protocol", newJString(uploadProtocol))
  add(query_579998, "fields", newJString(fields))
  add(query_579998, "quotaUser", newJString(quotaUser))
  add(query_579998, "alt", newJString(alt))
  add(query_579998, "includeGridData", newJBool(includeGridData))
  add(query_579998, "oauth_token", newJString(oauthToken))
  add(query_579998, "callback", newJString(callback))
  add(query_579998, "access_token", newJString(accessToken))
  add(query_579998, "uploadType", newJString(uploadType))
  if ranges != nil:
    query_579998.add "ranges", ranges
  add(query_579998, "key", newJString(key))
  add(query_579998, "$.xgafv", newJString(Xgafv))
  add(path_579997, "spreadsheetId", newJString(spreadsheetId))
  add(query_579998, "prettyPrint", newJBool(prettyPrint))
  result = call_579996.call(path_579997, query_579998, nil, nil, nil)

var sheetsSpreadsheetsGet* = Call_SheetsSpreadsheetsGet_579964(
    name: "sheetsSpreadsheetsGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com", route: "/v4/spreadsheets/{spreadsheetId}",
    validator: validate_SheetsSpreadsheetsGet_579965, base: "/",
    url: url_SheetsSpreadsheetsGet_579966, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsDeveloperMetadataGet_579999 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsDeveloperMetadataGet_580001(protocol: Scheme;
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

proc validate_SheetsSpreadsheetsDeveloperMetadataGet_580000(path: JsonNode;
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
  var valid_580002 = path.getOrDefault("metadataId")
  valid_580002 = validateParameter(valid_580002, JInt, required = true, default = nil)
  if valid_580002 != nil:
    section.add "metadataId", valid_580002
  var valid_580003 = path.getOrDefault("spreadsheetId")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "spreadsheetId", valid_580003
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580004 = query.getOrDefault("upload_protocol")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "upload_protocol", valid_580004
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
  var valid_580006 = query.getOrDefault("quotaUser")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "quotaUser", valid_580006
  var valid_580007 = query.getOrDefault("alt")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = newJString("json"))
  if valid_580007 != nil:
    section.add "alt", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("callback")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "callback", valid_580009
  var valid_580010 = query.getOrDefault("access_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "access_token", valid_580010
  var valid_580011 = query.getOrDefault("uploadType")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "uploadType", valid_580011
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
  var valid_580013 = query.getOrDefault("$.xgafv")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("1"))
  if valid_580013 != nil:
    section.add "$.xgafv", valid_580013
  var valid_580014 = query.getOrDefault("prettyPrint")
  valid_580014 = validateParameter(valid_580014, JBool, required = false,
                                 default = newJBool(true))
  if valid_580014 != nil:
    section.add "prettyPrint", valid_580014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580015: Call_SheetsSpreadsheetsDeveloperMetadataGet_579999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the developer metadata with the specified ID.
  ## The caller must specify the spreadsheet ID and the developer metadata's
  ## unique metadataId.
  ## 
  let valid = call_580015.validator(path, query, header, formData, body)
  let scheme = call_580015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580015.url(scheme.get, call_580015.host, call_580015.base,
                         call_580015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580015, url, valid)

proc call*(call_580016: Call_SheetsSpreadsheetsDeveloperMetadataGet_579999;
          metadataId: int; spreadsheetId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsDeveloperMetadataGet
  ## Returns the developer metadata with the specified ID.
  ## The caller must specify the spreadsheet ID and the developer metadata's
  ## unique metadataId.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   metadataId: int (required)
  ##             : The ID of the developer metadata to retrieve.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve metadata from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580017 = newJObject()
  var query_580018 = newJObject()
  add(query_580018, "upload_protocol", newJString(uploadProtocol))
  add(query_580018, "fields", newJString(fields))
  add(query_580018, "quotaUser", newJString(quotaUser))
  add(query_580018, "alt", newJString(alt))
  add(path_580017, "metadataId", newJInt(metadataId))
  add(query_580018, "oauth_token", newJString(oauthToken))
  add(query_580018, "callback", newJString(callback))
  add(query_580018, "access_token", newJString(accessToken))
  add(query_580018, "uploadType", newJString(uploadType))
  add(query_580018, "key", newJString(key))
  add(query_580018, "$.xgafv", newJString(Xgafv))
  add(path_580017, "spreadsheetId", newJString(spreadsheetId))
  add(query_580018, "prettyPrint", newJBool(prettyPrint))
  result = call_580016.call(path_580017, query_580018, nil, nil, nil)

var sheetsSpreadsheetsDeveloperMetadataGet* = Call_SheetsSpreadsheetsDeveloperMetadataGet_579999(
    name: "sheetsSpreadsheetsDeveloperMetadataGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/developerMetadata/{metadataId}",
    validator: validate_SheetsSpreadsheetsDeveloperMetadataGet_580000, base: "/",
    url: url_SheetsSpreadsheetsDeveloperMetadataGet_580001,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsDeveloperMetadataSearch_580019 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsDeveloperMetadataSearch_580021(protocol: Scheme;
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

proc validate_SheetsSpreadsheetsDeveloperMetadataSearch_580020(path: JsonNode;
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
  var valid_580022 = path.getOrDefault("spreadsheetId")
  valid_580022 = validateParameter(valid_580022, JString, required = true,
                                 default = nil)
  if valid_580022 != nil:
    section.add "spreadsheetId", valid_580022
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580023 = query.getOrDefault("upload_protocol")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "upload_protocol", valid_580023
  var valid_580024 = query.getOrDefault("fields")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "fields", valid_580024
  var valid_580025 = query.getOrDefault("quotaUser")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "quotaUser", valid_580025
  var valid_580026 = query.getOrDefault("alt")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = newJString("json"))
  if valid_580026 != nil:
    section.add "alt", valid_580026
  var valid_580027 = query.getOrDefault("oauth_token")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "oauth_token", valid_580027
  var valid_580028 = query.getOrDefault("callback")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "callback", valid_580028
  var valid_580029 = query.getOrDefault("access_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "access_token", valid_580029
  var valid_580030 = query.getOrDefault("uploadType")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "uploadType", valid_580030
  var valid_580031 = query.getOrDefault("key")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "key", valid_580031
  var valid_580032 = query.getOrDefault("$.xgafv")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("1"))
  if valid_580032 != nil:
    section.add "$.xgafv", valid_580032
  var valid_580033 = query.getOrDefault("prettyPrint")
  valid_580033 = validateParameter(valid_580033, JBool, required = false,
                                 default = newJBool(true))
  if valid_580033 != nil:
    section.add "prettyPrint", valid_580033
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

proc call*(call_580035: Call_SheetsSpreadsheetsDeveloperMetadataSearch_580019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all developer metadata matching the specified DataFilter.
  ## If the provided DataFilter represents a DeveloperMetadataLookup object,
  ## this will return all DeveloperMetadata entries selected by it. If the
  ## DataFilter represents a location in a spreadsheet, this will return all
  ## developer metadata associated with locations intersecting that region.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_SheetsSpreadsheetsDeveloperMetadataSearch_580019;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsDeveloperMetadataSearch
  ## Returns all developer metadata matching the specified DataFilter.
  ## If the provided DataFilter represents a DeveloperMetadataLookup object,
  ## this will return all DeveloperMetadata entries selected by it. If the
  ## DataFilter represents a location in a spreadsheet, this will return all
  ## developer metadata associated with locations intersecting that region.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve metadata from.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  var body_580039 = newJObject()
  add(query_580038, "upload_protocol", newJString(uploadProtocol))
  add(query_580038, "fields", newJString(fields))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "alt", newJString(alt))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "callback", newJString(callback))
  add(query_580038, "access_token", newJString(accessToken))
  add(query_580038, "uploadType", newJString(uploadType))
  add(query_580038, "key", newJString(key))
  add(query_580038, "$.xgafv", newJString(Xgafv))
  add(path_580037, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_580039 = body
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  result = call_580036.call(path_580037, query_580038, nil, nil, body_580039)

var sheetsSpreadsheetsDeveloperMetadataSearch* = Call_SheetsSpreadsheetsDeveloperMetadataSearch_580019(
    name: "sheetsSpreadsheetsDeveloperMetadataSearch", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/developerMetadata:search",
    validator: validate_SheetsSpreadsheetsDeveloperMetadataSearch_580020,
    base: "/", url: url_SheetsSpreadsheetsDeveloperMetadataSearch_580021,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsSheetsCopyTo_580040 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsSheetsCopyTo_580042(protocol: Scheme; host: string;
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

proc validate_SheetsSpreadsheetsSheetsCopyTo_580041(path: JsonNode;
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
  var valid_580043 = path.getOrDefault("sheetId")
  valid_580043 = validateParameter(valid_580043, JInt, required = true, default = nil)
  if valid_580043 != nil:
    section.add "sheetId", valid_580043
  var valid_580044 = path.getOrDefault("spreadsheetId")
  valid_580044 = validateParameter(valid_580044, JString, required = true,
                                 default = nil)
  if valid_580044 != nil:
    section.add "spreadsheetId", valid_580044
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580045 = query.getOrDefault("upload_protocol")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "upload_protocol", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("quotaUser")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "quotaUser", valid_580047
  var valid_580048 = query.getOrDefault("alt")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("json"))
  if valid_580048 != nil:
    section.add "alt", valid_580048
  var valid_580049 = query.getOrDefault("oauth_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "oauth_token", valid_580049
  var valid_580050 = query.getOrDefault("callback")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "callback", valid_580050
  var valid_580051 = query.getOrDefault("access_token")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "access_token", valid_580051
  var valid_580052 = query.getOrDefault("uploadType")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "uploadType", valid_580052
  var valid_580053 = query.getOrDefault("key")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "key", valid_580053
  var valid_580054 = query.getOrDefault("$.xgafv")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("1"))
  if valid_580054 != nil:
    section.add "$.xgafv", valid_580054
  var valid_580055 = query.getOrDefault("prettyPrint")
  valid_580055 = validateParameter(valid_580055, JBool, required = false,
                                 default = newJBool(true))
  if valid_580055 != nil:
    section.add "prettyPrint", valid_580055
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

proc call*(call_580057: Call_SheetsSpreadsheetsSheetsCopyTo_580040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a single sheet from a spreadsheet to another spreadsheet.
  ## Returns the properties of the newly created sheet.
  ## 
  let valid = call_580057.validator(path, query, header, formData, body)
  let scheme = call_580057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580057.url(scheme.get, call_580057.host, call_580057.base,
                         call_580057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580057, url, valid)

proc call*(call_580058: Call_SheetsSpreadsheetsSheetsCopyTo_580040; sheetId: int;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsSheetsCopyTo
  ## Copies a single sheet from a spreadsheet to another spreadsheet.
  ## Returns the properties of the newly created sheet.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   sheetId: int (required)
  ##          : The ID of the sheet to copy.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet containing the sheet to copy.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580059 = newJObject()
  var query_580060 = newJObject()
  var body_580061 = newJObject()
  add(query_580060, "upload_protocol", newJString(uploadProtocol))
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(query_580060, "callback", newJString(callback))
  add(query_580060, "access_token", newJString(accessToken))
  add(query_580060, "uploadType", newJString(uploadType))
  add(query_580060, "key", newJString(key))
  add(query_580060, "$.xgafv", newJString(Xgafv))
  add(path_580059, "sheetId", newJInt(sheetId))
  add(path_580059, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_580061 = body
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  result = call_580058.call(path_580059, query_580060, nil, nil, body_580061)

var sheetsSpreadsheetsSheetsCopyTo* = Call_SheetsSpreadsheetsSheetsCopyTo_580040(
    name: "sheetsSpreadsheetsSheetsCopyTo", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/sheets/{sheetId}:copyTo",
    validator: validate_SheetsSpreadsheetsSheetsCopyTo_580041, base: "/",
    url: url_SheetsSpreadsheetsSheetsCopyTo_580042, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesUpdate_580085 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsValuesUpdate_580087(protocol: Scheme; host: string;
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

proc validate_SheetsSpreadsheetsValuesUpdate_580086(path: JsonNode;
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
  var valid_580088 = path.getOrDefault("spreadsheetId")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "spreadsheetId", valid_580088
  var valid_580089 = path.getOrDefault("range")
  valid_580089 = validateParameter(valid_580089, JString, required = true,
                                 default = nil)
  if valid_580089 != nil:
    section.add "range", valid_580089
  result.add "path", section
  ## parameters in `query` object:
  ##   responseValueRenderOption: JString
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   responseDateTimeRenderOption: JString
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is
  ## DateTimeRenderOption.SERIAL_NUMBER.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: JBool
  ##                          : Determines if the update response should include the values
  ## of the cells that were updated. By default, responses
  ## do not include the updated values.
  ## If the range to write was larger than than the range actually written,
  ## the response will include all values in the requested range (excluding
  ## trailing empty rows and columns).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   valueInputOption: JString
  ##                   : How the input data should be interpreted.
  section = newJObject()
  var valid_580090 = query.getOrDefault("responseValueRenderOption")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_580090 != nil:
    section.add "responseValueRenderOption", valid_580090
  var valid_580091 = query.getOrDefault("upload_protocol")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "upload_protocol", valid_580091
  var valid_580092 = query.getOrDefault("fields")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "fields", valid_580092
  var valid_580093 = query.getOrDefault("quotaUser")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "quotaUser", valid_580093
  var valid_580094 = query.getOrDefault("alt")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("json"))
  if valid_580094 != nil:
    section.add "alt", valid_580094
  var valid_580095 = query.getOrDefault("responseDateTimeRenderOption")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_580095 != nil:
    section.add "responseDateTimeRenderOption", valid_580095
  var valid_580096 = query.getOrDefault("oauth_token")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "oauth_token", valid_580096
  var valid_580097 = query.getOrDefault("callback")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "callback", valid_580097
  var valid_580098 = query.getOrDefault("access_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "access_token", valid_580098
  var valid_580099 = query.getOrDefault("uploadType")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "uploadType", valid_580099
  var valid_580100 = query.getOrDefault("includeValuesInResponse")
  valid_580100 = validateParameter(valid_580100, JBool, required = false, default = nil)
  if valid_580100 != nil:
    section.add "includeValuesInResponse", valid_580100
  var valid_580101 = query.getOrDefault("key")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "key", valid_580101
  var valid_580102 = query.getOrDefault("$.xgafv")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = newJString("1"))
  if valid_580102 != nil:
    section.add "$.xgafv", valid_580102
  var valid_580103 = query.getOrDefault("prettyPrint")
  valid_580103 = validateParameter(valid_580103, JBool, required = false,
                                 default = newJBool(true))
  if valid_580103 != nil:
    section.add "prettyPrint", valid_580103
  var valid_580104 = query.getOrDefault("valueInputOption")
  valid_580104 = validateParameter(valid_580104, JString, required = false, default = newJString(
      "INPUT_VALUE_OPTION_UNSPECIFIED"))
  if valid_580104 != nil:
    section.add "valueInputOption", valid_580104
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

proc call*(call_580106: Call_SheetsSpreadsheetsValuesUpdate_580085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets values in a range of a spreadsheet.
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.
  ## 
  let valid = call_580106.validator(path, query, header, formData, body)
  let scheme = call_580106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580106.url(scheme.get, call_580106.host, call_580106.base,
                         call_580106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580106, url, valid)

proc call*(call_580107: Call_SheetsSpreadsheetsValuesUpdate_580085;
          spreadsheetId: string; range: string;
          responseValueRenderOption: string = "FORMATTED_VALUE";
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json";
          responseDateTimeRenderOption: string = "SERIAL_NUMBER";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; includeValuesInResponse: bool = false;
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true;
          valueInputOption: string = "INPUT_VALUE_OPTION_UNSPECIFIED"): Recallable =
  ## sheetsSpreadsheetsValuesUpdate
  ## Sets values in a range of a spreadsheet.
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.
  ##   responseValueRenderOption: string
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   responseDateTimeRenderOption: string
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is
  ## DateTimeRenderOption.SERIAL_NUMBER.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: bool
  ##                          : Determines if the update response should include the values
  ## of the cells that were updated. By default, responses
  ## do not include the updated values.
  ## If the range to write was larger than than the range actually written,
  ## the response will include all values in the requested range (excluding
  ## trailing empty rows and columns).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   valueInputOption: string
  ##                   : How the input data should be interpreted.
  ##   range: string (required)
  ##        : The A1 notation of the values to update.
  var path_580108 = newJObject()
  var query_580109 = newJObject()
  var body_580110 = newJObject()
  add(query_580109, "responseValueRenderOption",
      newJString(responseValueRenderOption))
  add(query_580109, "upload_protocol", newJString(uploadProtocol))
  add(query_580109, "fields", newJString(fields))
  add(query_580109, "quotaUser", newJString(quotaUser))
  add(query_580109, "alt", newJString(alt))
  add(query_580109, "responseDateTimeRenderOption",
      newJString(responseDateTimeRenderOption))
  add(query_580109, "oauth_token", newJString(oauthToken))
  add(query_580109, "callback", newJString(callback))
  add(query_580109, "access_token", newJString(accessToken))
  add(query_580109, "uploadType", newJString(uploadType))
  add(query_580109, "includeValuesInResponse", newJBool(includeValuesInResponse))
  add(query_580109, "key", newJString(key))
  add(query_580109, "$.xgafv", newJString(Xgafv))
  add(path_580108, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_580110 = body
  add(query_580109, "prettyPrint", newJBool(prettyPrint))
  add(query_580109, "valueInputOption", newJString(valueInputOption))
  add(path_580108, "range", newJString(range))
  result = call_580107.call(path_580108, query_580109, nil, nil, body_580110)

var sheetsSpreadsheetsValuesUpdate* = Call_SheetsSpreadsheetsValuesUpdate_580085(
    name: "sheetsSpreadsheetsValuesUpdate", meth: HttpMethod.HttpPut,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}",
    validator: validate_SheetsSpreadsheetsValuesUpdate_580086, base: "/",
    url: url_SheetsSpreadsheetsValuesUpdate_580087, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesGet_580062 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsValuesGet_580064(protocol: Scheme; host: string;
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

proc validate_SheetsSpreadsheetsValuesGet_580063(path: JsonNode; query: JsonNode;
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
  var valid_580065 = path.getOrDefault("spreadsheetId")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "spreadsheetId", valid_580065
  var valid_580066 = path.getOrDefault("range")
  valid_580066 = validateParameter(valid_580066, JString, required = true,
                                 default = nil)
  if valid_580066 != nil:
    section.add "range", valid_580066
  result.add "path", section
  ## parameters in `query` object:
  ##   majorDimension: JString
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   valueRenderOption: JString
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   dateTimeRenderOption: JString
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580067 = query.getOrDefault("majorDimension")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("DIMENSION_UNSPECIFIED"))
  if valid_580067 != nil:
    section.add "majorDimension", valid_580067
  var valid_580068 = query.getOrDefault("upload_protocol")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "upload_protocol", valid_580068
  var valid_580069 = query.getOrDefault("fields")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "fields", valid_580069
  var valid_580070 = query.getOrDefault("quotaUser")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "quotaUser", valid_580070
  var valid_580071 = query.getOrDefault("alt")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("json"))
  if valid_580071 != nil:
    section.add "alt", valid_580071
  var valid_580072 = query.getOrDefault("valueRenderOption")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_580072 != nil:
    section.add "valueRenderOption", valid_580072
  var valid_580073 = query.getOrDefault("oauth_token")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "oauth_token", valid_580073
  var valid_580074 = query.getOrDefault("callback")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "callback", valid_580074
  var valid_580075 = query.getOrDefault("access_token")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "access_token", valid_580075
  var valid_580076 = query.getOrDefault("uploadType")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "uploadType", valid_580076
  var valid_580077 = query.getOrDefault("key")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "key", valid_580077
  var valid_580078 = query.getOrDefault("$.xgafv")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("1"))
  if valid_580078 != nil:
    section.add "$.xgafv", valid_580078
  var valid_580079 = query.getOrDefault("dateTimeRenderOption")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_580079 != nil:
    section.add "dateTimeRenderOption", valid_580079
  var valid_580080 = query.getOrDefault("prettyPrint")
  valid_580080 = validateParameter(valid_580080, JBool, required = false,
                                 default = newJBool(true))
  if valid_580080 != nil:
    section.add "prettyPrint", valid_580080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580081: Call_SheetsSpreadsheetsValuesGet_580062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a range of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and a range.
  ## 
  let valid = call_580081.validator(path, query, header, formData, body)
  let scheme = call_580081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580081.url(scheme.get, call_580081.host, call_580081.base,
                         call_580081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580081, url, valid)

proc call*(call_580082: Call_SheetsSpreadsheetsValuesGet_580062;
          spreadsheetId: string; range: string;
          majorDimension: string = "DIMENSION_UNSPECIFIED";
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; valueRenderOption: string = "FORMATTED_VALUE";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          dateTimeRenderOption: string = "SERIAL_NUMBER"; prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesGet
  ## Returns a range of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and a range.
  ##   majorDimension: string
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   valueRenderOption: string
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   dateTimeRenderOption: string
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   range: string (required)
  ##        : The A1 notation of the values to retrieve.
  var path_580083 = newJObject()
  var query_580084 = newJObject()
  add(query_580084, "majorDimension", newJString(majorDimension))
  add(query_580084, "upload_protocol", newJString(uploadProtocol))
  add(query_580084, "fields", newJString(fields))
  add(query_580084, "quotaUser", newJString(quotaUser))
  add(query_580084, "alt", newJString(alt))
  add(query_580084, "valueRenderOption", newJString(valueRenderOption))
  add(query_580084, "oauth_token", newJString(oauthToken))
  add(query_580084, "callback", newJString(callback))
  add(query_580084, "access_token", newJString(accessToken))
  add(query_580084, "uploadType", newJString(uploadType))
  add(query_580084, "key", newJString(key))
  add(query_580084, "$.xgafv", newJString(Xgafv))
  add(query_580084, "dateTimeRenderOption", newJString(dateTimeRenderOption))
  add(path_580083, "spreadsheetId", newJString(spreadsheetId))
  add(query_580084, "prettyPrint", newJBool(prettyPrint))
  add(path_580083, "range", newJString(range))
  result = call_580082.call(path_580083, query_580084, nil, nil, nil)

var sheetsSpreadsheetsValuesGet* = Call_SheetsSpreadsheetsValuesGet_580062(
    name: "sheetsSpreadsheetsValuesGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}",
    validator: validate_SheetsSpreadsheetsValuesGet_580063, base: "/",
    url: url_SheetsSpreadsheetsValuesGet_580064, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesAppend_580111 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsValuesAppend_580113(protocol: Scheme; host: string;
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

proc validate_SheetsSpreadsheetsValuesAppend_580112(path: JsonNode;
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
  var valid_580114 = path.getOrDefault("spreadsheetId")
  valid_580114 = validateParameter(valid_580114, JString, required = true,
                                 default = nil)
  if valid_580114 != nil:
    section.add "spreadsheetId", valid_580114
  var valid_580115 = path.getOrDefault("range")
  valid_580115 = validateParameter(valid_580115, JString, required = true,
                                 default = nil)
  if valid_580115 != nil:
    section.add "range", valid_580115
  result.add "path", section
  ## parameters in `query` object:
  ##   responseValueRenderOption: JString
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   responseDateTimeRenderOption: JString
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: JBool
  ##                          : Determines if the update response should include the values
  ## of the cells that were appended. By default, responses
  ## do not include the updated values.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   insertDataOption: JString
  ##                   : How the input data should be inserted.
  ##   valueInputOption: JString
  ##                   : How the input data should be interpreted.
  section = newJObject()
  var valid_580116 = query.getOrDefault("responseValueRenderOption")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_580116 != nil:
    section.add "responseValueRenderOption", valid_580116
  var valid_580117 = query.getOrDefault("upload_protocol")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "upload_protocol", valid_580117
  var valid_580118 = query.getOrDefault("fields")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "fields", valid_580118
  var valid_580119 = query.getOrDefault("quotaUser")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "quotaUser", valid_580119
  var valid_580120 = query.getOrDefault("alt")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("json"))
  if valid_580120 != nil:
    section.add "alt", valid_580120
  var valid_580121 = query.getOrDefault("responseDateTimeRenderOption")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_580121 != nil:
    section.add "responseDateTimeRenderOption", valid_580121
  var valid_580122 = query.getOrDefault("oauth_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "oauth_token", valid_580122
  var valid_580123 = query.getOrDefault("callback")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "callback", valid_580123
  var valid_580124 = query.getOrDefault("access_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "access_token", valid_580124
  var valid_580125 = query.getOrDefault("uploadType")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "uploadType", valid_580125
  var valid_580126 = query.getOrDefault("includeValuesInResponse")
  valid_580126 = validateParameter(valid_580126, JBool, required = false, default = nil)
  if valid_580126 != nil:
    section.add "includeValuesInResponse", valid_580126
  var valid_580127 = query.getOrDefault("key")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "key", valid_580127
  var valid_580128 = query.getOrDefault("$.xgafv")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = newJString("1"))
  if valid_580128 != nil:
    section.add "$.xgafv", valid_580128
  var valid_580129 = query.getOrDefault("prettyPrint")
  valid_580129 = validateParameter(valid_580129, JBool, required = false,
                                 default = newJBool(true))
  if valid_580129 != nil:
    section.add "prettyPrint", valid_580129
  var valid_580130 = query.getOrDefault("insertDataOption")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = newJString("OVERWRITE"))
  if valid_580130 != nil:
    section.add "insertDataOption", valid_580130
  var valid_580131 = query.getOrDefault("valueInputOption")
  valid_580131 = validateParameter(valid_580131, JString, required = false, default = newJString(
      "INPUT_VALUE_OPTION_UNSPECIFIED"))
  if valid_580131 != nil:
    section.add "valueInputOption", valid_580131
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

proc call*(call_580133: Call_SheetsSpreadsheetsValuesAppend_580111; path: JsonNode;
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
  let valid = call_580133.validator(path, query, header, formData, body)
  let scheme = call_580133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580133.url(scheme.get, call_580133.host, call_580133.base,
                         call_580133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580133, url, valid)

proc call*(call_580134: Call_SheetsSpreadsheetsValuesAppend_580111;
          spreadsheetId: string; range: string;
          responseValueRenderOption: string = "FORMATTED_VALUE";
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json";
          responseDateTimeRenderOption: string = "SERIAL_NUMBER";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; includeValuesInResponse: bool = false;
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; insertDataOption: string = "OVERWRITE";
          valueInputOption: string = "INPUT_VALUE_OPTION_UNSPECIFIED"): Recallable =
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
  ##   responseValueRenderOption: string
  ##                            : Determines how values in the response should be rendered.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   responseDateTimeRenderOption: string
  ##                               : Determines how dates, times, and durations in the response should be
  ## rendered. This is ignored if response_value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   includeValuesInResponse: bool
  ##                          : Determines if the update response should include the values
  ## of the cells that were appended. By default, responses
  ## do not include the updated values.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   insertDataOption: string
  ##                   : How the input data should be inserted.
  ##   valueInputOption: string
  ##                   : How the input data should be interpreted.
  ##   range: string (required)
  ##        : The A1 notation of a range to search for a logical table of data.
  ## Values will be appended after the last row of the table.
  var path_580135 = newJObject()
  var query_580136 = newJObject()
  var body_580137 = newJObject()
  add(query_580136, "responseValueRenderOption",
      newJString(responseValueRenderOption))
  add(query_580136, "upload_protocol", newJString(uploadProtocol))
  add(query_580136, "fields", newJString(fields))
  add(query_580136, "quotaUser", newJString(quotaUser))
  add(query_580136, "alt", newJString(alt))
  add(query_580136, "responseDateTimeRenderOption",
      newJString(responseDateTimeRenderOption))
  add(query_580136, "oauth_token", newJString(oauthToken))
  add(query_580136, "callback", newJString(callback))
  add(query_580136, "access_token", newJString(accessToken))
  add(query_580136, "uploadType", newJString(uploadType))
  add(query_580136, "includeValuesInResponse", newJBool(includeValuesInResponse))
  add(query_580136, "key", newJString(key))
  add(query_580136, "$.xgafv", newJString(Xgafv))
  add(path_580135, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_580137 = body
  add(query_580136, "prettyPrint", newJBool(prettyPrint))
  add(query_580136, "insertDataOption", newJString(insertDataOption))
  add(query_580136, "valueInputOption", newJString(valueInputOption))
  add(path_580135, "range", newJString(range))
  result = call_580134.call(path_580135, query_580136, nil, nil, body_580137)

var sheetsSpreadsheetsValuesAppend* = Call_SheetsSpreadsheetsValuesAppend_580111(
    name: "sheetsSpreadsheetsValuesAppend", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}:append",
    validator: validate_SheetsSpreadsheetsValuesAppend_580112, base: "/",
    url: url_SheetsSpreadsheetsValuesAppend_580113, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesClear_580138 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsValuesClear_580140(protocol: Scheme; host: string;
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

proc validate_SheetsSpreadsheetsValuesClear_580139(path: JsonNode; query: JsonNode;
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
  var valid_580141 = path.getOrDefault("spreadsheetId")
  valid_580141 = validateParameter(valid_580141, JString, required = true,
                                 default = nil)
  if valid_580141 != nil:
    section.add "spreadsheetId", valid_580141
  var valid_580142 = path.getOrDefault("range")
  valid_580142 = validateParameter(valid_580142, JString, required = true,
                                 default = nil)
  if valid_580142 != nil:
    section.add "range", valid_580142
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580143 = query.getOrDefault("upload_protocol")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "upload_protocol", valid_580143
  var valid_580144 = query.getOrDefault("fields")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "fields", valid_580144
  var valid_580145 = query.getOrDefault("quotaUser")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "quotaUser", valid_580145
  var valid_580146 = query.getOrDefault("alt")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("json"))
  if valid_580146 != nil:
    section.add "alt", valid_580146
  var valid_580147 = query.getOrDefault("oauth_token")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "oauth_token", valid_580147
  var valid_580148 = query.getOrDefault("callback")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "callback", valid_580148
  var valid_580149 = query.getOrDefault("access_token")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "access_token", valid_580149
  var valid_580150 = query.getOrDefault("uploadType")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "uploadType", valid_580150
  var valid_580151 = query.getOrDefault("key")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "key", valid_580151
  var valid_580152 = query.getOrDefault("$.xgafv")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = newJString("1"))
  if valid_580152 != nil:
    section.add "$.xgafv", valid_580152
  var valid_580153 = query.getOrDefault("prettyPrint")
  valid_580153 = validateParameter(valid_580153, JBool, required = false,
                                 default = newJBool(true))
  if valid_580153 != nil:
    section.add "prettyPrint", valid_580153
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

proc call*(call_580155: Call_SheetsSpreadsheetsValuesClear_580138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and range.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  let valid = call_580155.validator(path, query, header, formData, body)
  let scheme = call_580155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580155.url(scheme.get, call_580155.host, call_580155.base,
                         call_580155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580155, url, valid)

proc call*(call_580156: Call_SheetsSpreadsheetsValuesClear_580138;
          spreadsheetId: string; range: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesClear
  ## Clears values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and range.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   range: string (required)
  ##        : The A1 notation of the values to clear.
  var path_580157 = newJObject()
  var query_580158 = newJObject()
  var body_580159 = newJObject()
  add(query_580158, "upload_protocol", newJString(uploadProtocol))
  add(query_580158, "fields", newJString(fields))
  add(query_580158, "quotaUser", newJString(quotaUser))
  add(query_580158, "alt", newJString(alt))
  add(query_580158, "oauth_token", newJString(oauthToken))
  add(query_580158, "callback", newJString(callback))
  add(query_580158, "access_token", newJString(accessToken))
  add(query_580158, "uploadType", newJString(uploadType))
  add(query_580158, "key", newJString(key))
  add(query_580158, "$.xgafv", newJString(Xgafv))
  add(path_580157, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_580159 = body
  add(query_580158, "prettyPrint", newJBool(prettyPrint))
  add(path_580157, "range", newJString(range))
  result = call_580156.call(path_580157, query_580158, nil, nil, body_580159)

var sheetsSpreadsheetsValuesClear* = Call_SheetsSpreadsheetsValuesClear_580138(
    name: "sheetsSpreadsheetsValuesClear", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}:clear",
    validator: validate_SheetsSpreadsheetsValuesClear_580139, base: "/",
    url: url_SheetsSpreadsheetsValuesClear_580140, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchClear_580160 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsValuesBatchClear_580162(protocol: Scheme; host: string;
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

proc validate_SheetsSpreadsheetsValuesBatchClear_580161(path: JsonNode;
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
  var valid_580163 = path.getOrDefault("spreadsheetId")
  valid_580163 = validateParameter(valid_580163, JString, required = true,
                                 default = nil)
  if valid_580163 != nil:
    section.add "spreadsheetId", valid_580163
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580164 = query.getOrDefault("upload_protocol")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "upload_protocol", valid_580164
  var valid_580165 = query.getOrDefault("fields")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "fields", valid_580165
  var valid_580166 = query.getOrDefault("quotaUser")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "quotaUser", valid_580166
  var valid_580167 = query.getOrDefault("alt")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = newJString("json"))
  if valid_580167 != nil:
    section.add "alt", valid_580167
  var valid_580168 = query.getOrDefault("oauth_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "oauth_token", valid_580168
  var valid_580169 = query.getOrDefault("callback")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "callback", valid_580169
  var valid_580170 = query.getOrDefault("access_token")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "access_token", valid_580170
  var valid_580171 = query.getOrDefault("uploadType")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "uploadType", valid_580171
  var valid_580172 = query.getOrDefault("key")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "key", valid_580172
  var valid_580173 = query.getOrDefault("$.xgafv")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("1"))
  if valid_580173 != nil:
    section.add "$.xgafv", valid_580173
  var valid_580174 = query.getOrDefault("prettyPrint")
  valid_580174 = validateParameter(valid_580174, JBool, required = false,
                                 default = newJBool(true))
  if valid_580174 != nil:
    section.add "prettyPrint", valid_580174
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

proc call*(call_580176: Call_SheetsSpreadsheetsValuesBatchClear_580160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  let valid = call_580176.validator(path, query, header, formData, body)
  let scheme = call_580176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580176.url(scheme.get, call_580176.host, call_580176.base,
                         call_580176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580176, url, valid)

proc call*(call_580177: Call_SheetsSpreadsheetsValuesBatchClear_580160;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesBatchClear
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580178 = newJObject()
  var query_580179 = newJObject()
  var body_580180 = newJObject()
  add(query_580179, "upload_protocol", newJString(uploadProtocol))
  add(query_580179, "fields", newJString(fields))
  add(query_580179, "quotaUser", newJString(quotaUser))
  add(query_580179, "alt", newJString(alt))
  add(query_580179, "oauth_token", newJString(oauthToken))
  add(query_580179, "callback", newJString(callback))
  add(query_580179, "access_token", newJString(accessToken))
  add(query_580179, "uploadType", newJString(uploadType))
  add(query_580179, "key", newJString(key))
  add(query_580179, "$.xgafv", newJString(Xgafv))
  add(path_580178, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_580180 = body
  add(query_580179, "prettyPrint", newJBool(prettyPrint))
  result = call_580177.call(path_580178, query_580179, nil, nil, body_580180)

var sheetsSpreadsheetsValuesBatchClear* = Call_SheetsSpreadsheetsValuesBatchClear_580160(
    name: "sheetsSpreadsheetsValuesBatchClear", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchClear",
    validator: validate_SheetsSpreadsheetsValuesBatchClear_580161, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchClear_580162, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_580181 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsValuesBatchClearByDataFilter_580183(protocol: Scheme;
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

proc validate_SheetsSpreadsheetsValuesBatchClearByDataFilter_580182(
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
  var valid_580184 = path.getOrDefault("spreadsheetId")
  valid_580184 = validateParameter(valid_580184, JString, required = true,
                                 default = nil)
  if valid_580184 != nil:
    section.add "spreadsheetId", valid_580184
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580185 = query.getOrDefault("upload_protocol")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "upload_protocol", valid_580185
  var valid_580186 = query.getOrDefault("fields")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "fields", valid_580186
  var valid_580187 = query.getOrDefault("quotaUser")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "quotaUser", valid_580187
  var valid_580188 = query.getOrDefault("alt")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = newJString("json"))
  if valid_580188 != nil:
    section.add "alt", valid_580188
  var valid_580189 = query.getOrDefault("oauth_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "oauth_token", valid_580189
  var valid_580190 = query.getOrDefault("callback")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "callback", valid_580190
  var valid_580191 = query.getOrDefault("access_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "access_token", valid_580191
  var valid_580192 = query.getOrDefault("uploadType")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "uploadType", valid_580192
  var valid_580193 = query.getOrDefault("key")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "key", valid_580193
  var valid_580194 = query.getOrDefault("$.xgafv")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = newJString("1"))
  if valid_580194 != nil:
    section.add "$.xgafv", valid_580194
  var valid_580195 = query.getOrDefault("prettyPrint")
  valid_580195 = validateParameter(valid_580195, JBool, required = false,
                                 default = newJBool(true))
  if valid_580195 != nil:
    section.add "prettyPrint", valid_580195
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

proc call*(call_580197: Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_580181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters. Ranges matching any of the specified data
  ## filters will be cleared.  Only values are cleared -- all other properties
  ## of the cell (such as formatting, data validation, etc..) are kept.
  ## 
  let valid = call_580197.validator(path, query, header, formData, body)
  let scheme = call_580197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580197.url(scheme.get, call_580197.host, call_580197.base,
                         call_580197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580197, url, valid)

proc call*(call_580198: Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_580181;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesBatchClearByDataFilter
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters. Ranges matching any of the specified data
  ## filters will be cleared.  Only values are cleared -- all other properties
  ## of the cell (such as formatting, data validation, etc..) are kept.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580199 = newJObject()
  var query_580200 = newJObject()
  var body_580201 = newJObject()
  add(query_580200, "upload_protocol", newJString(uploadProtocol))
  add(query_580200, "fields", newJString(fields))
  add(query_580200, "quotaUser", newJString(quotaUser))
  add(query_580200, "alt", newJString(alt))
  add(query_580200, "oauth_token", newJString(oauthToken))
  add(query_580200, "callback", newJString(callback))
  add(query_580200, "access_token", newJString(accessToken))
  add(query_580200, "uploadType", newJString(uploadType))
  add(query_580200, "key", newJString(key))
  add(query_580200, "$.xgafv", newJString(Xgafv))
  add(path_580199, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_580201 = body
  add(query_580200, "prettyPrint", newJBool(prettyPrint))
  result = call_580198.call(path_580199, query_580200, nil, nil, body_580201)

var sheetsSpreadsheetsValuesBatchClearByDataFilter* = Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_580181(
    name: "sheetsSpreadsheetsValuesBatchClearByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchClearByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchClearByDataFilter_580182,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchClearByDataFilter_580183,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchGet_580202 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsValuesBatchGet_580204(protocol: Scheme; host: string;
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

proc validate_SheetsSpreadsheetsValuesBatchGet_580203(path: JsonNode;
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
  var valid_580205 = path.getOrDefault("spreadsheetId")
  valid_580205 = validateParameter(valid_580205, JString, required = true,
                                 default = nil)
  if valid_580205 != nil:
    section.add "spreadsheetId", valid_580205
  result.add "path", section
  ## parameters in `query` object:
  ##   majorDimension: JString
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   valueRenderOption: JString
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   ranges: JArray
  ##         : The A1 notation of the values to retrieve.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   dateTimeRenderOption: JString
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580206 = query.getOrDefault("majorDimension")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("DIMENSION_UNSPECIFIED"))
  if valid_580206 != nil:
    section.add "majorDimension", valid_580206
  var valid_580207 = query.getOrDefault("upload_protocol")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "upload_protocol", valid_580207
  var valid_580208 = query.getOrDefault("fields")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "fields", valid_580208
  var valid_580209 = query.getOrDefault("quotaUser")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "quotaUser", valid_580209
  var valid_580210 = query.getOrDefault("alt")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = newJString("json"))
  if valid_580210 != nil:
    section.add "alt", valid_580210
  var valid_580211 = query.getOrDefault("valueRenderOption")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_580211 != nil:
    section.add "valueRenderOption", valid_580211
  var valid_580212 = query.getOrDefault("oauth_token")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "oauth_token", valid_580212
  var valid_580213 = query.getOrDefault("callback")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "callback", valid_580213
  var valid_580214 = query.getOrDefault("access_token")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "access_token", valid_580214
  var valid_580215 = query.getOrDefault("uploadType")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "uploadType", valid_580215
  var valid_580216 = query.getOrDefault("ranges")
  valid_580216 = validateParameter(valid_580216, JArray, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "ranges", valid_580216
  var valid_580217 = query.getOrDefault("key")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "key", valid_580217
  var valid_580218 = query.getOrDefault("$.xgafv")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = newJString("1"))
  if valid_580218 != nil:
    section.add "$.xgafv", valid_580218
  var valid_580219 = query.getOrDefault("dateTimeRenderOption")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_580219 != nil:
    section.add "dateTimeRenderOption", valid_580219
  var valid_580220 = query.getOrDefault("prettyPrint")
  valid_580220 = validateParameter(valid_580220, JBool, required = false,
                                 default = newJBool(true))
  if valid_580220 != nil:
    section.add "prettyPrint", valid_580220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580221: Call_SheetsSpreadsheetsValuesBatchGet_580202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## 
  let valid = call_580221.validator(path, query, header, formData, body)
  let scheme = call_580221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580221.url(scheme.get, call_580221.host, call_580221.base,
                         call_580221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580221, url, valid)

proc call*(call_580222: Call_SheetsSpreadsheetsValuesBatchGet_580202;
          spreadsheetId: string; majorDimension: string = "DIMENSION_UNSPECIFIED";
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; valueRenderOption: string = "FORMATTED_VALUE";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; ranges: JsonNode = nil; key: string = "";
          Xgafv: string = "1"; dateTimeRenderOption: string = "SERIAL_NUMBER";
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesBatchGet
  ## Returns one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ##   majorDimension: string
  ##                 : The major dimension that results should use.
  ## 
  ## For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`,
  ## then requesting `range=A1:B2,majorDimension=ROWS` will return
  ## `[[1,2],[3,4]]`,
  ## whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return
  ## `[[1,3],[2,4]]`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   valueRenderOption: string
  ##                    : How values should be represented in the output.
  ## The default render option is ValueRenderOption.FORMATTED_VALUE.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   ranges: JArray
  ##         : The A1 notation of the values to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   dateTimeRenderOption: string
  ##                       : How dates, times, and durations should be represented in the output.
  ## This is ignored if value_render_option is
  ## FORMATTED_VALUE.
  ## The default dateTime render option is [DateTimeRenderOption.SERIAL_NUMBER].
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580223 = newJObject()
  var query_580224 = newJObject()
  add(query_580224, "majorDimension", newJString(majorDimension))
  add(query_580224, "upload_protocol", newJString(uploadProtocol))
  add(query_580224, "fields", newJString(fields))
  add(query_580224, "quotaUser", newJString(quotaUser))
  add(query_580224, "alt", newJString(alt))
  add(query_580224, "valueRenderOption", newJString(valueRenderOption))
  add(query_580224, "oauth_token", newJString(oauthToken))
  add(query_580224, "callback", newJString(callback))
  add(query_580224, "access_token", newJString(accessToken))
  add(query_580224, "uploadType", newJString(uploadType))
  if ranges != nil:
    query_580224.add "ranges", ranges
  add(query_580224, "key", newJString(key))
  add(query_580224, "$.xgafv", newJString(Xgafv))
  add(query_580224, "dateTimeRenderOption", newJString(dateTimeRenderOption))
  add(path_580223, "spreadsheetId", newJString(spreadsheetId))
  add(query_580224, "prettyPrint", newJBool(prettyPrint))
  result = call_580222.call(path_580223, query_580224, nil, nil, nil)

var sheetsSpreadsheetsValuesBatchGet* = Call_SheetsSpreadsheetsValuesBatchGet_580202(
    name: "sheetsSpreadsheetsValuesBatchGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchGet",
    validator: validate_SheetsSpreadsheetsValuesBatchGet_580203, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchGet_580204, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_580225 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsValuesBatchGetByDataFilter_580227(protocol: Scheme;
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

proc validate_SheetsSpreadsheetsValuesBatchGetByDataFilter_580226(path: JsonNode;
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
  var valid_580228 = path.getOrDefault("spreadsheetId")
  valid_580228 = validateParameter(valid_580228, JString, required = true,
                                 default = nil)
  if valid_580228 != nil:
    section.add "spreadsheetId", valid_580228
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580229 = query.getOrDefault("upload_protocol")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "upload_protocol", valid_580229
  var valid_580230 = query.getOrDefault("fields")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "fields", valid_580230
  var valid_580231 = query.getOrDefault("quotaUser")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "quotaUser", valid_580231
  var valid_580232 = query.getOrDefault("alt")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = newJString("json"))
  if valid_580232 != nil:
    section.add "alt", valid_580232
  var valid_580233 = query.getOrDefault("oauth_token")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "oauth_token", valid_580233
  var valid_580234 = query.getOrDefault("callback")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "callback", valid_580234
  var valid_580235 = query.getOrDefault("access_token")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "access_token", valid_580235
  var valid_580236 = query.getOrDefault("uploadType")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "uploadType", valid_580236
  var valid_580237 = query.getOrDefault("key")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "key", valid_580237
  var valid_580238 = query.getOrDefault("$.xgafv")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("1"))
  if valid_580238 != nil:
    section.add "$.xgafv", valid_580238
  var valid_580239 = query.getOrDefault("prettyPrint")
  valid_580239 = validateParameter(valid_580239, JBool, required = false,
                                 default = newJBool(true))
  if valid_580239 != nil:
    section.add "prettyPrint", valid_580239
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

proc call*(call_580241: Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_580225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns one or more ranges of values that match the specified data filters.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters.  Ranges that match any of the data filters in
  ## the request will be returned.
  ## 
  let valid = call_580241.validator(path, query, header, formData, body)
  let scheme = call_580241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580241.url(scheme.get, call_580241.host, call_580241.base,
                         call_580241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580241, url, valid)

proc call*(call_580242: Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_580225;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesBatchGetByDataFilter
  ## Returns one or more ranges of values that match the specified data filters.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters.  Ranges that match any of the data filters in
  ## the request will be returned.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to retrieve data from.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580243 = newJObject()
  var query_580244 = newJObject()
  var body_580245 = newJObject()
  add(query_580244, "upload_protocol", newJString(uploadProtocol))
  add(query_580244, "fields", newJString(fields))
  add(query_580244, "quotaUser", newJString(quotaUser))
  add(query_580244, "alt", newJString(alt))
  add(query_580244, "oauth_token", newJString(oauthToken))
  add(query_580244, "callback", newJString(callback))
  add(query_580244, "access_token", newJString(accessToken))
  add(query_580244, "uploadType", newJString(uploadType))
  add(query_580244, "key", newJString(key))
  add(query_580244, "$.xgafv", newJString(Xgafv))
  add(path_580243, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_580245 = body
  add(query_580244, "prettyPrint", newJBool(prettyPrint))
  result = call_580242.call(path_580243, query_580244, nil, nil, body_580245)

var sheetsSpreadsheetsValuesBatchGetByDataFilter* = Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_580225(
    name: "sheetsSpreadsheetsValuesBatchGetByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchGetByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchGetByDataFilter_580226,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchGetByDataFilter_580227,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchUpdate_580246 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsValuesBatchUpdate_580248(protocol: Scheme; host: string;
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

proc validate_SheetsSpreadsheetsValuesBatchUpdate_580247(path: JsonNode;
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
  var valid_580249 = path.getOrDefault("spreadsheetId")
  valid_580249 = validateParameter(valid_580249, JString, required = true,
                                 default = nil)
  if valid_580249 != nil:
    section.add "spreadsheetId", valid_580249
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580250 = query.getOrDefault("upload_protocol")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "upload_protocol", valid_580250
  var valid_580251 = query.getOrDefault("fields")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "fields", valid_580251
  var valid_580252 = query.getOrDefault("quotaUser")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "quotaUser", valid_580252
  var valid_580253 = query.getOrDefault("alt")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = newJString("json"))
  if valid_580253 != nil:
    section.add "alt", valid_580253
  var valid_580254 = query.getOrDefault("oauth_token")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "oauth_token", valid_580254
  var valid_580255 = query.getOrDefault("callback")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "callback", valid_580255
  var valid_580256 = query.getOrDefault("access_token")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "access_token", valid_580256
  var valid_580257 = query.getOrDefault("uploadType")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "uploadType", valid_580257
  var valid_580258 = query.getOrDefault("key")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "key", valid_580258
  var valid_580259 = query.getOrDefault("$.xgafv")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = newJString("1"))
  if valid_580259 != nil:
    section.add "$.xgafv", valid_580259
  var valid_580260 = query.getOrDefault("prettyPrint")
  valid_580260 = validateParameter(valid_580260, JBool, required = false,
                                 default = newJBool(true))
  if valid_580260 != nil:
    section.add "prettyPrint", valid_580260
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

proc call*(call_580262: Call_SheetsSpreadsheetsValuesBatchUpdate_580246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## ValueRanges.
  ## 
  let valid = call_580262.validator(path, query, header, formData, body)
  let scheme = call_580262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580262.url(scheme.get, call_580262.host, call_580262.base,
                         call_580262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580262, url, valid)

proc call*(call_580263: Call_SheetsSpreadsheetsValuesBatchUpdate_580246;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesBatchUpdate
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## ValueRanges.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580264 = newJObject()
  var query_580265 = newJObject()
  var body_580266 = newJObject()
  add(query_580265, "upload_protocol", newJString(uploadProtocol))
  add(query_580265, "fields", newJString(fields))
  add(query_580265, "quotaUser", newJString(quotaUser))
  add(query_580265, "alt", newJString(alt))
  add(query_580265, "oauth_token", newJString(oauthToken))
  add(query_580265, "callback", newJString(callback))
  add(query_580265, "access_token", newJString(accessToken))
  add(query_580265, "uploadType", newJString(uploadType))
  add(query_580265, "key", newJString(key))
  add(query_580265, "$.xgafv", newJString(Xgafv))
  add(path_580264, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_580266 = body
  add(query_580265, "prettyPrint", newJBool(prettyPrint))
  result = call_580263.call(path_580264, query_580265, nil, nil, body_580266)

var sheetsSpreadsheetsValuesBatchUpdate* = Call_SheetsSpreadsheetsValuesBatchUpdate_580246(
    name: "sheetsSpreadsheetsValuesBatchUpdate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchUpdate",
    validator: validate_SheetsSpreadsheetsValuesBatchUpdate_580247, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchUpdate_580248, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580267 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580269(protocol: Scheme;
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

proc validate_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580268(
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
  var valid_580270 = path.getOrDefault("spreadsheetId")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "spreadsheetId", valid_580270
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580271 = query.getOrDefault("upload_protocol")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "upload_protocol", valid_580271
  var valid_580272 = query.getOrDefault("fields")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "fields", valid_580272
  var valid_580273 = query.getOrDefault("quotaUser")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "quotaUser", valid_580273
  var valid_580274 = query.getOrDefault("alt")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = newJString("json"))
  if valid_580274 != nil:
    section.add "alt", valid_580274
  var valid_580275 = query.getOrDefault("oauth_token")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "oauth_token", valid_580275
  var valid_580276 = query.getOrDefault("callback")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "callback", valid_580276
  var valid_580277 = query.getOrDefault("access_token")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "access_token", valid_580277
  var valid_580278 = query.getOrDefault("uploadType")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "uploadType", valid_580278
  var valid_580279 = query.getOrDefault("key")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "key", valid_580279
  var valid_580280 = query.getOrDefault("$.xgafv")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = newJString("1"))
  if valid_580280 != nil:
    section.add "$.xgafv", valid_580280
  var valid_580281 = query.getOrDefault("prettyPrint")
  valid_580281 = validateParameter(valid_580281, JBool, required = false,
                                 default = newJBool(true))
  if valid_580281 != nil:
    section.add "prettyPrint", valid_580281
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

proc call*(call_580283: Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## DataFilterValueRanges.
  ## 
  let valid = call_580283.validator(path, query, header, formData, body)
  let scheme = call_580283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580283.url(scheme.get, call_580283.host, call_580283.base,
                         call_580283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580283, url, valid)

proc call*(call_580284: Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580267;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sheetsSpreadsheetsValuesBatchUpdateByDataFilter
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## DataFilterValueRanges.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The ID of the spreadsheet to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580285 = newJObject()
  var query_580286 = newJObject()
  var body_580287 = newJObject()
  add(query_580286, "upload_protocol", newJString(uploadProtocol))
  add(query_580286, "fields", newJString(fields))
  add(query_580286, "quotaUser", newJString(quotaUser))
  add(query_580286, "alt", newJString(alt))
  add(query_580286, "oauth_token", newJString(oauthToken))
  add(query_580286, "callback", newJString(callback))
  add(query_580286, "access_token", newJString(accessToken))
  add(query_580286, "uploadType", newJString(uploadType))
  add(query_580286, "key", newJString(key))
  add(query_580286, "$.xgafv", newJString(Xgafv))
  add(path_580285, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_580287 = body
  add(query_580286, "prettyPrint", newJBool(prettyPrint))
  result = call_580284.call(path_580285, query_580286, nil, nil, body_580287)

var sheetsSpreadsheetsValuesBatchUpdateByDataFilter* = Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580267(
    name: "sheetsSpreadsheetsValuesBatchUpdateByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchUpdateByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580268,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_580269,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsBatchUpdate_580288 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsBatchUpdate_580290(protocol: Scheme; host: string;
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

proc validate_SheetsSpreadsheetsBatchUpdate_580289(path: JsonNode; query: JsonNode;
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
  var valid_580291 = path.getOrDefault("spreadsheetId")
  valid_580291 = validateParameter(valid_580291, JString, required = true,
                                 default = nil)
  if valid_580291 != nil:
    section.add "spreadsheetId", valid_580291
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580292 = query.getOrDefault("upload_protocol")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "upload_protocol", valid_580292
  var valid_580293 = query.getOrDefault("fields")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "fields", valid_580293
  var valid_580294 = query.getOrDefault("quotaUser")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "quotaUser", valid_580294
  var valid_580295 = query.getOrDefault("alt")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = newJString("json"))
  if valid_580295 != nil:
    section.add "alt", valid_580295
  var valid_580296 = query.getOrDefault("oauth_token")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "oauth_token", valid_580296
  var valid_580297 = query.getOrDefault("callback")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "callback", valid_580297
  var valid_580298 = query.getOrDefault("access_token")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "access_token", valid_580298
  var valid_580299 = query.getOrDefault("uploadType")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "uploadType", valid_580299
  var valid_580300 = query.getOrDefault("key")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "key", valid_580300
  var valid_580301 = query.getOrDefault("$.xgafv")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = newJString("1"))
  if valid_580301 != nil:
    section.add "$.xgafv", valid_580301
  var valid_580302 = query.getOrDefault("prettyPrint")
  valid_580302 = validateParameter(valid_580302, JBool, required = false,
                                 default = newJBool(true))
  if valid_580302 != nil:
    section.add "prettyPrint", valid_580302
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

proc call*(call_580304: Call_SheetsSpreadsheetsBatchUpdate_580288; path: JsonNode;
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
  let valid = call_580304.validator(path, query, header, formData, body)
  let scheme = call_580304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580304.url(scheme.get, call_580304.host, call_580304.base,
                         call_580304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580304, url, valid)

proc call*(call_580305: Call_SheetsSpreadsheetsBatchUpdate_580288;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The spreadsheet to apply the updates to.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580306 = newJObject()
  var query_580307 = newJObject()
  var body_580308 = newJObject()
  add(query_580307, "upload_protocol", newJString(uploadProtocol))
  add(query_580307, "fields", newJString(fields))
  add(query_580307, "quotaUser", newJString(quotaUser))
  add(query_580307, "alt", newJString(alt))
  add(query_580307, "oauth_token", newJString(oauthToken))
  add(query_580307, "callback", newJString(callback))
  add(query_580307, "access_token", newJString(accessToken))
  add(query_580307, "uploadType", newJString(uploadType))
  add(query_580307, "key", newJString(key))
  add(query_580307, "$.xgafv", newJString(Xgafv))
  add(path_580306, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_580308 = body
  add(query_580307, "prettyPrint", newJBool(prettyPrint))
  result = call_580305.call(path_580306, query_580307, nil, nil, body_580308)

var sheetsSpreadsheetsBatchUpdate* = Call_SheetsSpreadsheetsBatchUpdate_580288(
    name: "sheetsSpreadsheetsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}:batchUpdate",
    validator: validate_SheetsSpreadsheetsBatchUpdate_580289, base: "/",
    url: url_SheetsSpreadsheetsBatchUpdate_580290, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsGetByDataFilter_580309 = ref object of OpenApiRestCall_579421
proc url_SheetsSpreadsheetsGetByDataFilter_580311(protocol: Scheme; host: string;
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

proc validate_SheetsSpreadsheetsGetByDataFilter_580310(path: JsonNode;
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
  var valid_580312 = path.getOrDefault("spreadsheetId")
  valid_580312 = validateParameter(valid_580312, JString, required = true,
                                 default = nil)
  if valid_580312 != nil:
    section.add "spreadsheetId", valid_580312
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580313 = query.getOrDefault("upload_protocol")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "upload_protocol", valid_580313
  var valid_580314 = query.getOrDefault("fields")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "fields", valid_580314
  var valid_580315 = query.getOrDefault("quotaUser")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "quotaUser", valid_580315
  var valid_580316 = query.getOrDefault("alt")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = newJString("json"))
  if valid_580316 != nil:
    section.add "alt", valid_580316
  var valid_580317 = query.getOrDefault("oauth_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "oauth_token", valid_580317
  var valid_580318 = query.getOrDefault("callback")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "callback", valid_580318
  var valid_580319 = query.getOrDefault("access_token")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "access_token", valid_580319
  var valid_580320 = query.getOrDefault("uploadType")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "uploadType", valid_580320
  var valid_580321 = query.getOrDefault("key")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "key", valid_580321
  var valid_580322 = query.getOrDefault("$.xgafv")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = newJString("1"))
  if valid_580322 != nil:
    section.add "$.xgafv", valid_580322
  var valid_580323 = query.getOrDefault("prettyPrint")
  valid_580323 = validateParameter(valid_580323, JBool, required = false,
                                 default = newJBool(true))
  if valid_580323 != nil:
    section.add "prettyPrint", valid_580323
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

proc call*(call_580325: Call_SheetsSpreadsheetsGetByDataFilter_580309;
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
  let valid = call_580325.validator(path, query, header, formData, body)
  let scheme = call_580325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580325.url(scheme.get, call_580325.host, call_580325.base,
                         call_580325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580325, url, valid)

proc call*(call_580326: Call_SheetsSpreadsheetsGetByDataFilter_580309;
          spreadsheetId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   spreadsheetId: string (required)
  ##                : The spreadsheet to request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580327 = newJObject()
  var query_580328 = newJObject()
  var body_580329 = newJObject()
  add(query_580328, "upload_protocol", newJString(uploadProtocol))
  add(query_580328, "fields", newJString(fields))
  add(query_580328, "quotaUser", newJString(quotaUser))
  add(query_580328, "alt", newJString(alt))
  add(query_580328, "oauth_token", newJString(oauthToken))
  add(query_580328, "callback", newJString(callback))
  add(query_580328, "access_token", newJString(accessToken))
  add(query_580328, "uploadType", newJString(uploadType))
  add(query_580328, "key", newJString(key))
  add(query_580328, "$.xgafv", newJString(Xgafv))
  add(path_580327, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_580329 = body
  add(query_580328, "prettyPrint", newJBool(prettyPrint))
  result = call_580326.call(path_580327, query_580328, nil, nil, body_580329)

var sheetsSpreadsheetsGetByDataFilter* = Call_SheetsSpreadsheetsGetByDataFilter_580309(
    name: "sheetsSpreadsheetsGetByDataFilter", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}:getByDataFilter",
    validator: validate_SheetsSpreadsheetsGetByDataFilter_580310, base: "/",
    url: url_SheetsSpreadsheetsGetByDataFilter_580311, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
