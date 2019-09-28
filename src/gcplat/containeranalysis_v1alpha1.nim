
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Container Analysis
## version: v1alpha1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## An implementation of the Grafeas API, which stores, and enables querying and retrieval of critical metadata about all of your software artifacts.
## 
## https://cloud.google.com/container-analysis/api/reference/rest/
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
  gcpServiceName = "containeranalysis"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContaineranalysisProjectsScanConfigsGet_579690 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsScanConfigsGet_579692(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsScanConfigsGet_579691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific scan configuration for a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the ScanConfig in the form
  ## projects/{project_id}/scanConfigs/{scan_config_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579818 = path.getOrDefault("name")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "name", valid_579818
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
  var valid_579819 = query.getOrDefault("upload_protocol")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "upload_protocol", valid_579819
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579835 = query.getOrDefault("alt")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("json"))
  if valid_579835 != nil:
    section.add "alt", valid_579835
  var valid_579836 = query.getOrDefault("oauth_token")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "oauth_token", valid_579836
  var valid_579837 = query.getOrDefault("callback")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "callback", valid_579837
  var valid_579838 = query.getOrDefault("access_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "access_token", valid_579838
  var valid_579839 = query.getOrDefault("uploadType")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "uploadType", valid_579839
  var valid_579840 = query.getOrDefault("key")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "key", valid_579840
  var valid_579841 = query.getOrDefault("$.xgafv")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = newJString("1"))
  if valid_579841 != nil:
    section.add "$.xgafv", valid_579841
  var valid_579842 = query.getOrDefault("prettyPrint")
  valid_579842 = validateParameter(valid_579842, JBool, required = false,
                                 default = newJBool(true))
  if valid_579842 != nil:
    section.add "prettyPrint", valid_579842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579865: Call_ContaineranalysisProjectsScanConfigsGet_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a specific scan configuration for a project.
  ## 
  let valid = call_579865.validator(path, query, header, formData, body)
  let scheme = call_579865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579865.url(scheme.get, call_579865.host, call_579865.base,
                         call_579865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579865, url, valid)

