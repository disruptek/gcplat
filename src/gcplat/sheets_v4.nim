
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SheetsSpreadsheetsCreate_593690 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsCreate_593692(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SheetsSpreadsheetsCreate_593691(path: JsonNode; query: JsonNode;
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
  var valid_593804 = query.getOrDefault("upload_protocol")
  valid_593804 = validateParameter(valid_593804, JString, required = false,
                                 default = nil)
  if valid_593804 != nil:
    section.add "upload_protocol", valid_593804
  var valid_593805 = query.getOrDefault("fields")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = nil)
  if valid_593805 != nil:
    section.add "fields", valid_593805
  var valid_593806 = query.getOrDefault("quotaUser")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "quotaUser", valid_593806
  var valid_593820 = query.getOrDefault("alt")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = newJString("json"))
  if valid_593820 != nil:
    section.add "alt", valid_593820
  var valid_593821 = query.getOrDefault("oauth_token")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "oauth_token", valid_593821
  var valid_593822 = query.getOrDefault("callback")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "callback", valid_593822
  var valid_593823 = query.getOrDefault("access_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "access_token", valid_593823
  var valid_593824 = query.getOrDefault("uploadType")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "uploadType", valid_593824
  var valid_593825 = query.getOrDefault("key")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "key", valid_593825
  var valid_593826 = query.getOrDefault("$.xgafv")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = newJString("1"))
  if valid_593826 != nil:
    section.add "$.xgafv", valid_593826
  var valid_593827 = query.getOrDefault("prettyPrint")
  valid_593827 = validateParameter(valid_593827, JBool, required = false,
                                 default = newJBool(true))
  if valid_593827 != nil:
    section.add "prettyPrint", valid_593827
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