proc call*(call_579936: Call_ContaineranalysisProjectsScanConfigsGet_579690;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsScanConfigsGet
  ## Gets a specific scan configuration for a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the ScanConfig in the form
  ## projects/{project_id}/scanConfigs/{scan_config_id}
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579937 = newJObject()
  var query_579939 = newJObject()
  add(query_579939, "upload_protocol", newJString(uploadProtocol))
  add(query_579939, "fields", newJString(fields))
  add(query_579939, "quotaUser", newJString(quotaUser))
  add(path_579937, "name", newJString(name))
  add(query_579939, "alt", newJString(alt))
  add(query_579939, "oauth_token", newJString(oauthToken))
  add(query_579939, "callback", newJString(callback))
  add(query_579939, "access_token", newJString(accessToken))
  add(query_579939, "uploadType", newJString(uploadType))
  add(query_579939, "key", newJString(key))
  add(query_579939, "$.xgafv", newJString(Xgafv))
  add(query_579939, "prettyPrint", newJBool(prettyPrint))
  result = call_579936.call(path_579937, query_579939, nil, nil, nil)

var containeranalysisProjectsScanConfigsGet* = Call_ContaineranalysisProjectsScanConfigsGet_579690(
    name: "containeranalysisProjectsScanConfigsGet", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_ContaineranalysisProjectsScanConfigsGet_579691, base: "/",
    url: url_ContaineranalysisProjectsScanConfigsGet_579692,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsScanConfigsPatch_579997 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsScanConfigsPatch_579999(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsScanConfigsPatch_579998(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the scan configuration to a new value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The scan config to update of the form
  ## projects/{project_id}/scanConfigs/{scan_config_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580000 = path.getOrDefault("name")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "name", valid_580000
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
  ##   updateMask: JString
  ##             : The fields to update.
  section = newJObject()
  var valid_580001 = query.getOrDefault("upload_protocol")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "upload_protocol", valid_580001
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("oauth_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "oauth_token", valid_580005
  var valid_580006 = query.getOrDefault("callback")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "callback", valid_580006
  var valid_580007 = query.getOrDefault("access_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "access_token", valid_580007
  var valid_580008 = query.getOrDefault("uploadType")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "uploadType", valid_580008
  var valid_580009 = query.getOrDefault("key")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "key", valid_580009
  var valid_580010 = query.getOrDefault("$.xgafv")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("1"))
  if valid_580010 != nil:
    section.add "$.xgafv", valid_580010
  var valid_580011 = query.getOrDefault("prettyPrint")
  valid_580011 = validateParameter(valid_580011, JBool, required = false,
                                 default = newJBool(true))
  if valid_580011 != nil:
    section.add "prettyPrint", valid_580011
  var valid_580012 = query.getOrDefault("updateMask")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "updateMask", valid_580012
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

proc call*(call_580014: Call_ContaineranalysisProjectsScanConfigsPatch_579997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the scan configuration to a new value.
  ## 
  let valid = call_580014.validator(path, query, header, formData, body)
  let scheme = call_580014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580014.url(scheme.get, call_580014.host, call_580014.base,
                         call_580014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580014, url, valid)

proc call*(call_580015: Call_ContaineranalysisProjectsScanConfigsPatch_579997;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## containeranalysisProjectsScanConfigsPatch
  ## Updates the scan configuration to a new value.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The scan config to update of the form
  ## projects/{project_id}/scanConfigs/{scan_config_id}.
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
  ##   updateMask: string
  ##             : The fields to update.
  var path_580016 = newJObject()
  var query_580017 = newJObject()
  var body_580018 = newJObject()
  add(query_580017, "upload_protocol", newJString(uploadProtocol))
  add(query_580017, "fields", newJString(fields))
  add(query_580017, "quotaUser", newJString(quotaUser))
  add(path_580016, "name", newJString(name))
  add(query_580017, "alt", newJString(alt))
  add(query_580017, "oauth_token", newJString(oauthToken))
  add(query_580017, "callback", newJString(callback))
  add(query_580017, "access_token", newJString(accessToken))
  add(query_580017, "uploadType", newJString(uploadType))
  add(query_580017, "key", newJString(key))
  add(query_580017, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580018 = body
  add(query_580017, "prettyPrint", newJBool(prettyPrint))
  add(query_580017, "updateMask", newJString(updateMask))
  result = call_580015.call(path_580016, query_580017, nil, nil, body_580018)

var containeranalysisProjectsScanConfigsPatch* = Call_ContaineranalysisProjectsScanConfigsPatch_579997(
    name: "containeranalysisProjectsScanConfigsPatch", meth: HttpMethod.HttpPatch,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_ContaineranalysisProjectsScanConfigsPatch_579998,
    base: "/", url: url_ContaineranalysisProjectsScanConfigsPatch_579999,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesDelete_579978 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsNotesDelete_579980(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesDelete_579979(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the given `Note` from the system.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note in the form of
  ## "providers/{provider_id}/notes/{NOTE_ID}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579981 = path.getOrDefault("name")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "name", valid_579981
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
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("callback")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "callback", valid_579987
  var valid_579988 = query.getOrDefault("access_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "access_token", valid_579988
  var valid_579989 = query.getOrDefault("uploadType")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "uploadType", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("$.xgafv")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("1"))
  if valid_579991 != nil:
    section.add "$.xgafv", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579993: Call_ContaineranalysisProjectsNotesDelete_579978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the given `Note` from the system.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_ContaineranalysisProjectsNotesDelete_579978;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesDelete
  ## Deletes the given `Note` from the system.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the note in the form of
  ## "providers/{provider_id}/notes/{NOTE_ID}"
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  add(query_579996, "upload_protocol", newJString(uploadProtocol))
  add(query_579996, "fields", newJString(fields))
  add(query_579996, "quotaUser", newJString(quotaUser))
  add(path_579995, "name", newJString(name))
  add(query_579996, "alt", newJString(alt))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(query_579996, "callback", newJString(callback))
  add(query_579996, "access_token", newJString(accessToken))
  add(query_579996, "uploadType", newJString(uploadType))
  add(query_579996, "key", newJString(key))
  add(query_579996, "$.xgafv", newJString(Xgafv))
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  result = call_579994.call(path_579995, query_579996, nil, nil, nil)

var containeranalysisProjectsNotesDelete* = Call_ContaineranalysisProjectsNotesDelete_579978(
    name: "containeranalysisProjectsNotesDelete", meth: HttpMethod.HttpDelete,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_ContaineranalysisProjectsNotesDelete_579979, base: "/",
    url: url_ContaineranalysisProjectsNotesDelete_579980, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesCreate_580042 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProvidersNotesCreate_580044(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesCreate_580043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Note`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580045 = path.getOrDefault("name")
  valid_580045 = validateParameter(valid_580045, JString, required = true,
                                 default = nil)
  if valid_580045 != nil:
    section.add "name", valid_580045
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
  ##   noteId: JString
  ##         : The ID to use for this note.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580046 = query.getOrDefault("upload_protocol")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "upload_protocol", valid_580046
  var valid_580047 = query.getOrDefault("fields")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "fields", valid_580047
  var valid_580048 = query.getOrDefault("quotaUser")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "quotaUser", valid_580048
  var valid_580049 = query.getOrDefault("alt")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = newJString("json"))
  if valid_580049 != nil:
    section.add "alt", valid_580049
  var valid_580050 = query.getOrDefault("noteId")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "noteId", valid_580050
  var valid_580051 = query.getOrDefault("oauth_token")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "oauth_token", valid_580051
  var valid_580052 = query.getOrDefault("callback")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "callback", valid_580052
  var valid_580053 = query.getOrDefault("access_token")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "access_token", valid_580053
  var valid_580054 = query.getOrDefault("uploadType")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "uploadType", valid_580054
  var valid_580055 = query.getOrDefault("parent")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "parent", valid_580055
  var valid_580056 = query.getOrDefault("key")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "key", valid_580056
  var valid_580057 = query.getOrDefault("$.xgafv")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("1"))
  if valid_580057 != nil:
    section.add "$.xgafv", valid_580057
  var valid_580058 = query.getOrDefault("prettyPrint")
  valid_580058 = validateParameter(valid_580058, JBool, required = false,
                                 default = newJBool(true))
  if valid_580058 != nil:
    section.add "prettyPrint", valid_580058
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

proc call*(call_580060: Call_ContaineranalysisProvidersNotesCreate_580042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Note`.
  ## 
  let valid = call_580060.validator(path, query, header, formData, body)
  let scheme = call_580060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580060.url(scheme.get, call_580060.host, call_580060.base,
                         call_580060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580060, url, valid)

proc call*(call_580061: Call_ContaineranalysisProvidersNotesCreate_580042;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; noteId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; parent: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containeranalysisProvidersNotesCreate
  ## Creates a new `Note`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  ##   alt: string
  ##      : Data format for response.
  ##   noteId: string
  ##         : The ID to use for this note.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580062 = newJObject()
  var query_580063 = newJObject()
  var body_580064 = newJObject()
  add(query_580063, "upload_protocol", newJString(uploadProtocol))
  add(query_580063, "fields", newJString(fields))
  add(query_580063, "quotaUser", newJString(quotaUser))
  add(path_580062, "name", newJString(name))
  add(query_580063, "alt", newJString(alt))
  add(query_580063, "noteId", newJString(noteId))
  add(query_580063, "oauth_token", newJString(oauthToken))
  add(query_580063, "callback", newJString(callback))
  add(query_580063, "access_token", newJString(accessToken))
  add(query_580063, "uploadType", newJString(uploadType))
  add(query_580063, "parent", newJString(parent))
  add(query_580063, "key", newJString(key))
  add(query_580063, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580064 = body
  add(query_580063, "prettyPrint", newJBool(prettyPrint))
  result = call_580061.call(path_580062, query_580063, nil, nil, body_580064)

var containeranalysisProvidersNotesCreate* = Call_ContaineranalysisProvidersNotesCreate_580042(
    name: "containeranalysisProvidersNotesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}/notes",
    validator: validate_ContaineranalysisProvidersNotesCreate_580043, base: "/",
    url: url_ContaineranalysisProvidersNotesCreate_580044, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesGetNotes_580019 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsOccurrencesGetNotes_580021(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesGetNotes_580020(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the `Note` attached to the given `Occurrence`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the occurrence in the form
  ## "projects/{project_id}/occurrences/{OCCURRENCE_ID}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580022 = path.getOrDefault("name")
  valid_580022 = validateParameter(valid_580022, JString, required = true,
                                 default = nil)
  if valid_580022 != nil:
    section.add "name", valid_580022
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##   parent: JString
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of notes to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
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
  var valid_580025 = query.getOrDefault("pageToken")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "pageToken", valid_580025
  var valid_580026 = query.getOrDefault("quotaUser")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "quotaUser", valid_580026
  var valid_580027 = query.getOrDefault("alt")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("json"))
  if valid_580027 != nil:
    section.add "alt", valid_580027
  var valid_580028 = query.getOrDefault("oauth_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "oauth_token", valid_580028
  var valid_580029 = query.getOrDefault("callback")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "callback", valid_580029
  var valid_580030 = query.getOrDefault("access_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "access_token", valid_580030
  var valid_580031 = query.getOrDefault("uploadType")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "uploadType", valid_580031
  var valid_580032 = query.getOrDefault("parent")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "parent", valid_580032
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("$.xgafv")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("1"))
  if valid_580034 != nil:
    section.add "$.xgafv", valid_580034
  var valid_580035 = query.getOrDefault("pageSize")
  valid_580035 = validateParameter(valid_580035, JInt, required = false, default = nil)
  if valid_580035 != nil:
    section.add "pageSize", valid_580035
  var valid_580036 = query.getOrDefault("prettyPrint")
  valid_580036 = validateParameter(valid_580036, JBool, required = false,
                                 default = newJBool(true))
  if valid_580036 != nil:
    section.add "prettyPrint", valid_580036
  var valid_580037 = query.getOrDefault("filter")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "filter", valid_580037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580038: Call_ContaineranalysisProjectsOccurrencesGetNotes_580019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the `Note` attached to the given `Occurrence`.
  ## 
  let valid = call_580038.validator(path, query, header, formData, body)
  let scheme = call_580038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580038.url(scheme.get, call_580038.host, call_580038.base,
                         call_580038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580038, url, valid)

proc call*(call_580039: Call_ContaineranalysisProjectsOccurrencesGetNotes_580019;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; parent: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesGetNotes
  ## Gets the `Note` attached to the given `Occurrence`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the occurrence in the form
  ## "projects/{project_id}/occurrences/{OCCURRENCE_ID}"
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
  ##   parent: string
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of notes to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_580040 = newJObject()
  var query_580041 = newJObject()
  add(query_580041, "upload_protocol", newJString(uploadProtocol))
  add(query_580041, "fields", newJString(fields))
  add(query_580041, "pageToken", newJString(pageToken))
  add(query_580041, "quotaUser", newJString(quotaUser))
  add(path_580040, "name", newJString(name))
  add(query_580041, "alt", newJString(alt))
  add(query_580041, "oauth_token", newJString(oauthToken))
  add(query_580041, "callback", newJString(callback))
  add(query_580041, "access_token", newJString(accessToken))
  add(query_580041, "uploadType", newJString(uploadType))
  add(query_580041, "parent", newJString(parent))
  add(query_580041, "key", newJString(key))
  add(query_580041, "$.xgafv", newJString(Xgafv))
  add(query_580041, "pageSize", newJInt(pageSize))
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  add(query_580041, "filter", newJString(filter))
  result = call_580039.call(path_580040, query_580041, nil, nil, nil)

var containeranalysisProjectsOccurrencesGetNotes* = Call_ContaineranalysisProjectsOccurrencesGetNotes_580019(
    name: "containeranalysisProjectsOccurrencesGetNotes",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{name}/notes",
    validator: validate_ContaineranalysisProjectsOccurrencesGetNotes_580020,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesGetNotes_580021,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesOccurrencesList_580065 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsNotesOccurrencesList_580067(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesOccurrencesList_580066(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists `Occurrences` referencing the specified `Note`. Use this method to
  ## get all occurrences referencing your `Note` across all your customer
  ## projects.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name field will contain the note name for example:
  ##   "provider/{provider_id}/notes/{note_id}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580068 = path.getOrDefault("name")
  valid_580068 = validateParameter(valid_580068, JString, required = true,
                                 default = nil)
  if valid_580068 != nil:
    section.add "name", valid_580068
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##   pageSize: JInt
  ##           : Number of notes to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_580069 = query.getOrDefault("upload_protocol")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "upload_protocol", valid_580069
  var valid_580070 = query.getOrDefault("fields")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "fields", valid_580070
  var valid_580071 = query.getOrDefault("pageToken")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "pageToken", valid_580071
  var valid_580072 = query.getOrDefault("quotaUser")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "quotaUser", valid_580072
  var valid_580073 = query.getOrDefault("alt")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("json"))
  if valid_580073 != nil:
    section.add "alt", valid_580073
  var valid_580074 = query.getOrDefault("oauth_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "oauth_token", valid_580074
  var valid_580075 = query.getOrDefault("callback")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "callback", valid_580075
  var valid_580076 = query.getOrDefault("access_token")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "access_token", valid_580076
  var valid_580077 = query.getOrDefault("uploadType")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "uploadType", valid_580077
  var valid_580078 = query.getOrDefault("key")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "key", valid_580078
  var valid_580079 = query.getOrDefault("$.xgafv")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = newJString("1"))
  if valid_580079 != nil:
    section.add "$.xgafv", valid_580079
  var valid_580080 = query.getOrDefault("pageSize")
  valid_580080 = validateParameter(valid_580080, JInt, required = false, default = nil)
  if valid_580080 != nil:
    section.add "pageSize", valid_580080
  var valid_580081 = query.getOrDefault("prettyPrint")
  valid_580081 = validateParameter(valid_580081, JBool, required = false,
                                 default = newJBool(true))
  if valid_580081 != nil:
    section.add "prettyPrint", valid_580081
  var valid_580082 = query.getOrDefault("filter")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "filter", valid_580082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580083: Call_ContaineranalysisProjectsNotesOccurrencesList_580065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists `Occurrences` referencing the specified `Note`. Use this method to
  ## get all occurrences referencing your `Note` across all your customer
  ## projects.
  ## 
  let valid = call_580083.validator(path, query, header, formData, body)
  let scheme = call_580083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580083.url(scheme.get, call_580083.host, call_580083.base,
                         call_580083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580083, url, valid)

proc call*(call_580084: Call_ContaineranalysisProjectsNotesOccurrencesList_580065;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsNotesOccurrencesList
  ## Lists `Occurrences` referencing the specified `Note`. Use this method to
  ## get all occurrences referencing your `Note` across all your customer
  ## projects.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name field will contain the note name for example:
  ##   "provider/{provider_id}/notes/{note_id}"
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
  ##   pageSize: int
  ##           : Number of notes to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_580085 = newJObject()
  var query_580086 = newJObject()
  add(query_580086, "upload_protocol", newJString(uploadProtocol))
  add(query_580086, "fields", newJString(fields))
  add(query_580086, "pageToken", newJString(pageToken))
  add(query_580086, "quotaUser", newJString(quotaUser))
  add(path_580085, "name", newJString(name))
  add(query_580086, "alt", newJString(alt))
  add(query_580086, "oauth_token", newJString(oauthToken))
  add(query_580086, "callback", newJString(callback))
  add(query_580086, "access_token", newJString(accessToken))
  add(query_580086, "uploadType", newJString(uploadType))
  add(query_580086, "key", newJString(key))
  add(query_580086, "$.xgafv", newJString(Xgafv))
  add(query_580086, "pageSize", newJInt(pageSize))
  add(query_580086, "prettyPrint", newJBool(prettyPrint))
  add(query_580086, "filter", newJString(filter))
  result = call_580084.call(path_580085, query_580086, nil, nil, nil)

var containeranalysisProjectsNotesOccurrencesList* = Call_ContaineranalysisProjectsNotesOccurrencesList_580065(
    name: "containeranalysisProjectsNotesOccurrencesList",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{name}/occurrences",
    validator: validate_ContaineranalysisProjectsNotesOccurrencesList_580066,
    base: "/", url: url_ContaineranalysisProjectsNotesOccurrencesList_580067,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesCreate_580110 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsNotesCreate_580112(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesCreate_580111(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Note`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580113 = path.getOrDefault("parent")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "parent", valid_580113
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
  ##   noteId: JString
  ##         : The ID to use for this note.
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
  ##   name: JString
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580114 = query.getOrDefault("upload_protocol")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "upload_protocol", valid_580114
  var valid_580115 = query.getOrDefault("fields")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "fields", valid_580115
  var valid_580116 = query.getOrDefault("quotaUser")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "quotaUser", valid_580116
  var valid_580117 = query.getOrDefault("alt")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = newJString("json"))
  if valid_580117 != nil:
    section.add "alt", valid_580117
  var valid_580118 = query.getOrDefault("noteId")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "noteId", valid_580118
  var valid_580119 = query.getOrDefault("oauth_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "oauth_token", valid_580119
  var valid_580120 = query.getOrDefault("callback")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "callback", valid_580120
  var valid_580121 = query.getOrDefault("access_token")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "access_token", valid_580121
  var valid_580122 = query.getOrDefault("uploadType")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "uploadType", valid_580122
  var valid_580123 = query.getOrDefault("key")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "key", valid_580123
  var valid_580124 = query.getOrDefault("name")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "name", valid_580124
  var valid_580125 = query.getOrDefault("$.xgafv")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("1"))
  if valid_580125 != nil:
    section.add "$.xgafv", valid_580125
  var valid_580126 = query.getOrDefault("prettyPrint")
  valid_580126 = validateParameter(valid_580126, JBool, required = false,
                                 default = newJBool(true))
  if valid_580126 != nil:
    section.add "prettyPrint", valid_580126
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

proc call*(call_580128: Call_ContaineranalysisProjectsNotesCreate_580110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Note`.
  ## 
  let valid = call_580128.validator(path, query, header, formData, body)
  let scheme = call_580128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580128.url(scheme.get, call_580128.host, call_580128.base,
                         call_580128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580128, url, valid)

proc call*(call_580129: Call_ContaineranalysisProjectsNotesCreate_580110;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; noteId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; name: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesCreate
  ## Creates a new `Note`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   noteId: string
  ##         : The ID to use for this note.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580130 = newJObject()
  var query_580131 = newJObject()
  var body_580132 = newJObject()
  add(query_580131, "upload_protocol", newJString(uploadProtocol))
  add(query_580131, "fields", newJString(fields))
  add(query_580131, "quotaUser", newJString(quotaUser))
  add(query_580131, "alt", newJString(alt))
  add(query_580131, "noteId", newJString(noteId))
  add(query_580131, "oauth_token", newJString(oauthToken))
  add(query_580131, "callback", newJString(callback))
  add(query_580131, "access_token", newJString(accessToken))
  add(query_580131, "uploadType", newJString(uploadType))
  add(path_580130, "parent", newJString(parent))
  add(query_580131, "key", newJString(key))
  add(query_580131, "name", newJString(name))
  add(query_580131, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580132 = body
  add(query_580131, "prettyPrint", newJBool(prettyPrint))
  result = call_580129.call(path_580130, query_580131, nil, nil, body_580132)

var containeranalysisProjectsNotesCreate* = Call_ContaineranalysisProjectsNotesCreate_580110(
    name: "containeranalysisProjectsNotesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{parent}/notes",
    validator: validate_ContaineranalysisProjectsNotesCreate_580111, base: "/",
    url: url_ContaineranalysisProjectsNotesCreate_580112, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesList_580087 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsNotesList_580089(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesList_580088(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all `Notes` for a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580090 = path.getOrDefault("parent")
  valid_580090 = validateParameter(valid_580090, JString, required = true,
                                 default = nil)
  if valid_580090 != nil:
    section.add "parent", valid_580090
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##   name: JString
  ##       : The name field will contain the project Id for example:
  ## "providers/{provider_id}
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of notes to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
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
  var valid_580093 = query.getOrDefault("pageToken")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "pageToken", valid_580093
  var valid_580094 = query.getOrDefault("quotaUser")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "quotaUser", valid_580094
  var valid_580095 = query.getOrDefault("alt")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("json"))
  if valid_580095 != nil:
    section.add "alt", valid_580095
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
  var valid_580100 = query.getOrDefault("key")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "key", valid_580100
  var valid_580101 = query.getOrDefault("name")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "name", valid_580101
  var valid_580102 = query.getOrDefault("$.xgafv")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = newJString("1"))
  if valid_580102 != nil:
    section.add "$.xgafv", valid_580102
  var valid_580103 = query.getOrDefault("pageSize")
  valid_580103 = validateParameter(valid_580103, JInt, required = false, default = nil)
  if valid_580103 != nil:
    section.add "pageSize", valid_580103
  var valid_580104 = query.getOrDefault("prettyPrint")
  valid_580104 = validateParameter(valid_580104, JBool, required = false,
                                 default = newJBool(true))
  if valid_580104 != nil:
    section.add "prettyPrint", valid_580104
  var valid_580105 = query.getOrDefault("filter")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "filter", valid_580105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580106: Call_ContaineranalysisProjectsNotesList_580087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all `Notes` for a given project.
  ## 
  let valid = call_580106.validator(path, query, header, formData, body)
  let scheme = call_580106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580106.url(scheme.get, call_580106.host, call_580106.base,
                         call_580106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580106, url, valid)

proc call*(call_580107: Call_ContaineranalysisProjectsNotesList_580087;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; name: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsNotesList
  ## Lists all `Notes` for a given project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##   parent: string (required)
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name field will contain the project Id for example:
  ## "providers/{provider_id}
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of notes to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_580108 = newJObject()
  var query_580109 = newJObject()
  add(query_580109, "upload_protocol", newJString(uploadProtocol))
  add(query_580109, "fields", newJString(fields))
  add(query_580109, "pageToken", newJString(pageToken))
  add(query_580109, "quotaUser", newJString(quotaUser))
  add(query_580109, "alt", newJString(alt))
  add(query_580109, "oauth_token", newJString(oauthToken))
  add(query_580109, "callback", newJString(callback))
  add(query_580109, "access_token", newJString(accessToken))
  add(query_580109, "uploadType", newJString(uploadType))
  add(path_580108, "parent", newJString(parent))
  add(query_580109, "key", newJString(key))
  add(query_580109, "name", newJString(name))
  add(query_580109, "$.xgafv", newJString(Xgafv))
  add(query_580109, "pageSize", newJInt(pageSize))
  add(query_580109, "prettyPrint", newJBool(prettyPrint))
  add(query_580109, "filter", newJString(filter))
  result = call_580107.call(path_580108, query_580109, nil, nil, nil)

var containeranalysisProjectsNotesList* = Call_ContaineranalysisProjectsNotesList_580087(
    name: "containeranalysisProjectsNotesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{parent}/notes",
    validator: validate_ContaineranalysisProjectsNotesList_580088, base: "/",
    url: url_ContaineranalysisProjectsNotesList_580089, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesCreate_580157 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsOccurrencesCreate_580159(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesCreate_580158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Occurrence`. Use this method to create `Occurrences`
  ## for a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This field contains the project Id for example: "projects/{project_id}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580160 = path.getOrDefault("parent")
  valid_580160 = validateParameter(valid_580160, JString, required = true,
                                 default = nil)
  if valid_580160 != nil:
    section.add "parent", valid_580160
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
  ##   name: JString
  ##       : The name of the project.  Should be of the form "projects/{project_id}".
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580161 = query.getOrDefault("upload_protocol")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "upload_protocol", valid_580161
  var valid_580162 = query.getOrDefault("fields")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "fields", valid_580162
  var valid_580163 = query.getOrDefault("quotaUser")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "quotaUser", valid_580163
  var valid_580164 = query.getOrDefault("alt")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("json"))
  if valid_580164 != nil:
    section.add "alt", valid_580164
  var valid_580165 = query.getOrDefault("oauth_token")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "oauth_token", valid_580165
  var valid_580166 = query.getOrDefault("callback")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "callback", valid_580166
  var valid_580167 = query.getOrDefault("access_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "access_token", valid_580167
  var valid_580168 = query.getOrDefault("uploadType")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "uploadType", valid_580168
  var valid_580169 = query.getOrDefault("key")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "key", valid_580169
  var valid_580170 = query.getOrDefault("name")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "name", valid_580170
  var valid_580171 = query.getOrDefault("$.xgafv")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = newJString("1"))
  if valid_580171 != nil:
    section.add "$.xgafv", valid_580171
  var valid_580172 = query.getOrDefault("prettyPrint")
  valid_580172 = validateParameter(valid_580172, JBool, required = false,
                                 default = newJBool(true))
  if valid_580172 != nil:
    section.add "prettyPrint", valid_580172
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

proc call*(call_580174: Call_ContaineranalysisProjectsOccurrencesCreate_580157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Occurrence`. Use this method to create `Occurrences`
  ## for a resource.
  ## 
  let valid = call_580174.validator(path, query, header, formData, body)
  let scheme = call_580174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580174.url(scheme.get, call_580174.host, call_580174.base,
                         call_580174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580174, url, valid)

proc call*(call_580175: Call_ContaineranalysisProjectsOccurrencesCreate_580157;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsOccurrencesCreate
  ## Creates a new `Occurrence`. Use this method to create `Occurrences`
  ## for a resource.
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
  ##   parent: string (required)
  ##         : This field contains the project Id for example: "projects/{project_id}"
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name of the project.  Should be of the form "projects/{project_id}".
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580176 = newJObject()
  var query_580177 = newJObject()
  var body_580178 = newJObject()
  add(query_580177, "upload_protocol", newJString(uploadProtocol))
  add(query_580177, "fields", newJString(fields))
  add(query_580177, "quotaUser", newJString(quotaUser))
  add(query_580177, "alt", newJString(alt))
  add(query_580177, "oauth_token", newJString(oauthToken))
  add(query_580177, "callback", newJString(callback))
  add(query_580177, "access_token", newJString(accessToken))
  add(query_580177, "uploadType", newJString(uploadType))
  add(path_580176, "parent", newJString(parent))
  add(query_580177, "key", newJString(key))
  add(query_580177, "name", newJString(name))
  add(query_580177, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580178 = body
  add(query_580177, "prettyPrint", newJBool(prettyPrint))
  result = call_580175.call(path_580176, query_580177, nil, nil, body_580178)

var containeranalysisProjectsOccurrencesCreate* = Call_ContaineranalysisProjectsOccurrencesCreate_580157(
    name: "containeranalysisProjectsOccurrencesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/occurrences",
    validator: validate_ContaineranalysisProjectsOccurrencesCreate_580158,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesCreate_580159,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesList_580133 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsOccurrencesList_580135(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesList_580134(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists active `Occurrences` for a given project matching the filters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This contains the project Id for example: projects/{project_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580136 = path.getOrDefault("parent")
  valid_580136 = validateParameter(valid_580136, JString, required = true,
                                 default = nil)
  if valid_580136 != nil:
    section.add "parent", valid_580136
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##   kind: JString
  ##       : The kind of occurrences to filter on.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name field contains the project Id. For example:
  ## "projects/{project_id}
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of occurrences to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_580137 = query.getOrDefault("upload_protocol")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "upload_protocol", valid_580137
  var valid_580138 = query.getOrDefault("fields")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "fields", valid_580138
  var valid_580139 = query.getOrDefault("pageToken")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "pageToken", valid_580139
  var valid_580140 = query.getOrDefault("quotaUser")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "quotaUser", valid_580140
  var valid_580141 = query.getOrDefault("alt")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("json"))
  if valid_580141 != nil:
    section.add "alt", valid_580141
  var valid_580142 = query.getOrDefault("oauth_token")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "oauth_token", valid_580142
  var valid_580143 = query.getOrDefault("callback")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "callback", valid_580143
  var valid_580144 = query.getOrDefault("access_token")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "access_token", valid_580144
  var valid_580145 = query.getOrDefault("uploadType")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "uploadType", valid_580145
  var valid_580146 = query.getOrDefault("kind")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("KIND_UNSPECIFIED"))
  if valid_580146 != nil:
    section.add "kind", valid_580146
  var valid_580147 = query.getOrDefault("key")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "key", valid_580147
  var valid_580148 = query.getOrDefault("name")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "name", valid_580148
  var valid_580149 = query.getOrDefault("$.xgafv")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = newJString("1"))
  if valid_580149 != nil:
    section.add "$.xgafv", valid_580149
  var valid_580150 = query.getOrDefault("pageSize")
  valid_580150 = validateParameter(valid_580150, JInt, required = false, default = nil)
  if valid_580150 != nil:
    section.add "pageSize", valid_580150
  var valid_580151 = query.getOrDefault("prettyPrint")
  valid_580151 = validateParameter(valid_580151, JBool, required = false,
                                 default = newJBool(true))
  if valid_580151 != nil:
    section.add "prettyPrint", valid_580151
  var valid_580152 = query.getOrDefault("filter")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "filter", valid_580152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580153: Call_ContaineranalysisProjectsOccurrencesList_580133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists active `Occurrences` for a given project matching the filters.
  ## 
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_ContaineranalysisProjectsOccurrencesList_580133;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; kind: string = "KIND_UNSPECIFIED"; key: string = "";
          name: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesList
  ## Lists active `Occurrences` for a given project matching the filters.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##   parent: string (required)
  ##         : This contains the project Id for example: projects/{project_id}.
  ##   kind: string
  ##       : The kind of occurrences to filter on.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name field contains the project Id. For example:
  ## "projects/{project_id}
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of occurrences to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_580155 = newJObject()
  var query_580156 = newJObject()
  add(query_580156, "upload_protocol", newJString(uploadProtocol))
  add(query_580156, "fields", newJString(fields))
  add(query_580156, "pageToken", newJString(pageToken))
  add(query_580156, "quotaUser", newJString(quotaUser))
  add(query_580156, "alt", newJString(alt))
  add(query_580156, "oauth_token", newJString(oauthToken))
  add(query_580156, "callback", newJString(callback))
  add(query_580156, "access_token", newJString(accessToken))
  add(query_580156, "uploadType", newJString(uploadType))
  add(path_580155, "parent", newJString(parent))
  add(query_580156, "kind", newJString(kind))
  add(query_580156, "key", newJString(key))
  add(query_580156, "name", newJString(name))
  add(query_580156, "$.xgafv", newJString(Xgafv))
  add(query_580156, "pageSize", newJInt(pageSize))
  add(query_580156, "prettyPrint", newJBool(prettyPrint))
  add(query_580156, "filter", newJString(filter))
  result = call_580154.call(path_580155, query_580156, nil, nil, nil)

var containeranalysisProjectsOccurrencesList* = Call_ContaineranalysisProjectsOccurrencesList_580133(
    name: "containeranalysisProjectsOccurrencesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/occurrences",
    validator: validate_ContaineranalysisProjectsOccurrencesList_580134,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesList_580135,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_580179 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_580181(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"), (kind: ConstantSegment,
        value: "/occurrences:vulnerabilitySummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_580180(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a summary of the number and severity of occurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This contains the project Id for example: projects/{project_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580182 = path.getOrDefault("parent")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "parent", valid_580182
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
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_580183 = query.getOrDefault("upload_protocol")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "upload_protocol", valid_580183
  var valid_580184 = query.getOrDefault("fields")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "fields", valid_580184
  var valid_580185 = query.getOrDefault("quotaUser")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "quotaUser", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("oauth_token")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "oauth_token", valid_580187
  var valid_580188 = query.getOrDefault("callback")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "callback", valid_580188
  var valid_580189 = query.getOrDefault("access_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "access_token", valid_580189
  var valid_580190 = query.getOrDefault("uploadType")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "uploadType", valid_580190
  var valid_580191 = query.getOrDefault("key")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "key", valid_580191
  var valid_580192 = query.getOrDefault("$.xgafv")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("1"))
  if valid_580192 != nil:
    section.add "$.xgafv", valid_580192
  var valid_580193 = query.getOrDefault("prettyPrint")
  valid_580193 = validateParameter(valid_580193, JBool, required = false,
                                 default = newJBool(true))
  if valid_580193 != nil:
    section.add "prettyPrint", valid_580193
  var valid_580194 = query.getOrDefault("filter")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "filter", valid_580194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580195: Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_580179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a summary of the number and severity of occurrences.
  ## 
  let valid = call_580195.validator(path, query, header, formData, body)
  let scheme = call_580195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580195.url(scheme.get, call_580195.host, call_580195.base,
                         call_580195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580195, url, valid)

proc call*(call_580196: Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_580179;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesGetVulnerabilitySummary
  ## Gets a summary of the number and severity of occurrences.
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
  ##   parent: string (required)
  ##         : This contains the project Id for example: projects/{project_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_580197 = newJObject()
  var query_580198 = newJObject()
  add(query_580198, "upload_protocol", newJString(uploadProtocol))
  add(query_580198, "fields", newJString(fields))
  add(query_580198, "quotaUser", newJString(quotaUser))
  add(query_580198, "alt", newJString(alt))
  add(query_580198, "oauth_token", newJString(oauthToken))
  add(query_580198, "callback", newJString(callback))
  add(query_580198, "access_token", newJString(accessToken))
  add(query_580198, "uploadType", newJString(uploadType))
  add(path_580197, "parent", newJString(parent))
  add(query_580198, "key", newJString(key))
  add(query_580198, "$.xgafv", newJString(Xgafv))
  add(query_580198, "prettyPrint", newJBool(prettyPrint))
  add(query_580198, "filter", newJString(filter))
  result = call_580196.call(path_580197, query_580198, nil, nil, nil)

var containeranalysisProjectsOccurrencesGetVulnerabilitySummary* = Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_580179(
    name: "containeranalysisProjectsOccurrencesGetVulnerabilitySummary",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/occurrences:vulnerabilitySummary", validator: validate_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_580180,
    base: "/",
    url: url_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_580181,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOperationsCreate_580199 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsOperationsCreate_580201(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOperationsCreate_580200(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Operation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project Id that this operation should be created under.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580202 = path.getOrDefault("parent")
  valid_580202 = validateParameter(valid_580202, JString, required = true,
                                 default = nil)
  if valid_580202 != nil:
    section.add "parent", valid_580202
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
  var valid_580203 = query.getOrDefault("upload_protocol")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "upload_protocol", valid_580203
  var valid_580204 = query.getOrDefault("fields")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "fields", valid_580204
  var valid_580205 = query.getOrDefault("quotaUser")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "quotaUser", valid_580205
  var valid_580206 = query.getOrDefault("alt")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("json"))
  if valid_580206 != nil:
    section.add "alt", valid_580206
  var valid_580207 = query.getOrDefault("oauth_token")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "oauth_token", valid_580207
  var valid_580208 = query.getOrDefault("callback")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "callback", valid_580208
  var valid_580209 = query.getOrDefault("access_token")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "access_token", valid_580209
  var valid_580210 = query.getOrDefault("uploadType")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "uploadType", valid_580210
  var valid_580211 = query.getOrDefault("key")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "key", valid_580211
  var valid_580212 = query.getOrDefault("$.xgafv")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = newJString("1"))
  if valid_580212 != nil:
    section.add "$.xgafv", valid_580212
  var valid_580213 = query.getOrDefault("prettyPrint")
  valid_580213 = validateParameter(valid_580213, JBool, required = false,
                                 default = newJBool(true))
  if valid_580213 != nil:
    section.add "prettyPrint", valid_580213
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

proc call*(call_580215: Call_ContaineranalysisProjectsOperationsCreate_580199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Operation`.
  ## 
  let valid = call_580215.validator(path, query, header, formData, body)
  let scheme = call_580215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580215.url(scheme.get, call_580215.host, call_580215.base,
                         call_580215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580215, url, valid)

proc call*(call_580216: Call_ContaineranalysisProjectsOperationsCreate_580199;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsOperationsCreate
  ## Creates a new `Operation`.
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
  ##   parent: string (required)
  ##         : The project Id that this operation should be created under.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580217 = newJObject()
  var query_580218 = newJObject()
  var body_580219 = newJObject()
  add(query_580218, "upload_protocol", newJString(uploadProtocol))
  add(query_580218, "fields", newJString(fields))
  add(query_580218, "quotaUser", newJString(quotaUser))
  add(query_580218, "alt", newJString(alt))
  add(query_580218, "oauth_token", newJString(oauthToken))
  add(query_580218, "callback", newJString(callback))
  add(query_580218, "access_token", newJString(accessToken))
  add(query_580218, "uploadType", newJString(uploadType))
  add(path_580217, "parent", newJString(parent))
  add(query_580218, "key", newJString(key))
  add(query_580218, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580219 = body
  add(query_580218, "prettyPrint", newJBool(prettyPrint))
  result = call_580216.call(path_580217, query_580218, nil, nil, body_580219)

var containeranalysisProjectsOperationsCreate* = Call_ContaineranalysisProjectsOperationsCreate_580199(
    name: "containeranalysisProjectsOperationsCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/operations",
    validator: validate_ContaineranalysisProjectsOperationsCreate_580200,
    base: "/", url: url_ContaineranalysisProjectsOperationsCreate_580201,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsScanConfigsList_580220 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsScanConfigsList_580222(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/scanConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsScanConfigsList_580221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists scan configurations for a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This containers the project Id i.e.: projects/{project_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580223 = path.getOrDefault("parent")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "parent", valid_580223
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The page token to use for the next request.
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
  ##   pageSize: JInt
  ##           : The number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_580224 = query.getOrDefault("upload_protocol")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "upload_protocol", valid_580224
  var valid_580225 = query.getOrDefault("fields")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "fields", valid_580225
  var valid_580226 = query.getOrDefault("pageToken")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "pageToken", valid_580226
  var valid_580227 = query.getOrDefault("quotaUser")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "quotaUser", valid_580227
  var valid_580228 = query.getOrDefault("alt")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("json"))
  if valid_580228 != nil:
    section.add "alt", valid_580228
  var valid_580229 = query.getOrDefault("oauth_token")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "oauth_token", valid_580229
  var valid_580230 = query.getOrDefault("callback")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "callback", valid_580230
  var valid_580231 = query.getOrDefault("access_token")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "access_token", valid_580231
  var valid_580232 = query.getOrDefault("uploadType")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "uploadType", valid_580232
  var valid_580233 = query.getOrDefault("key")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "key", valid_580233
  var valid_580234 = query.getOrDefault("$.xgafv")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = newJString("1"))
  if valid_580234 != nil:
    section.add "$.xgafv", valid_580234
  var valid_580235 = query.getOrDefault("pageSize")
  valid_580235 = validateParameter(valid_580235, JInt, required = false, default = nil)
  if valid_580235 != nil:
    section.add "pageSize", valid_580235
  var valid_580236 = query.getOrDefault("prettyPrint")
  valid_580236 = validateParameter(valid_580236, JBool, required = false,
                                 default = newJBool(true))
  if valid_580236 != nil:
    section.add "prettyPrint", valid_580236
  var valid_580237 = query.getOrDefault("filter")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "filter", valid_580237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580238: Call_ContaineranalysisProjectsScanConfigsList_580220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists scan configurations for a project.
  ## 
  let valid = call_580238.validator(path, query, header, formData, body)
  let scheme = call_580238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580238.url(scheme.get, call_580238.host, call_580238.base,
                         call_580238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580238, url, valid)

proc call*(call_580239: Call_ContaineranalysisProjectsScanConfigsList_580220;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsScanConfigsList
  ## Lists scan configurations for a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The page token to use for the next request.
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
  ##   parent: string (required)
  ##         : This containers the project Id i.e.: projects/{project_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_580240 = newJObject()
  var query_580241 = newJObject()
  add(query_580241, "upload_protocol", newJString(uploadProtocol))
  add(query_580241, "fields", newJString(fields))
  add(query_580241, "pageToken", newJString(pageToken))
  add(query_580241, "quotaUser", newJString(quotaUser))
  add(query_580241, "alt", newJString(alt))
  add(query_580241, "oauth_token", newJString(oauthToken))
  add(query_580241, "callback", newJString(callback))
  add(query_580241, "access_token", newJString(accessToken))
  add(query_580241, "uploadType", newJString(uploadType))
  add(path_580240, "parent", newJString(parent))
  add(query_580241, "key", newJString(key))
  add(query_580241, "$.xgafv", newJString(Xgafv))
  add(query_580241, "pageSize", newJInt(pageSize))
  add(query_580241, "prettyPrint", newJBool(prettyPrint))
  add(query_580241, "filter", newJString(filter))
  result = call_580239.call(path_580240, query_580241, nil, nil, nil)

var containeranalysisProjectsScanConfigsList* = Call_ContaineranalysisProjectsScanConfigsList_580220(
    name: "containeranalysisProjectsScanConfigsList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/scanConfigs",
    validator: validate_ContaineranalysisProjectsScanConfigsList_580221,
    base: "/", url: url_ContaineranalysisProjectsScanConfigsList_580222,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesGetIamPolicy_580242 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsNotesGetIamPolicy_580244(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesGetIamPolicy_580243(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a note or an `Occurrence` resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## Attempting to call this method on a resource without the required
  ## permission will result in a `PERMISSION_DENIED` error. Attempting to call
  ## this method on a non-existent resource will result in a `NOT_FOUND` error
  ## if the user has list permission on the project, or a `PERMISSION_DENIED`
  ## error otherwise. The resource takes the following formats:
  ## `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for occurrences and
  ## projects/{PROJECT_ID}/notes/{NOTE_ID} for notes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580245 = path.getOrDefault("resource")
  valid_580245 = validateParameter(valid_580245, JString, required = true,
                                 default = nil)
  if valid_580245 != nil:
    section.add "resource", valid_580245
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
  var valid_580246 = query.getOrDefault("upload_protocol")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "upload_protocol", valid_580246
  var valid_580247 = query.getOrDefault("fields")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "fields", valid_580247
  var valid_580248 = query.getOrDefault("quotaUser")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "quotaUser", valid_580248
  var valid_580249 = query.getOrDefault("alt")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = newJString("json"))
  if valid_580249 != nil:
    section.add "alt", valid_580249
  var valid_580250 = query.getOrDefault("oauth_token")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "oauth_token", valid_580250
  var valid_580251 = query.getOrDefault("callback")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "callback", valid_580251
  var valid_580252 = query.getOrDefault("access_token")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "access_token", valid_580252
  var valid_580253 = query.getOrDefault("uploadType")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "uploadType", valid_580253
  var valid_580254 = query.getOrDefault("key")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "key", valid_580254
  var valid_580255 = query.getOrDefault("$.xgafv")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = newJString("1"))
  if valid_580255 != nil:
    section.add "$.xgafv", valid_580255
  var valid_580256 = query.getOrDefault("prettyPrint")
  valid_580256 = validateParameter(valid_580256, JBool, required = false,
                                 default = newJBool(true))
  if valid_580256 != nil:
    section.add "prettyPrint", valid_580256
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

proc call*(call_580258: Call_ContaineranalysisProjectsNotesGetIamPolicy_580242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a note or an `Occurrence` resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## Attempting to call this method on a resource without the required
  ## permission will result in a `PERMISSION_DENIED` error. Attempting to call
  ## this method on a non-existent resource will result in a `NOT_FOUND` error
  ## if the user has list permission on the project, or a `PERMISSION_DENIED`
  ## error otherwise. The resource takes the following formats:
  ## `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for occurrences and
  ## projects/{PROJECT_ID}/notes/{NOTE_ID} for notes
  ## 
  let valid = call_580258.validator(path, query, header, formData, body)
  let scheme = call_580258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580258.url(scheme.get, call_580258.host, call_580258.base,
                         call_580258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580258, url, valid)

proc call*(call_580259: Call_ContaineranalysisProjectsNotesGetIamPolicy_580242;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesGetIamPolicy
  ## Gets the access control policy for a note or an `Occurrence` resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## Attempting to call this method on a resource without the required
  ## permission will result in a `PERMISSION_DENIED` error. Attempting to call
  ## this method on a non-existent resource will result in a `NOT_FOUND` error
  ## if the user has list permission on the project, or a `PERMISSION_DENIED`
  ## error otherwise. The resource takes the following formats:
  ## `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for occurrences and
  ## projects/{PROJECT_ID}/notes/{NOTE_ID} for notes
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580260 = newJObject()
  var query_580261 = newJObject()
  var body_580262 = newJObject()
  add(query_580261, "upload_protocol", newJString(uploadProtocol))
  add(query_580261, "fields", newJString(fields))
  add(query_580261, "quotaUser", newJString(quotaUser))
  add(query_580261, "alt", newJString(alt))
  add(query_580261, "oauth_token", newJString(oauthToken))
  add(query_580261, "callback", newJString(callback))
  add(query_580261, "access_token", newJString(accessToken))
  add(query_580261, "uploadType", newJString(uploadType))
  add(query_580261, "key", newJString(key))
  add(query_580261, "$.xgafv", newJString(Xgafv))
  add(path_580260, "resource", newJString(resource))
  if body != nil:
    body_580262 = body
  add(query_580261, "prettyPrint", newJBool(prettyPrint))
  result = call_580259.call(path_580260, query_580261, nil, nil, body_580262)

var containeranalysisProjectsNotesGetIamPolicy* = Call_ContaineranalysisProjectsNotesGetIamPolicy_580242(
    name: "containeranalysisProjectsNotesGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_ContaineranalysisProjectsNotesGetIamPolicy_580243,
    base: "/", url: url_ContaineranalysisProjectsNotesGetIamPolicy_580244,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesSetIamPolicy_580263 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsNotesSetIamPolicy_580265(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesSetIamPolicy_580264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified `Note` or `Occurrence`.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a `Note` or an `Occurrence`, respectively.
  ## Attempting to call this method without these permissions will result in a `
  ## `PERMISSION_DENIED` error.
  ## Attempting to call this method on a non-existent resource will result in a
  ## `NOT_FOUND` error if the user has `containeranalysis.notes.list` permission
  ## on a `Note` or `containeranalysis.occurrences.list` on an `Occurrence`, or
  ## a `PERMISSION_DENIED` error otherwise. The resource takes the following
  ## formats: `projects/{projectid}/occurrences/{occurrenceid}` for occurrences
  ## and projects/{projectid}/notes/{noteid} for notes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580266 = path.getOrDefault("resource")
  valid_580266 = validateParameter(valid_580266, JString, required = true,
                                 default = nil)
  if valid_580266 != nil:
    section.add "resource", valid_580266
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
  var valid_580267 = query.getOrDefault("upload_protocol")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "upload_protocol", valid_580267
  var valid_580268 = query.getOrDefault("fields")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "fields", valid_580268
  var valid_580269 = query.getOrDefault("quotaUser")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "quotaUser", valid_580269
  var valid_580270 = query.getOrDefault("alt")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = newJString("json"))
  if valid_580270 != nil:
    section.add "alt", valid_580270
  var valid_580271 = query.getOrDefault("oauth_token")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "oauth_token", valid_580271
  var valid_580272 = query.getOrDefault("callback")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "callback", valid_580272
  var valid_580273 = query.getOrDefault("access_token")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "access_token", valid_580273
  var valid_580274 = query.getOrDefault("uploadType")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "uploadType", valid_580274
  var valid_580275 = query.getOrDefault("key")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "key", valid_580275
  var valid_580276 = query.getOrDefault("$.xgafv")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = newJString("1"))
  if valid_580276 != nil:
    section.add "$.xgafv", valid_580276
  var valid_580277 = query.getOrDefault("prettyPrint")
  valid_580277 = validateParameter(valid_580277, JBool, required = false,
                                 default = newJBool(true))
  if valid_580277 != nil:
    section.add "prettyPrint", valid_580277
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

proc call*(call_580279: Call_ContaineranalysisProjectsNotesSetIamPolicy_580263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified `Note` or `Occurrence`.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a `Note` or an `Occurrence`, respectively.
  ## Attempting to call this method without these permissions will result in a `
  ## `PERMISSION_DENIED` error.
  ## Attempting to call this method on a non-existent resource will result in a
  ## `NOT_FOUND` error if the user has `containeranalysis.notes.list` permission
  ## on a `Note` or `containeranalysis.occurrences.list` on an `Occurrence`, or
  ## a `PERMISSION_DENIED` error otherwise. The resource takes the following
  ## formats: `projects/{projectid}/occurrences/{occurrenceid}` for occurrences
  ## and projects/{projectid}/notes/{noteid} for notes
  ## 
  let valid = call_580279.validator(path, query, header, formData, body)
  let scheme = call_580279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580279.url(scheme.get, call_580279.host, call_580279.base,
                         call_580279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580279, url, valid)

proc call*(call_580280: Call_ContaineranalysisProjectsNotesSetIamPolicy_580263;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesSetIamPolicy
  ## Sets the access control policy on the specified `Note` or `Occurrence`.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a `Note` or an `Occurrence`, respectively.
  ## Attempting to call this method without these permissions will result in a `
  ## `PERMISSION_DENIED` error.
  ## Attempting to call this method on a non-existent resource will result in a
  ## `NOT_FOUND` error if the user has `containeranalysis.notes.list` permission
  ## on a `Note` or `containeranalysis.occurrences.list` on an `Occurrence`, or
  ## a `PERMISSION_DENIED` error otherwise. The resource takes the following
  ## formats: `projects/{projectid}/occurrences/{occurrenceid}` for occurrences
  ## and projects/{projectid}/notes/{noteid} for notes
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580281 = newJObject()
  var query_580282 = newJObject()
  var body_580283 = newJObject()
  add(query_580282, "upload_protocol", newJString(uploadProtocol))
  add(query_580282, "fields", newJString(fields))
  add(query_580282, "quotaUser", newJString(quotaUser))
  add(query_580282, "alt", newJString(alt))
  add(query_580282, "oauth_token", newJString(oauthToken))
  add(query_580282, "callback", newJString(callback))
  add(query_580282, "access_token", newJString(accessToken))
  add(query_580282, "uploadType", newJString(uploadType))
  add(query_580282, "key", newJString(key))
  add(query_580282, "$.xgafv", newJString(Xgafv))
  add(path_580281, "resource", newJString(resource))
  if body != nil:
    body_580283 = body
  add(query_580282, "prettyPrint", newJBool(prettyPrint))
  result = call_580280.call(path_580281, query_580282, nil, nil, body_580283)

var containeranalysisProjectsNotesSetIamPolicy* = Call_ContaineranalysisProjectsNotesSetIamPolicy_580263(
    name: "containeranalysisProjectsNotesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_ContaineranalysisProjectsNotesSetIamPolicy_580264,
    base: "/", url: url_ContaineranalysisProjectsNotesSetIamPolicy_580265,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesTestIamPermissions_580284 = ref object of OpenApiRestCall_579421
proc url_ContaineranalysisProjectsNotesTestIamPermissions_580286(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesTestIamPermissions_580285(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence resource. Requires list permission on the project (for example,
  ## "storage.objects.list" on the containing bucket for testing permission of
  ## an object). Attempting to call this method on a non-existent resource will
  ## result in a `NOT_FOUND` error if the user has list permission on the
  ## project, or a `PERMISSION_DENIED` error otherwise. The resource takes the
  ## following formats: `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for
  ## `Occurrences` and `projects/{PROJECT_ID}/notes/{NOTE_ID}` for `Notes`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580287 = path.getOrDefault("resource")
  valid_580287 = validateParameter(valid_580287, JString, required = true,
                                 default = nil)
  if valid_580287 != nil:
    section.add "resource", valid_580287
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
  var valid_580288 = query.getOrDefault("upload_protocol")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "upload_protocol", valid_580288
  var valid_580289 = query.getOrDefault("fields")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "fields", valid_580289
  var valid_580290 = query.getOrDefault("quotaUser")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "quotaUser", valid_580290
  var valid_580291 = query.getOrDefault("alt")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = newJString("json"))
  if valid_580291 != nil:
    section.add "alt", valid_580291
  var valid_580292 = query.getOrDefault("oauth_token")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "oauth_token", valid_580292
  var valid_580293 = query.getOrDefault("callback")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "callback", valid_580293
  var valid_580294 = query.getOrDefault("access_token")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "access_token", valid_580294
  var valid_580295 = query.getOrDefault("uploadType")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "uploadType", valid_580295
  var valid_580296 = query.getOrDefault("key")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "key", valid_580296
  var valid_580297 = query.getOrDefault("$.xgafv")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = newJString("1"))
  if valid_580297 != nil:
    section.add "$.xgafv", valid_580297
  var valid_580298 = query.getOrDefault("prettyPrint")
  valid_580298 = validateParameter(valid_580298, JBool, required = false,
                                 default = newJBool(true))
  if valid_580298 != nil:
    section.add "prettyPrint", valid_580298
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

proc call*(call_580300: Call_ContaineranalysisProjectsNotesTestIamPermissions_580284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence resource. Requires list permission on the project (for example,
  ## "storage.objects.list" on the containing bucket for testing permission of
  ## an object). Attempting to call this method on a non-existent resource will
  ## result in a `NOT_FOUND` error if the user has list permission on the
  ## project, or a `PERMISSION_DENIED` error otherwise. The resource takes the
  ## following formats: `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for
  ## `Occurrences` and `projects/{PROJECT_ID}/notes/{NOTE_ID}` for `Notes`
  ## 
  let valid = call_580300.validator(path, query, header, formData, body)
  let scheme = call_580300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580300.url(scheme.get, call_580300.host, call_580300.base,
                         call_580300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580300, url, valid)

proc call*(call_580301: Call_ContaineranalysisProjectsNotesTestIamPermissions_580284;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesTestIamPermissions
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence resource. Requires list permission on the project (for example,
  ## "storage.objects.list" on the containing bucket for testing permission of
  ## an object). Attempting to call this method on a non-existent resource will
  ## result in a `NOT_FOUND` error if the user has list permission on the
  ## project, or a `PERMISSION_DENIED` error otherwise. The resource takes the
  ## following formats: `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for
  ## `Occurrences` and `projects/{PROJECT_ID}/notes/{NOTE_ID}` for `Notes`
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580302 = newJObject()
  var query_580303 = newJObject()
  var body_580304 = newJObject()
  add(query_580303, "upload_protocol", newJString(uploadProtocol))
  add(query_580303, "fields", newJString(fields))
  add(query_580303, "quotaUser", newJString(quotaUser))
  add(query_580303, "alt", newJString(alt))
  add(query_580303, "oauth_token", newJString(oauthToken))
  add(query_580303, "callback", newJString(callback))
  add(query_580303, "access_token", newJString(accessToken))
  add(query_580303, "uploadType", newJString(uploadType))
  add(query_580303, "key", newJString(key))
  add(query_580303, "$.xgafv", newJString(Xgafv))
  add(path_580302, "resource", newJString(resource))
  if body != nil:
    body_580304 = body
  add(query_580303, "prettyPrint", newJBool(prettyPrint))
  result = call_580301.call(path_580302, query_580303, nil, nil, body_580304)

var containeranalysisProjectsNotesTestIamPermissions* = Call_ContaineranalysisProjectsNotesTestIamPermissions_580284(
    name: "containeranalysisProjectsNotesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_ContaineranalysisProjectsNotesTestIamPermissions_580285,
    base: "/", url: url_ContaineranalysisProjectsNotesTestIamPermissions_580286,
    schemes: {Scheme.Https})
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