proc call*(call_593851: Call_SheetsSpreadsheetsCreate_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a spreadsheet, returning the newly created spreadsheet.
  ## 
  let valid = call_593851.validator(path, query, header, formData, body)
  let scheme = call_593851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593851.url(scheme.get, call_593851.host, call_593851.base,
                         call_593851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593851, url, valid)

proc call*(call_593922: Call_SheetsSpreadsheetsCreate_593690;
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
  var query_593923 = newJObject()
  var body_593925 = newJObject()
  add(query_593923, "upload_protocol", newJString(uploadProtocol))
  add(query_593923, "fields", newJString(fields))
  add(query_593923, "quotaUser", newJString(quotaUser))
  add(query_593923, "alt", newJString(alt))
  add(query_593923, "oauth_token", newJString(oauthToken))
  add(query_593923, "callback", newJString(callback))
  add(query_593923, "access_token", newJString(accessToken))
  add(query_593923, "uploadType", newJString(uploadType))
  add(query_593923, "key", newJString(key))
  add(query_593923, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593925 = body
  add(query_593923, "prettyPrint", newJBool(prettyPrint))
  result = call_593922.call(nil, query_593923, nil, nil, body_593925)

var sheetsSpreadsheetsCreate* = Call_SheetsSpreadsheetsCreate_593690(
    name: "sheetsSpreadsheetsCreate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com", route: "/v4/spreadsheets",
    validator: validate_SheetsSpreadsheetsCreate_593691, base: "/",
    url: url_SheetsSpreadsheetsCreate_593692, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsGet_593964 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsGet_593966(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "spreadsheetId" in path, "`spreadsheetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v4/spreadsheets/"),
               (kind: VariableSegment, value: "spreadsheetId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SheetsSpreadsheetsGet_593965(path: JsonNode; query: JsonNode;
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
  var valid_593981 = path.getOrDefault("spreadsheetId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "spreadsheetId", valid_593981
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
  var valid_593982 = query.getOrDefault("upload_protocol")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "upload_protocol", valid_593982
  var valid_593983 = query.getOrDefault("fields")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "fields", valid_593983
  var valid_593984 = query.getOrDefault("quotaUser")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "quotaUser", valid_593984
  var valid_593985 = query.getOrDefault("alt")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("json"))
  if valid_593985 != nil:
    section.add "alt", valid_593985
  var valid_593986 = query.getOrDefault("includeGridData")
  valid_593986 = validateParameter(valid_593986, JBool, required = false, default = nil)
  if valid_593986 != nil:
    section.add "includeGridData", valid_593986
  var valid_593987 = query.getOrDefault("oauth_token")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "oauth_token", valid_593987
  var valid_593988 = query.getOrDefault("callback")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "callback", valid_593988
  var valid_593989 = query.getOrDefault("access_token")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "access_token", valid_593989
  var valid_593990 = query.getOrDefault("uploadType")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "uploadType", valid_593990
  var valid_593991 = query.getOrDefault("ranges")
  valid_593991 = validateParameter(valid_593991, JArray, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "ranges", valid_593991
  var valid_593992 = query.getOrDefault("key")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "key", valid_593992
  var valid_593993 = query.getOrDefault("$.xgafv")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = newJString("1"))
  if valid_593993 != nil:
    section.add "$.xgafv", valid_593993
  var valid_593994 = query.getOrDefault("prettyPrint")
  valid_593994 = validateParameter(valid_593994, JBool, required = false,
                                 default = newJBool(true))
  if valid_593994 != nil:
    section.add "prettyPrint", valid_593994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593995: Call_SheetsSpreadsheetsGet_593964; path: JsonNode;
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
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_SheetsSpreadsheetsGet_593964; spreadsheetId: string;
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
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  add(query_593998, "upload_protocol", newJString(uploadProtocol))
  add(query_593998, "fields", newJString(fields))
  add(query_593998, "quotaUser", newJString(quotaUser))
  add(query_593998, "alt", newJString(alt))
  add(query_593998, "includeGridData", newJBool(includeGridData))
  add(query_593998, "oauth_token", newJString(oauthToken))
  add(query_593998, "callback", newJString(callback))
  add(query_593998, "access_token", newJString(accessToken))
  add(query_593998, "uploadType", newJString(uploadType))
  if ranges != nil:
    query_593998.add "ranges", ranges
  add(query_593998, "key", newJString(key))
  add(query_593998, "$.xgafv", newJString(Xgafv))
  add(path_593997, "spreadsheetId", newJString(spreadsheetId))
  add(query_593998, "prettyPrint", newJBool(prettyPrint))
  result = call_593996.call(path_593997, query_593998, nil, nil, nil)

var sheetsSpreadsheetsGet* = Call_SheetsSpreadsheetsGet_593964(
    name: "sheetsSpreadsheetsGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com", route: "/v4/spreadsheets/{spreadsheetId}",
    validator: validate_SheetsSpreadsheetsGet_593965, base: "/",
    url: url_SheetsSpreadsheetsGet_593966, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsDeveloperMetadataGet_593999 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsDeveloperMetadataGet_594001(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsDeveloperMetadataGet_594000(path: JsonNode;
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
  var valid_594002 = path.getOrDefault("metadataId")
  valid_594002 = validateParameter(valid_594002, JInt, required = true, default = nil)
  if valid_594002 != nil:
    section.add "metadataId", valid_594002
  var valid_594003 = path.getOrDefault("spreadsheetId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "spreadsheetId", valid_594003
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
  var valid_594004 = query.getOrDefault("upload_protocol")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "upload_protocol", valid_594004
  var valid_594005 = query.getOrDefault("fields")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "fields", valid_594005
  var valid_594006 = query.getOrDefault("quotaUser")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "quotaUser", valid_594006
  var valid_594007 = query.getOrDefault("alt")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = newJString("json"))
  if valid_594007 != nil:
    section.add "alt", valid_594007
  var valid_594008 = query.getOrDefault("oauth_token")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "oauth_token", valid_594008
  var valid_594009 = query.getOrDefault("callback")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "callback", valid_594009
  var valid_594010 = query.getOrDefault("access_token")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "access_token", valid_594010
  var valid_594011 = query.getOrDefault("uploadType")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "uploadType", valid_594011
  var valid_594012 = query.getOrDefault("key")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "key", valid_594012
  var valid_594013 = query.getOrDefault("$.xgafv")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = newJString("1"))
  if valid_594013 != nil:
    section.add "$.xgafv", valid_594013
  var valid_594014 = query.getOrDefault("prettyPrint")
  valid_594014 = validateParameter(valid_594014, JBool, required = false,
                                 default = newJBool(true))
  if valid_594014 != nil:
    section.add "prettyPrint", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_SheetsSpreadsheetsDeveloperMetadataGet_593999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the developer metadata with the specified ID.
  ## The caller must specify the spreadsheet ID and the developer metadata's
  ## unique metadataId.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_SheetsSpreadsheetsDeveloperMetadataGet_593999;
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
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(query_594018, "upload_protocol", newJString(uploadProtocol))
  add(query_594018, "fields", newJString(fields))
  add(query_594018, "quotaUser", newJString(quotaUser))
  add(query_594018, "alt", newJString(alt))
  add(path_594017, "metadataId", newJInt(metadataId))
  add(query_594018, "oauth_token", newJString(oauthToken))
  add(query_594018, "callback", newJString(callback))
  add(query_594018, "access_token", newJString(accessToken))
  add(query_594018, "uploadType", newJString(uploadType))
  add(query_594018, "key", newJString(key))
  add(query_594018, "$.xgafv", newJString(Xgafv))
  add(path_594017, "spreadsheetId", newJString(spreadsheetId))
  add(query_594018, "prettyPrint", newJBool(prettyPrint))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var sheetsSpreadsheetsDeveloperMetadataGet* = Call_SheetsSpreadsheetsDeveloperMetadataGet_593999(
    name: "sheetsSpreadsheetsDeveloperMetadataGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/developerMetadata/{metadataId}",
    validator: validate_SheetsSpreadsheetsDeveloperMetadataGet_594000, base: "/",
    url: url_SheetsSpreadsheetsDeveloperMetadataGet_594001,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsDeveloperMetadataSearch_594019 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsDeveloperMetadataSearch_594021(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsDeveloperMetadataSearch_594020(path: JsonNode;
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
  var valid_594022 = path.getOrDefault("spreadsheetId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "spreadsheetId", valid_594022
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
  var valid_594023 = query.getOrDefault("upload_protocol")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "upload_protocol", valid_594023
  var valid_594024 = query.getOrDefault("fields")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "fields", valid_594024
  var valid_594025 = query.getOrDefault("quotaUser")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "quotaUser", valid_594025
  var valid_594026 = query.getOrDefault("alt")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = newJString("json"))
  if valid_594026 != nil:
    section.add "alt", valid_594026
  var valid_594027 = query.getOrDefault("oauth_token")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "oauth_token", valid_594027
  var valid_594028 = query.getOrDefault("callback")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "callback", valid_594028
  var valid_594029 = query.getOrDefault("access_token")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "access_token", valid_594029
  var valid_594030 = query.getOrDefault("uploadType")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "uploadType", valid_594030
  var valid_594031 = query.getOrDefault("key")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "key", valid_594031
  var valid_594032 = query.getOrDefault("$.xgafv")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = newJString("1"))
  if valid_594032 != nil:
    section.add "$.xgafv", valid_594032
  var valid_594033 = query.getOrDefault("prettyPrint")
  valid_594033 = validateParameter(valid_594033, JBool, required = false,
                                 default = newJBool(true))
  if valid_594033 != nil:
    section.add "prettyPrint", valid_594033
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

proc call*(call_594035: Call_SheetsSpreadsheetsDeveloperMetadataSearch_594019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns all developer metadata matching the specified DataFilter.
  ## If the provided DataFilter represents a DeveloperMetadataLookup object,
  ## this will return all DeveloperMetadata entries selected by it. If the
  ## DataFilter represents a location in a spreadsheet, this will return all
  ## developer metadata associated with locations intersecting that region.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_SheetsSpreadsheetsDeveloperMetadataSearch_594019;
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
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  var body_594039 = newJObject()
  add(query_594038, "upload_protocol", newJString(uploadProtocol))
  add(query_594038, "fields", newJString(fields))
  add(query_594038, "quotaUser", newJString(quotaUser))
  add(query_594038, "alt", newJString(alt))
  add(query_594038, "oauth_token", newJString(oauthToken))
  add(query_594038, "callback", newJString(callback))
  add(query_594038, "access_token", newJString(accessToken))
  add(query_594038, "uploadType", newJString(uploadType))
  add(query_594038, "key", newJString(key))
  add(query_594038, "$.xgafv", newJString(Xgafv))
  add(path_594037, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_594039 = body
  add(query_594038, "prettyPrint", newJBool(prettyPrint))
  result = call_594036.call(path_594037, query_594038, nil, nil, body_594039)

var sheetsSpreadsheetsDeveloperMetadataSearch* = Call_SheetsSpreadsheetsDeveloperMetadataSearch_594019(
    name: "sheetsSpreadsheetsDeveloperMetadataSearch", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/developerMetadata:search",
    validator: validate_SheetsSpreadsheetsDeveloperMetadataSearch_594020,
    base: "/", url: url_SheetsSpreadsheetsDeveloperMetadataSearch_594021,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsSheetsCopyTo_594040 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsSheetsCopyTo_594042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsSheetsCopyTo_594041(path: JsonNode;
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
  var valid_594043 = path.getOrDefault("sheetId")
  valid_594043 = validateParameter(valid_594043, JInt, required = true, default = nil)
  if valid_594043 != nil:
    section.add "sheetId", valid_594043
  var valid_594044 = path.getOrDefault("spreadsheetId")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "spreadsheetId", valid_594044
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
  var valid_594045 = query.getOrDefault("upload_protocol")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "upload_protocol", valid_594045
  var valid_594046 = query.getOrDefault("fields")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "fields", valid_594046
  var valid_594047 = query.getOrDefault("quotaUser")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "quotaUser", valid_594047
  var valid_594048 = query.getOrDefault("alt")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = newJString("json"))
  if valid_594048 != nil:
    section.add "alt", valid_594048
  var valid_594049 = query.getOrDefault("oauth_token")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "oauth_token", valid_594049
  var valid_594050 = query.getOrDefault("callback")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "callback", valid_594050
  var valid_594051 = query.getOrDefault("access_token")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "access_token", valid_594051
  var valid_594052 = query.getOrDefault("uploadType")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "uploadType", valid_594052
  var valid_594053 = query.getOrDefault("key")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "key", valid_594053
  var valid_594054 = query.getOrDefault("$.xgafv")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = newJString("1"))
  if valid_594054 != nil:
    section.add "$.xgafv", valid_594054
  var valid_594055 = query.getOrDefault("prettyPrint")
  valid_594055 = validateParameter(valid_594055, JBool, required = false,
                                 default = newJBool(true))
  if valid_594055 != nil:
    section.add "prettyPrint", valid_594055
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

proc call*(call_594057: Call_SheetsSpreadsheetsSheetsCopyTo_594040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a single sheet from a spreadsheet to another spreadsheet.
  ## Returns the properties of the newly created sheet.
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_SheetsSpreadsheetsSheetsCopyTo_594040; sheetId: int;
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
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  var body_594061 = newJObject()
  add(query_594060, "upload_protocol", newJString(uploadProtocol))
  add(query_594060, "fields", newJString(fields))
  add(query_594060, "quotaUser", newJString(quotaUser))
  add(query_594060, "alt", newJString(alt))
  add(query_594060, "oauth_token", newJString(oauthToken))
  add(query_594060, "callback", newJString(callback))
  add(query_594060, "access_token", newJString(accessToken))
  add(query_594060, "uploadType", newJString(uploadType))
  add(query_594060, "key", newJString(key))
  add(query_594060, "$.xgafv", newJString(Xgafv))
  add(path_594059, "sheetId", newJInt(sheetId))
  add(path_594059, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_594061 = body
  add(query_594060, "prettyPrint", newJBool(prettyPrint))
  result = call_594058.call(path_594059, query_594060, nil, nil, body_594061)

var sheetsSpreadsheetsSheetsCopyTo* = Call_SheetsSpreadsheetsSheetsCopyTo_594040(
    name: "sheetsSpreadsheetsSheetsCopyTo", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/sheets/{sheetId}:copyTo",
    validator: validate_SheetsSpreadsheetsSheetsCopyTo_594041, base: "/",
    url: url_SheetsSpreadsheetsSheetsCopyTo_594042, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesUpdate_594085 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsValuesUpdate_594087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsValuesUpdate_594086(path: JsonNode;
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
  var valid_594088 = path.getOrDefault("spreadsheetId")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "spreadsheetId", valid_594088
  var valid_594089 = path.getOrDefault("range")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "range", valid_594089
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
  var valid_594090 = query.getOrDefault("responseValueRenderOption")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_594090 != nil:
    section.add "responseValueRenderOption", valid_594090
  var valid_594091 = query.getOrDefault("upload_protocol")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "upload_protocol", valid_594091
  var valid_594092 = query.getOrDefault("fields")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "fields", valid_594092
  var valid_594093 = query.getOrDefault("quotaUser")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "quotaUser", valid_594093
  var valid_594094 = query.getOrDefault("alt")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("json"))
  if valid_594094 != nil:
    section.add "alt", valid_594094
  var valid_594095 = query.getOrDefault("responseDateTimeRenderOption")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_594095 != nil:
    section.add "responseDateTimeRenderOption", valid_594095
  var valid_594096 = query.getOrDefault("oauth_token")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "oauth_token", valid_594096
  var valid_594097 = query.getOrDefault("callback")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "callback", valid_594097
  var valid_594098 = query.getOrDefault("access_token")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "access_token", valid_594098
  var valid_594099 = query.getOrDefault("uploadType")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "uploadType", valid_594099
  var valid_594100 = query.getOrDefault("includeValuesInResponse")
  valid_594100 = validateParameter(valid_594100, JBool, required = false, default = nil)
  if valid_594100 != nil:
    section.add "includeValuesInResponse", valid_594100
  var valid_594101 = query.getOrDefault("key")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "key", valid_594101
  var valid_594102 = query.getOrDefault("$.xgafv")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = newJString("1"))
  if valid_594102 != nil:
    section.add "$.xgafv", valid_594102
  var valid_594103 = query.getOrDefault("prettyPrint")
  valid_594103 = validateParameter(valid_594103, JBool, required = false,
                                 default = newJBool(true))
  if valid_594103 != nil:
    section.add "prettyPrint", valid_594103
  var valid_594104 = query.getOrDefault("valueInputOption")
  valid_594104 = validateParameter(valid_594104, JString, required = false, default = newJString(
      "INPUT_VALUE_OPTION_UNSPECIFIED"))
  if valid_594104 != nil:
    section.add "valueInputOption", valid_594104
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

proc call*(call_594106: Call_SheetsSpreadsheetsValuesUpdate_594085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets values in a range of a spreadsheet.
  ## The caller must specify the spreadsheet ID, range, and
  ## a valueInputOption.
  ## 
  let valid = call_594106.validator(path, query, header, formData, body)
  let scheme = call_594106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594106.url(scheme.get, call_594106.host, call_594106.base,
                         call_594106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594106, url, valid)

proc call*(call_594107: Call_SheetsSpreadsheetsValuesUpdate_594085;
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
  var path_594108 = newJObject()
  var query_594109 = newJObject()
  var body_594110 = newJObject()
  add(query_594109, "responseValueRenderOption",
      newJString(responseValueRenderOption))
  add(query_594109, "upload_protocol", newJString(uploadProtocol))
  add(query_594109, "fields", newJString(fields))
  add(query_594109, "quotaUser", newJString(quotaUser))
  add(query_594109, "alt", newJString(alt))
  add(query_594109, "responseDateTimeRenderOption",
      newJString(responseDateTimeRenderOption))
  add(query_594109, "oauth_token", newJString(oauthToken))
  add(query_594109, "callback", newJString(callback))
  add(query_594109, "access_token", newJString(accessToken))
  add(query_594109, "uploadType", newJString(uploadType))
  add(query_594109, "includeValuesInResponse", newJBool(includeValuesInResponse))
  add(query_594109, "key", newJString(key))
  add(query_594109, "$.xgafv", newJString(Xgafv))
  add(path_594108, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_594110 = body
  add(query_594109, "prettyPrint", newJBool(prettyPrint))
  add(query_594109, "valueInputOption", newJString(valueInputOption))
  add(path_594108, "range", newJString(range))
  result = call_594107.call(path_594108, query_594109, nil, nil, body_594110)

var sheetsSpreadsheetsValuesUpdate* = Call_SheetsSpreadsheetsValuesUpdate_594085(
    name: "sheetsSpreadsheetsValuesUpdate", meth: HttpMethod.HttpPut,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}",
    validator: validate_SheetsSpreadsheetsValuesUpdate_594086, base: "/",
    url: url_SheetsSpreadsheetsValuesUpdate_594087, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesGet_594062 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsValuesGet_594064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsValuesGet_594063(path: JsonNode; query: JsonNode;
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
  var valid_594065 = path.getOrDefault("spreadsheetId")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "spreadsheetId", valid_594065
  var valid_594066 = path.getOrDefault("range")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "range", valid_594066
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
  var valid_594067 = query.getOrDefault("majorDimension")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = newJString("DIMENSION_UNSPECIFIED"))
  if valid_594067 != nil:
    section.add "majorDimension", valid_594067
  var valid_594068 = query.getOrDefault("upload_protocol")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "upload_protocol", valid_594068
  var valid_594069 = query.getOrDefault("fields")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "fields", valid_594069
  var valid_594070 = query.getOrDefault("quotaUser")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "quotaUser", valid_594070
  var valid_594071 = query.getOrDefault("alt")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = newJString("json"))
  if valid_594071 != nil:
    section.add "alt", valid_594071
  var valid_594072 = query.getOrDefault("valueRenderOption")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_594072 != nil:
    section.add "valueRenderOption", valid_594072
  var valid_594073 = query.getOrDefault("oauth_token")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "oauth_token", valid_594073
  var valid_594074 = query.getOrDefault("callback")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "callback", valid_594074
  var valid_594075 = query.getOrDefault("access_token")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "access_token", valid_594075
  var valid_594076 = query.getOrDefault("uploadType")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "uploadType", valid_594076
  var valid_594077 = query.getOrDefault("key")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "key", valid_594077
  var valid_594078 = query.getOrDefault("$.xgafv")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = newJString("1"))
  if valid_594078 != nil:
    section.add "$.xgafv", valid_594078
  var valid_594079 = query.getOrDefault("dateTimeRenderOption")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_594079 != nil:
    section.add "dateTimeRenderOption", valid_594079
  var valid_594080 = query.getOrDefault("prettyPrint")
  valid_594080 = validateParameter(valid_594080, JBool, required = false,
                                 default = newJBool(true))
  if valid_594080 != nil:
    section.add "prettyPrint", valid_594080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_SheetsSpreadsheetsValuesGet_594062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a range of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and a range.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_SheetsSpreadsheetsValuesGet_594062;
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
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  add(query_594084, "majorDimension", newJString(majorDimension))
  add(query_594084, "upload_protocol", newJString(uploadProtocol))
  add(query_594084, "fields", newJString(fields))
  add(query_594084, "quotaUser", newJString(quotaUser))
  add(query_594084, "alt", newJString(alt))
  add(query_594084, "valueRenderOption", newJString(valueRenderOption))
  add(query_594084, "oauth_token", newJString(oauthToken))
  add(query_594084, "callback", newJString(callback))
  add(query_594084, "access_token", newJString(accessToken))
  add(query_594084, "uploadType", newJString(uploadType))
  add(query_594084, "key", newJString(key))
  add(query_594084, "$.xgafv", newJString(Xgafv))
  add(query_594084, "dateTimeRenderOption", newJString(dateTimeRenderOption))
  add(path_594083, "spreadsheetId", newJString(spreadsheetId))
  add(query_594084, "prettyPrint", newJBool(prettyPrint))
  add(path_594083, "range", newJString(range))
  result = call_594082.call(path_594083, query_594084, nil, nil, nil)

var sheetsSpreadsheetsValuesGet* = Call_SheetsSpreadsheetsValuesGet_594062(
    name: "sheetsSpreadsheetsValuesGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}",
    validator: validate_SheetsSpreadsheetsValuesGet_594063, base: "/",
    url: url_SheetsSpreadsheetsValuesGet_594064, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesAppend_594111 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsValuesAppend_594113(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsValuesAppend_594112(path: JsonNode;
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
  var valid_594114 = path.getOrDefault("spreadsheetId")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "spreadsheetId", valid_594114
  var valid_594115 = path.getOrDefault("range")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "range", valid_594115
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
  var valid_594116 = query.getOrDefault("responseValueRenderOption")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_594116 != nil:
    section.add "responseValueRenderOption", valid_594116
  var valid_594117 = query.getOrDefault("upload_protocol")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "upload_protocol", valid_594117
  var valid_594118 = query.getOrDefault("fields")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "fields", valid_594118
  var valid_594119 = query.getOrDefault("quotaUser")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "quotaUser", valid_594119
  var valid_594120 = query.getOrDefault("alt")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = newJString("json"))
  if valid_594120 != nil:
    section.add "alt", valid_594120
  var valid_594121 = query.getOrDefault("responseDateTimeRenderOption")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_594121 != nil:
    section.add "responseDateTimeRenderOption", valid_594121
  var valid_594122 = query.getOrDefault("oauth_token")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "oauth_token", valid_594122
  var valid_594123 = query.getOrDefault("callback")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "callback", valid_594123
  var valid_594124 = query.getOrDefault("access_token")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "access_token", valid_594124
  var valid_594125 = query.getOrDefault("uploadType")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "uploadType", valid_594125
  var valid_594126 = query.getOrDefault("includeValuesInResponse")
  valid_594126 = validateParameter(valid_594126, JBool, required = false, default = nil)
  if valid_594126 != nil:
    section.add "includeValuesInResponse", valid_594126
  var valid_594127 = query.getOrDefault("key")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "key", valid_594127
  var valid_594128 = query.getOrDefault("$.xgafv")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = newJString("1"))
  if valid_594128 != nil:
    section.add "$.xgafv", valid_594128
  var valid_594129 = query.getOrDefault("prettyPrint")
  valid_594129 = validateParameter(valid_594129, JBool, required = false,
                                 default = newJBool(true))
  if valid_594129 != nil:
    section.add "prettyPrint", valid_594129
  var valid_594130 = query.getOrDefault("insertDataOption")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = newJString("OVERWRITE"))
  if valid_594130 != nil:
    section.add "insertDataOption", valid_594130
  var valid_594131 = query.getOrDefault("valueInputOption")
  valid_594131 = validateParameter(valid_594131, JString, required = false, default = newJString(
      "INPUT_VALUE_OPTION_UNSPECIFIED"))
  if valid_594131 != nil:
    section.add "valueInputOption", valid_594131
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

proc call*(call_594133: Call_SheetsSpreadsheetsValuesAppend_594111; path: JsonNode;
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
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_SheetsSpreadsheetsValuesAppend_594111;
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
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  var body_594137 = newJObject()
  add(query_594136, "responseValueRenderOption",
      newJString(responseValueRenderOption))
  add(query_594136, "upload_protocol", newJString(uploadProtocol))
  add(query_594136, "fields", newJString(fields))
  add(query_594136, "quotaUser", newJString(quotaUser))
  add(query_594136, "alt", newJString(alt))
  add(query_594136, "responseDateTimeRenderOption",
      newJString(responseDateTimeRenderOption))
  add(query_594136, "oauth_token", newJString(oauthToken))
  add(query_594136, "callback", newJString(callback))
  add(query_594136, "access_token", newJString(accessToken))
  add(query_594136, "uploadType", newJString(uploadType))
  add(query_594136, "includeValuesInResponse", newJBool(includeValuesInResponse))
  add(query_594136, "key", newJString(key))
  add(query_594136, "$.xgafv", newJString(Xgafv))
  add(path_594135, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_594137 = body
  add(query_594136, "prettyPrint", newJBool(prettyPrint))
  add(query_594136, "insertDataOption", newJString(insertDataOption))
  add(query_594136, "valueInputOption", newJString(valueInputOption))
  add(path_594135, "range", newJString(range))
  result = call_594134.call(path_594135, query_594136, nil, nil, body_594137)

var sheetsSpreadsheetsValuesAppend* = Call_SheetsSpreadsheetsValuesAppend_594111(
    name: "sheetsSpreadsheetsValuesAppend", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}:append",
    validator: validate_SheetsSpreadsheetsValuesAppend_594112, base: "/",
    url: url_SheetsSpreadsheetsValuesAppend_594113, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesClear_594138 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsValuesClear_594140(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsValuesClear_594139(path: JsonNode; query: JsonNode;
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
  var valid_594141 = path.getOrDefault("spreadsheetId")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "spreadsheetId", valid_594141
  var valid_594142 = path.getOrDefault("range")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "range", valid_594142
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
  var valid_594143 = query.getOrDefault("upload_protocol")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "upload_protocol", valid_594143
  var valid_594144 = query.getOrDefault("fields")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "fields", valid_594144
  var valid_594145 = query.getOrDefault("quotaUser")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "quotaUser", valid_594145
  var valid_594146 = query.getOrDefault("alt")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = newJString("json"))
  if valid_594146 != nil:
    section.add "alt", valid_594146
  var valid_594147 = query.getOrDefault("oauth_token")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "oauth_token", valid_594147
  var valid_594148 = query.getOrDefault("callback")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "callback", valid_594148
  var valid_594149 = query.getOrDefault("access_token")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "access_token", valid_594149
  var valid_594150 = query.getOrDefault("uploadType")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "uploadType", valid_594150
  var valid_594151 = query.getOrDefault("key")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "key", valid_594151
  var valid_594152 = query.getOrDefault("$.xgafv")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = newJString("1"))
  if valid_594152 != nil:
    section.add "$.xgafv", valid_594152
  var valid_594153 = query.getOrDefault("prettyPrint")
  valid_594153 = validateParameter(valid_594153, JBool, required = false,
                                 default = newJBool(true))
  if valid_594153 != nil:
    section.add "prettyPrint", valid_594153
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

proc call*(call_594155: Call_SheetsSpreadsheetsValuesClear_594138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and range.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_SheetsSpreadsheetsValuesClear_594138;
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
  var path_594157 = newJObject()
  var query_594158 = newJObject()
  var body_594159 = newJObject()
  add(query_594158, "upload_protocol", newJString(uploadProtocol))
  add(query_594158, "fields", newJString(fields))
  add(query_594158, "quotaUser", newJString(quotaUser))
  add(query_594158, "alt", newJString(alt))
  add(query_594158, "oauth_token", newJString(oauthToken))
  add(query_594158, "callback", newJString(callback))
  add(query_594158, "access_token", newJString(accessToken))
  add(query_594158, "uploadType", newJString(uploadType))
  add(query_594158, "key", newJString(key))
  add(query_594158, "$.xgafv", newJString(Xgafv))
  add(path_594157, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_594159 = body
  add(query_594158, "prettyPrint", newJBool(prettyPrint))
  add(path_594157, "range", newJString(range))
  result = call_594156.call(path_594157, query_594158, nil, nil, body_594159)

var sheetsSpreadsheetsValuesClear* = Call_SheetsSpreadsheetsValuesClear_594138(
    name: "sheetsSpreadsheetsValuesClear", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values/{range}:clear",
    validator: validate_SheetsSpreadsheetsValuesClear_594139, base: "/",
    url: url_SheetsSpreadsheetsValuesClear_594140, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchClear_594160 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsValuesBatchClear_594162(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsValuesBatchClear_594161(path: JsonNode;
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
  var valid_594163 = path.getOrDefault("spreadsheetId")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "spreadsheetId", valid_594163
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
  var valid_594164 = query.getOrDefault("upload_protocol")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "upload_protocol", valid_594164
  var valid_594165 = query.getOrDefault("fields")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "fields", valid_594165
  var valid_594166 = query.getOrDefault("quotaUser")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "quotaUser", valid_594166
  var valid_594167 = query.getOrDefault("alt")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = newJString("json"))
  if valid_594167 != nil:
    section.add "alt", valid_594167
  var valid_594168 = query.getOrDefault("oauth_token")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "oauth_token", valid_594168
  var valid_594169 = query.getOrDefault("callback")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "callback", valid_594169
  var valid_594170 = query.getOrDefault("access_token")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "access_token", valid_594170
  var valid_594171 = query.getOrDefault("uploadType")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "uploadType", valid_594171
  var valid_594172 = query.getOrDefault("key")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "key", valid_594172
  var valid_594173 = query.getOrDefault("$.xgafv")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = newJString("1"))
  if valid_594173 != nil:
    section.add "$.xgafv", valid_594173
  var valid_594174 = query.getOrDefault("prettyPrint")
  valid_594174 = validateParameter(valid_594174, JBool, required = false,
                                 default = newJBool(true))
  if valid_594174 != nil:
    section.add "prettyPrint", valid_594174
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

proc call*(call_594176: Call_SheetsSpreadsheetsValuesBatchClear_594160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## Only values are cleared -- all other properties of the cell (such as
  ## formatting, data validation, etc..) are kept.
  ## 
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_SheetsSpreadsheetsValuesBatchClear_594160;
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
  var path_594178 = newJObject()
  var query_594179 = newJObject()
  var body_594180 = newJObject()
  add(query_594179, "upload_protocol", newJString(uploadProtocol))
  add(query_594179, "fields", newJString(fields))
  add(query_594179, "quotaUser", newJString(quotaUser))
  add(query_594179, "alt", newJString(alt))
  add(query_594179, "oauth_token", newJString(oauthToken))
  add(query_594179, "callback", newJString(callback))
  add(query_594179, "access_token", newJString(accessToken))
  add(query_594179, "uploadType", newJString(uploadType))
  add(query_594179, "key", newJString(key))
  add(query_594179, "$.xgafv", newJString(Xgafv))
  add(path_594178, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_594180 = body
  add(query_594179, "prettyPrint", newJBool(prettyPrint))
  result = call_594177.call(path_594178, query_594179, nil, nil, body_594180)

var sheetsSpreadsheetsValuesBatchClear* = Call_SheetsSpreadsheetsValuesBatchClear_594160(
    name: "sheetsSpreadsheetsValuesBatchClear", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchClear",
    validator: validate_SheetsSpreadsheetsValuesBatchClear_594161, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchClear_594162, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_594181 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsValuesBatchClearByDataFilter_594183(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsValuesBatchClearByDataFilter_594182(
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
  var valid_594184 = path.getOrDefault("spreadsheetId")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "spreadsheetId", valid_594184
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
  var valid_594185 = query.getOrDefault("upload_protocol")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "upload_protocol", valid_594185
  var valid_594186 = query.getOrDefault("fields")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "fields", valid_594186
  var valid_594187 = query.getOrDefault("quotaUser")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "quotaUser", valid_594187
  var valid_594188 = query.getOrDefault("alt")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = newJString("json"))
  if valid_594188 != nil:
    section.add "alt", valid_594188
  var valid_594189 = query.getOrDefault("oauth_token")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "oauth_token", valid_594189
  var valid_594190 = query.getOrDefault("callback")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "callback", valid_594190
  var valid_594191 = query.getOrDefault("access_token")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "access_token", valid_594191
  var valid_594192 = query.getOrDefault("uploadType")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "uploadType", valid_594192
  var valid_594193 = query.getOrDefault("key")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "key", valid_594193
  var valid_594194 = query.getOrDefault("$.xgafv")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = newJString("1"))
  if valid_594194 != nil:
    section.add "$.xgafv", valid_594194
  var valid_594195 = query.getOrDefault("prettyPrint")
  valid_594195 = validateParameter(valid_594195, JBool, required = false,
                                 default = newJBool(true))
  if valid_594195 != nil:
    section.add "prettyPrint", valid_594195
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

proc call*(call_594197: Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_594181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters. Ranges matching any of the specified data
  ## filters will be cleared.  Only values are cleared -- all other properties
  ## of the cell (such as formatting, data validation, etc..) are kept.
  ## 
  let valid = call_594197.validator(path, query, header, formData, body)
  let scheme = call_594197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594197.url(scheme.get, call_594197.host, call_594197.base,
                         call_594197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594197, url, valid)

proc call*(call_594198: Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_594181;
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
  var path_594199 = newJObject()
  var query_594200 = newJObject()
  var body_594201 = newJObject()
  add(query_594200, "upload_protocol", newJString(uploadProtocol))
  add(query_594200, "fields", newJString(fields))
  add(query_594200, "quotaUser", newJString(quotaUser))
  add(query_594200, "alt", newJString(alt))
  add(query_594200, "oauth_token", newJString(oauthToken))
  add(query_594200, "callback", newJString(callback))
  add(query_594200, "access_token", newJString(accessToken))
  add(query_594200, "uploadType", newJString(uploadType))
  add(query_594200, "key", newJString(key))
  add(query_594200, "$.xgafv", newJString(Xgafv))
  add(path_594199, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_594201 = body
  add(query_594200, "prettyPrint", newJBool(prettyPrint))
  result = call_594198.call(path_594199, query_594200, nil, nil, body_594201)

var sheetsSpreadsheetsValuesBatchClearByDataFilter* = Call_SheetsSpreadsheetsValuesBatchClearByDataFilter_594181(
    name: "sheetsSpreadsheetsValuesBatchClearByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchClearByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchClearByDataFilter_594182,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchClearByDataFilter_594183,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchGet_594202 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsValuesBatchGet_594204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsValuesBatchGet_594203(path: JsonNode;
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
  var valid_594205 = path.getOrDefault("spreadsheetId")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "spreadsheetId", valid_594205
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
  var valid_594206 = query.getOrDefault("majorDimension")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = newJString("DIMENSION_UNSPECIFIED"))
  if valid_594206 != nil:
    section.add "majorDimension", valid_594206
  var valid_594207 = query.getOrDefault("upload_protocol")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "upload_protocol", valid_594207
  var valid_594208 = query.getOrDefault("fields")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "fields", valid_594208
  var valid_594209 = query.getOrDefault("quotaUser")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "quotaUser", valid_594209
  var valid_594210 = query.getOrDefault("alt")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = newJString("json"))
  if valid_594210 != nil:
    section.add "alt", valid_594210
  var valid_594211 = query.getOrDefault("valueRenderOption")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = newJString("FORMATTED_VALUE"))
  if valid_594211 != nil:
    section.add "valueRenderOption", valid_594211
  var valid_594212 = query.getOrDefault("oauth_token")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "oauth_token", valid_594212
  var valid_594213 = query.getOrDefault("callback")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "callback", valid_594213
  var valid_594214 = query.getOrDefault("access_token")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "access_token", valid_594214
  var valid_594215 = query.getOrDefault("uploadType")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "uploadType", valid_594215
  var valid_594216 = query.getOrDefault("ranges")
  valid_594216 = validateParameter(valid_594216, JArray, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "ranges", valid_594216
  var valid_594217 = query.getOrDefault("key")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "key", valid_594217
  var valid_594218 = query.getOrDefault("$.xgafv")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = newJString("1"))
  if valid_594218 != nil:
    section.add "$.xgafv", valid_594218
  var valid_594219 = query.getOrDefault("dateTimeRenderOption")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = newJString("SERIAL_NUMBER"))
  if valid_594219 != nil:
    section.add "dateTimeRenderOption", valid_594219
  var valid_594220 = query.getOrDefault("prettyPrint")
  valid_594220 = validateParameter(valid_594220, JBool, required = false,
                                 default = newJBool(true))
  if valid_594220 != nil:
    section.add "prettyPrint", valid_594220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594221: Call_SheetsSpreadsheetsValuesBatchGet_594202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns one or more ranges of values from a spreadsheet.
  ## The caller must specify the spreadsheet ID and one or more ranges.
  ## 
  let valid = call_594221.validator(path, query, header, formData, body)
  let scheme = call_594221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594221.url(scheme.get, call_594221.host, call_594221.base,
                         call_594221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594221, url, valid)

proc call*(call_594222: Call_SheetsSpreadsheetsValuesBatchGet_594202;
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
  var path_594223 = newJObject()
  var query_594224 = newJObject()
  add(query_594224, "majorDimension", newJString(majorDimension))
  add(query_594224, "upload_protocol", newJString(uploadProtocol))
  add(query_594224, "fields", newJString(fields))
  add(query_594224, "quotaUser", newJString(quotaUser))
  add(query_594224, "alt", newJString(alt))
  add(query_594224, "valueRenderOption", newJString(valueRenderOption))
  add(query_594224, "oauth_token", newJString(oauthToken))
  add(query_594224, "callback", newJString(callback))
  add(query_594224, "access_token", newJString(accessToken))
  add(query_594224, "uploadType", newJString(uploadType))
  if ranges != nil:
    query_594224.add "ranges", ranges
  add(query_594224, "key", newJString(key))
  add(query_594224, "$.xgafv", newJString(Xgafv))
  add(query_594224, "dateTimeRenderOption", newJString(dateTimeRenderOption))
  add(path_594223, "spreadsheetId", newJString(spreadsheetId))
  add(query_594224, "prettyPrint", newJBool(prettyPrint))
  result = call_594222.call(path_594223, query_594224, nil, nil, nil)

var sheetsSpreadsheetsValuesBatchGet* = Call_SheetsSpreadsheetsValuesBatchGet_594202(
    name: "sheetsSpreadsheetsValuesBatchGet", meth: HttpMethod.HttpGet,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchGet",
    validator: validate_SheetsSpreadsheetsValuesBatchGet_594203, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchGet_594204, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_594225 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsValuesBatchGetByDataFilter_594227(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsValuesBatchGetByDataFilter_594226(path: JsonNode;
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
  var valid_594228 = path.getOrDefault("spreadsheetId")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "spreadsheetId", valid_594228
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
  var valid_594229 = query.getOrDefault("upload_protocol")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "upload_protocol", valid_594229
  var valid_594230 = query.getOrDefault("fields")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "fields", valid_594230
  var valid_594231 = query.getOrDefault("quotaUser")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "quotaUser", valid_594231
  var valid_594232 = query.getOrDefault("alt")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = newJString("json"))
  if valid_594232 != nil:
    section.add "alt", valid_594232
  var valid_594233 = query.getOrDefault("oauth_token")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "oauth_token", valid_594233
  var valid_594234 = query.getOrDefault("callback")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "callback", valid_594234
  var valid_594235 = query.getOrDefault("access_token")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "access_token", valid_594235
  var valid_594236 = query.getOrDefault("uploadType")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "uploadType", valid_594236
  var valid_594237 = query.getOrDefault("key")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "key", valid_594237
  var valid_594238 = query.getOrDefault("$.xgafv")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = newJString("1"))
  if valid_594238 != nil:
    section.add "$.xgafv", valid_594238
  var valid_594239 = query.getOrDefault("prettyPrint")
  valid_594239 = validateParameter(valid_594239, JBool, required = false,
                                 default = newJBool(true))
  if valid_594239 != nil:
    section.add "prettyPrint", valid_594239
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

proc call*(call_594241: Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_594225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns one or more ranges of values that match the specified data filters.
  ## The caller must specify the spreadsheet ID and one or more
  ## DataFilters.  Ranges that match any of the data filters in
  ## the request will be returned.
  ## 
  let valid = call_594241.validator(path, query, header, formData, body)
  let scheme = call_594241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594241.url(scheme.get, call_594241.host, call_594241.base,
                         call_594241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594241, url, valid)

proc call*(call_594242: Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_594225;
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
  var path_594243 = newJObject()
  var query_594244 = newJObject()
  var body_594245 = newJObject()
  add(query_594244, "upload_protocol", newJString(uploadProtocol))
  add(query_594244, "fields", newJString(fields))
  add(query_594244, "quotaUser", newJString(quotaUser))
  add(query_594244, "alt", newJString(alt))
  add(query_594244, "oauth_token", newJString(oauthToken))
  add(query_594244, "callback", newJString(callback))
  add(query_594244, "access_token", newJString(accessToken))
  add(query_594244, "uploadType", newJString(uploadType))
  add(query_594244, "key", newJString(key))
  add(query_594244, "$.xgafv", newJString(Xgafv))
  add(path_594243, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_594245 = body
  add(query_594244, "prettyPrint", newJBool(prettyPrint))
  result = call_594242.call(path_594243, query_594244, nil, nil, body_594245)

var sheetsSpreadsheetsValuesBatchGetByDataFilter* = Call_SheetsSpreadsheetsValuesBatchGetByDataFilter_594225(
    name: "sheetsSpreadsheetsValuesBatchGetByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchGetByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchGetByDataFilter_594226,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchGetByDataFilter_594227,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchUpdate_594246 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsValuesBatchUpdate_594248(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsValuesBatchUpdate_594247(path: JsonNode;
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
  var valid_594249 = path.getOrDefault("spreadsheetId")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "spreadsheetId", valid_594249
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
  var valid_594250 = query.getOrDefault("upload_protocol")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "upload_protocol", valid_594250
  var valid_594251 = query.getOrDefault("fields")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "fields", valid_594251
  var valid_594252 = query.getOrDefault("quotaUser")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "quotaUser", valid_594252
  var valid_594253 = query.getOrDefault("alt")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = newJString("json"))
  if valid_594253 != nil:
    section.add "alt", valid_594253
  var valid_594254 = query.getOrDefault("oauth_token")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "oauth_token", valid_594254
  var valid_594255 = query.getOrDefault("callback")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "callback", valid_594255
  var valid_594256 = query.getOrDefault("access_token")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "access_token", valid_594256
  var valid_594257 = query.getOrDefault("uploadType")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "uploadType", valid_594257
  var valid_594258 = query.getOrDefault("key")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "key", valid_594258
  var valid_594259 = query.getOrDefault("$.xgafv")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = newJString("1"))
  if valid_594259 != nil:
    section.add "$.xgafv", valid_594259
  var valid_594260 = query.getOrDefault("prettyPrint")
  valid_594260 = validateParameter(valid_594260, JBool, required = false,
                                 default = newJBool(true))
  if valid_594260 != nil:
    section.add "prettyPrint", valid_594260
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

proc call*(call_594262: Call_SheetsSpreadsheetsValuesBatchUpdate_594246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## ValueRanges.
  ## 
  let valid = call_594262.validator(path, query, header, formData, body)
  let scheme = call_594262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594262.url(scheme.get, call_594262.host, call_594262.base,
                         call_594262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594262, url, valid)

proc call*(call_594263: Call_SheetsSpreadsheetsValuesBatchUpdate_594246;
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
  var path_594264 = newJObject()
  var query_594265 = newJObject()
  var body_594266 = newJObject()
  add(query_594265, "upload_protocol", newJString(uploadProtocol))
  add(query_594265, "fields", newJString(fields))
  add(query_594265, "quotaUser", newJString(quotaUser))
  add(query_594265, "alt", newJString(alt))
  add(query_594265, "oauth_token", newJString(oauthToken))
  add(query_594265, "callback", newJString(callback))
  add(query_594265, "access_token", newJString(accessToken))
  add(query_594265, "uploadType", newJString(uploadType))
  add(query_594265, "key", newJString(key))
  add(query_594265, "$.xgafv", newJString(Xgafv))
  add(path_594264, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_594266 = body
  add(query_594265, "prettyPrint", newJBool(prettyPrint))
  result = call_594263.call(path_594264, query_594265, nil, nil, body_594266)

var sheetsSpreadsheetsValuesBatchUpdate* = Call_SheetsSpreadsheetsValuesBatchUpdate_594246(
    name: "sheetsSpreadsheetsValuesBatchUpdate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchUpdate",
    validator: validate_SheetsSpreadsheetsValuesBatchUpdate_594247, base: "/",
    url: url_SheetsSpreadsheetsValuesBatchUpdate_594248, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_594267 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_594269(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_594268(
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
  var valid_594270 = path.getOrDefault("spreadsheetId")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "spreadsheetId", valid_594270
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
  var valid_594271 = query.getOrDefault("upload_protocol")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "upload_protocol", valid_594271
  var valid_594272 = query.getOrDefault("fields")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "fields", valid_594272
  var valid_594273 = query.getOrDefault("quotaUser")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "quotaUser", valid_594273
  var valid_594274 = query.getOrDefault("alt")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = newJString("json"))
  if valid_594274 != nil:
    section.add "alt", valid_594274
  var valid_594275 = query.getOrDefault("oauth_token")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "oauth_token", valid_594275
  var valid_594276 = query.getOrDefault("callback")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "callback", valid_594276
  var valid_594277 = query.getOrDefault("access_token")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "access_token", valid_594277
  var valid_594278 = query.getOrDefault("uploadType")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "uploadType", valid_594278
  var valid_594279 = query.getOrDefault("key")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "key", valid_594279
  var valid_594280 = query.getOrDefault("$.xgafv")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = newJString("1"))
  if valid_594280 != nil:
    section.add "$.xgafv", valid_594280
  var valid_594281 = query.getOrDefault("prettyPrint")
  valid_594281 = validateParameter(valid_594281, JBool, required = false,
                                 default = newJBool(true))
  if valid_594281 != nil:
    section.add "prettyPrint", valid_594281
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

proc call*(call_594283: Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_594267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets values in one or more ranges of a spreadsheet.
  ## The caller must specify the spreadsheet ID,
  ## a valueInputOption, and one or more
  ## DataFilterValueRanges.
  ## 
  let valid = call_594283.validator(path, query, header, formData, body)
  let scheme = call_594283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594283.url(scheme.get, call_594283.host, call_594283.base,
                         call_594283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594283, url, valid)

proc call*(call_594284: Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_594267;
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
  var path_594285 = newJObject()
  var query_594286 = newJObject()
  var body_594287 = newJObject()
  add(query_594286, "upload_protocol", newJString(uploadProtocol))
  add(query_594286, "fields", newJString(fields))
  add(query_594286, "quotaUser", newJString(quotaUser))
  add(query_594286, "alt", newJString(alt))
  add(query_594286, "oauth_token", newJString(oauthToken))
  add(query_594286, "callback", newJString(callback))
  add(query_594286, "access_token", newJString(accessToken))
  add(query_594286, "uploadType", newJString(uploadType))
  add(query_594286, "key", newJString(key))
  add(query_594286, "$.xgafv", newJString(Xgafv))
  add(path_594285, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_594287 = body
  add(query_594286, "prettyPrint", newJBool(prettyPrint))
  result = call_594284.call(path_594285, query_594286, nil, nil, body_594287)

var sheetsSpreadsheetsValuesBatchUpdateByDataFilter* = Call_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_594267(
    name: "sheetsSpreadsheetsValuesBatchUpdateByDataFilter",
    meth: HttpMethod.HttpPost, host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}/values:batchUpdateByDataFilter",
    validator: validate_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_594268,
    base: "/", url: url_SheetsSpreadsheetsValuesBatchUpdateByDataFilter_594269,
    schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsBatchUpdate_594288 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsBatchUpdate_594290(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsBatchUpdate_594289(path: JsonNode; query: JsonNode;
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
  var valid_594291 = path.getOrDefault("spreadsheetId")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "spreadsheetId", valid_594291
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
  var valid_594292 = query.getOrDefault("upload_protocol")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = nil)
  if valid_594292 != nil:
    section.add "upload_protocol", valid_594292
  var valid_594293 = query.getOrDefault("fields")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "fields", valid_594293
  var valid_594294 = query.getOrDefault("quotaUser")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "quotaUser", valid_594294
  var valid_594295 = query.getOrDefault("alt")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = newJString("json"))
  if valid_594295 != nil:
    section.add "alt", valid_594295
  var valid_594296 = query.getOrDefault("oauth_token")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "oauth_token", valid_594296
  var valid_594297 = query.getOrDefault("callback")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "callback", valid_594297
  var valid_594298 = query.getOrDefault("access_token")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "access_token", valid_594298
  var valid_594299 = query.getOrDefault("uploadType")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "uploadType", valid_594299
  var valid_594300 = query.getOrDefault("key")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "key", valid_594300
  var valid_594301 = query.getOrDefault("$.xgafv")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = newJString("1"))
  if valid_594301 != nil:
    section.add "$.xgafv", valid_594301
  var valid_594302 = query.getOrDefault("prettyPrint")
  valid_594302 = validateParameter(valid_594302, JBool, required = false,
                                 default = newJBool(true))
  if valid_594302 != nil:
    section.add "prettyPrint", valid_594302
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

proc call*(call_594304: Call_SheetsSpreadsheetsBatchUpdate_594288; path: JsonNode;
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
  let valid = call_594304.validator(path, query, header, formData, body)
  let scheme = call_594304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594304.url(scheme.get, call_594304.host, call_594304.base,
                         call_594304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594304, url, valid)

proc call*(call_594305: Call_SheetsSpreadsheetsBatchUpdate_594288;
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
  var path_594306 = newJObject()
  var query_594307 = newJObject()
  var body_594308 = newJObject()
  add(query_594307, "upload_protocol", newJString(uploadProtocol))
  add(query_594307, "fields", newJString(fields))
  add(query_594307, "quotaUser", newJString(quotaUser))
  add(query_594307, "alt", newJString(alt))
  add(query_594307, "oauth_token", newJString(oauthToken))
  add(query_594307, "callback", newJString(callback))
  add(query_594307, "access_token", newJString(accessToken))
  add(query_594307, "uploadType", newJString(uploadType))
  add(query_594307, "key", newJString(key))
  add(query_594307, "$.xgafv", newJString(Xgafv))
  add(path_594306, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_594308 = body
  add(query_594307, "prettyPrint", newJBool(prettyPrint))
  result = call_594305.call(path_594306, query_594307, nil, nil, body_594308)

var sheetsSpreadsheetsBatchUpdate* = Call_SheetsSpreadsheetsBatchUpdate_594288(
    name: "sheetsSpreadsheetsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}:batchUpdate",
    validator: validate_SheetsSpreadsheetsBatchUpdate_594289, base: "/",
    url: url_SheetsSpreadsheetsBatchUpdate_594290, schemes: {Scheme.Https})
type
  Call_SheetsSpreadsheetsGetByDataFilter_594309 = ref object of OpenApiRestCall_593421
proc url_SheetsSpreadsheetsGetByDataFilter_594311(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SheetsSpreadsheetsGetByDataFilter_594310(path: JsonNode;
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
  var valid_594312 = path.getOrDefault("spreadsheetId")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "spreadsheetId", valid_594312
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
  var valid_594313 = query.getOrDefault("upload_protocol")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "upload_protocol", valid_594313
  var valid_594314 = query.getOrDefault("fields")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = nil)
  if valid_594314 != nil:
    section.add "fields", valid_594314
  var valid_594315 = query.getOrDefault("quotaUser")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "quotaUser", valid_594315
  var valid_594316 = query.getOrDefault("alt")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = newJString("json"))
  if valid_594316 != nil:
    section.add "alt", valid_594316
  var valid_594317 = query.getOrDefault("oauth_token")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "oauth_token", valid_594317
  var valid_594318 = query.getOrDefault("callback")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "callback", valid_594318
  var valid_594319 = query.getOrDefault("access_token")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "access_token", valid_594319
  var valid_594320 = query.getOrDefault("uploadType")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "uploadType", valid_594320
  var valid_594321 = query.getOrDefault("key")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "key", valid_594321
  var valid_594322 = query.getOrDefault("$.xgafv")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = newJString("1"))
  if valid_594322 != nil:
    section.add "$.xgafv", valid_594322
  var valid_594323 = query.getOrDefault("prettyPrint")
  valid_594323 = validateParameter(valid_594323, JBool, required = false,
                                 default = newJBool(true))
  if valid_594323 != nil:
    section.add "prettyPrint", valid_594323
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

proc call*(call_594325: Call_SheetsSpreadsheetsGetByDataFilter_594309;
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
  let valid = call_594325.validator(path, query, header, formData, body)
  let scheme = call_594325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594325.url(scheme.get, call_594325.host, call_594325.base,
                         call_594325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594325, url, valid)

proc call*(call_594326: Call_SheetsSpreadsheetsGetByDataFilter_594309;
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
  var path_594327 = newJObject()
  var query_594328 = newJObject()
  var body_594329 = newJObject()
  add(query_594328, "upload_protocol", newJString(uploadProtocol))
  add(query_594328, "fields", newJString(fields))
  add(query_594328, "quotaUser", newJString(quotaUser))
  add(query_594328, "alt", newJString(alt))
  add(query_594328, "oauth_token", newJString(oauthToken))
  add(query_594328, "callback", newJString(callback))
  add(query_594328, "access_token", newJString(accessToken))
  add(query_594328, "uploadType", newJString(uploadType))
  add(query_594328, "key", newJString(key))
  add(query_594328, "$.xgafv", newJString(Xgafv))
  add(path_594327, "spreadsheetId", newJString(spreadsheetId))
  if body != nil:
    body_594329 = body
  add(query_594328, "prettyPrint", newJBool(prettyPrint))
  result = call_594326.call(path_594327, query_594328, nil, nil, body_594329)

var sheetsSpreadsheetsGetByDataFilter* = Call_SheetsSpreadsheetsGetByDataFilter_594309(
    name: "sheetsSpreadsheetsGetByDataFilter", meth: HttpMethod.HttpPost,
    host: "sheets.googleapis.com",
    route: "/v4/spreadsheets/{spreadsheetId}:getByDataFilter",
    validator: validate_SheetsSpreadsheetsGetByDataFilter_594310, base: "/",
    url: url_SheetsSpreadsheetsGetByDataFilter_594311, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
