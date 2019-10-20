
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Container Analysis
## version: v1beta1
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
  gcpServiceName = "containeranalysis"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContaineranalysisProjectsScanConfigsUpdate_578907 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsScanConfigsUpdate_578909(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsScanConfigsUpdate_578908(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified scan configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the scan configuration in the form of
  ## `projects/[PROJECT_ID]/scanConfigs/[SCAN_CONFIG_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578910 = path.getOrDefault("name")
  valid_578910 = validateParameter(valid_578910, JString, required = true,
                                 default = nil)
  if valid_578910 != nil:
    section.add "name", valid_578910
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
  var valid_578911 = query.getOrDefault("key")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "key", valid_578911
  var valid_578912 = query.getOrDefault("prettyPrint")
  valid_578912 = validateParameter(valid_578912, JBool, required = false,
                                 default = newJBool(true))
  if valid_578912 != nil:
    section.add "prettyPrint", valid_578912
  var valid_578913 = query.getOrDefault("oauth_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "oauth_token", valid_578913
  var valid_578914 = query.getOrDefault("$.xgafv")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = newJString("1"))
  if valid_578914 != nil:
    section.add "$.xgafv", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("uploadType")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "uploadType", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("callback")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "callback", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
  var valid_578920 = query.getOrDefault("access_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "access_token", valid_578920
  var valid_578921 = query.getOrDefault("upload_protocol")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "upload_protocol", valid_578921
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

proc call*(call_578923: Call_ContaineranalysisProjectsScanConfigsUpdate_578907;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified scan configuration.
  ## 
  let valid = call_578923.validator(path, query, header, formData, body)
  let scheme = call_578923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578923.url(scheme.get, call_578923.host, call_578923.base,
                         call_578923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578923, url, valid)

proc call*(call_578924: Call_ContaineranalysisProjectsScanConfigsUpdate_578907;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsScanConfigsUpdate
  ## Updates the specified scan configuration.
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
  ##   name: string (required)
  ##       : The name of the scan configuration in the form of
  ## `projects/[PROJECT_ID]/scanConfigs/[SCAN_CONFIG_ID]`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578925 = newJObject()
  var query_578926 = newJObject()
  var body_578927 = newJObject()
  add(query_578926, "key", newJString(key))
  add(query_578926, "prettyPrint", newJBool(prettyPrint))
  add(query_578926, "oauth_token", newJString(oauthToken))
  add(query_578926, "$.xgafv", newJString(Xgafv))
  add(query_578926, "alt", newJString(alt))
  add(query_578926, "uploadType", newJString(uploadType))
  add(query_578926, "quotaUser", newJString(quotaUser))
  add(path_578925, "name", newJString(name))
  if body != nil:
    body_578927 = body
  add(query_578926, "callback", newJString(callback))
  add(query_578926, "fields", newJString(fields))
  add(query_578926, "access_token", newJString(accessToken))
  add(query_578926, "upload_protocol", newJString(uploadProtocol))
  result = call_578924.call(path_578925, query_578926, nil, nil, body_578927)

var containeranalysisProjectsScanConfigsUpdate* = Call_ContaineranalysisProjectsScanConfigsUpdate_578907(
    name: "containeranalysisProjectsScanConfigsUpdate", meth: HttpMethod.HttpPut,
    host: "containeranalysis.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ContaineranalysisProjectsScanConfigsUpdate_578908,
    base: "/", url: url_ContaineranalysisProjectsScanConfigsUpdate_578909,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsScanConfigsGet_578619 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsScanConfigsGet_578621(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsScanConfigsGet_578620(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified scan configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the scan configuration in the form of
  ## `projects/[PROJECT_ID]/scanConfigs/[SCAN_CONFIG_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578747 = path.getOrDefault("name")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "name", valid_578747
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
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("$.xgafv")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("1"))
  if valid_578764 != nil:
    section.add "$.xgafv", valid_578764
  var valid_578765 = query.getOrDefault("alt")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("json"))
  if valid_578765 != nil:
    section.add "alt", valid_578765
  var valid_578766 = query.getOrDefault("uploadType")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "uploadType", valid_578766
  var valid_578767 = query.getOrDefault("quotaUser")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "quotaUser", valid_578767
  var valid_578768 = query.getOrDefault("callback")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "callback", valid_578768
  var valid_578769 = query.getOrDefault("fields")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "fields", valid_578769
  var valid_578770 = query.getOrDefault("access_token")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "access_token", valid_578770
  var valid_578771 = query.getOrDefault("upload_protocol")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "upload_protocol", valid_578771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578794: Call_ContaineranalysisProjectsScanConfigsGet_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified scan configuration.
  ## 
  let valid = call_578794.validator(path, query, header, formData, body)
  let scheme = call_578794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578794.url(scheme.get, call_578794.host, call_578794.base,
                         call_578794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578794, url, valid)

proc call*(call_578865: Call_ContaineranalysisProjectsScanConfigsGet_578619;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsScanConfigsGet
  ## Gets the specified scan configuration.
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
  ##   name: string (required)
  ##       : The name of the scan configuration in the form of
  ## `projects/[PROJECT_ID]/scanConfigs/[SCAN_CONFIG_ID]`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578866 = newJObject()
  var query_578868 = newJObject()
  add(query_578868, "key", newJString(key))
  add(query_578868, "prettyPrint", newJBool(prettyPrint))
  add(query_578868, "oauth_token", newJString(oauthToken))
  add(query_578868, "$.xgafv", newJString(Xgafv))
  add(query_578868, "alt", newJString(alt))
  add(query_578868, "uploadType", newJString(uploadType))
  add(query_578868, "quotaUser", newJString(quotaUser))
  add(path_578866, "name", newJString(name))
  add(query_578868, "callback", newJString(callback))
  add(query_578868, "fields", newJString(fields))
  add(query_578868, "access_token", newJString(accessToken))
  add(query_578868, "upload_protocol", newJString(uploadProtocol))
  result = call_578865.call(path_578866, query_578868, nil, nil, nil)

var containeranalysisProjectsScanConfigsGet* = Call_ContaineranalysisProjectsScanConfigsGet_578619(
    name: "containeranalysisProjectsScanConfigsGet", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ContaineranalysisProjectsScanConfigsGet_578620, base: "/",
    url: url_ContaineranalysisProjectsScanConfigsGet_578621,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesPatch_578947 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsNotesPatch_578949(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesPatch_578948(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified note.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note in the form of
  ## `projects/[PROVIDER_ID]/notes/[NOTE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578950 = path.getOrDefault("name")
  valid_578950 = validateParameter(valid_578950, JString, required = true,
                                 default = nil)
  if valid_578950 != nil:
    section.add "name", valid_578950
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
  ##   updateMask: JString
  ##             : The fields to update.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578951 = query.getOrDefault("key")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "key", valid_578951
  var valid_578952 = query.getOrDefault("prettyPrint")
  valid_578952 = validateParameter(valid_578952, JBool, required = false,
                                 default = newJBool(true))
  if valid_578952 != nil:
    section.add "prettyPrint", valid_578952
  var valid_578953 = query.getOrDefault("oauth_token")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "oauth_token", valid_578953
  var valid_578954 = query.getOrDefault("$.xgafv")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = newJString("1"))
  if valid_578954 != nil:
    section.add "$.xgafv", valid_578954
  var valid_578955 = query.getOrDefault("alt")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("json"))
  if valid_578955 != nil:
    section.add "alt", valid_578955
  var valid_578956 = query.getOrDefault("uploadType")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "uploadType", valid_578956
  var valid_578957 = query.getOrDefault("quotaUser")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "quotaUser", valid_578957
  var valid_578958 = query.getOrDefault("updateMask")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "updateMask", valid_578958
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

proc call*(call_578964: Call_ContaineranalysisProjectsNotesPatch_578947;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified note.
  ## 
  let valid = call_578964.validator(path, query, header, formData, body)
  let scheme = call_578964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578964.url(scheme.get, call_578964.host, call_578964.base,
                         call_578964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578964, url, valid)

proc call*(call_578965: Call_ContaineranalysisProjectsNotesPatch_578947;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsNotesPatch
  ## Updates the specified note.
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
  ##   name: string (required)
  ##       : The name of the note in the form of
  ## `projects/[PROVIDER_ID]/notes/[NOTE_ID]`.
  ##   updateMask: string
  ##             : The fields to update.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
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
  add(path_578966, "name", newJString(name))
  add(query_578967, "updateMask", newJString(updateMask))
  if body != nil:
    body_578968 = body
  add(query_578967, "callback", newJString(callback))
  add(query_578967, "fields", newJString(fields))
  add(query_578967, "access_token", newJString(accessToken))
  add(query_578967, "upload_protocol", newJString(uploadProtocol))
  result = call_578965.call(path_578966, query_578967, nil, nil, body_578968)

var containeranalysisProjectsNotesPatch* = Call_ContaineranalysisProjectsNotesPatch_578947(
    name: "containeranalysisProjectsNotesPatch", meth: HttpMethod.HttpPatch,
    host: "containeranalysis.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ContaineranalysisProjectsNotesPatch_578948, base: "/",
    url: url_ContaineranalysisProjectsNotesPatch_578949, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesDelete_578928 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsNotesDelete_578930(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesDelete_578929(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified note.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note in the form of
  ## `projects/[PROVIDER_ID]/notes/[NOTE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578931 = path.getOrDefault("name")
  valid_578931 = validateParameter(valid_578931, JString, required = true,
                                 default = nil)
  if valid_578931 != nil:
    section.add "name", valid_578931
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
  var valid_578932 = query.getOrDefault("key")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "key", valid_578932
  var valid_578933 = query.getOrDefault("prettyPrint")
  valid_578933 = validateParameter(valid_578933, JBool, required = false,
                                 default = newJBool(true))
  if valid_578933 != nil:
    section.add "prettyPrint", valid_578933
  var valid_578934 = query.getOrDefault("oauth_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "oauth_token", valid_578934
  var valid_578935 = query.getOrDefault("$.xgafv")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = newJString("1"))
  if valid_578935 != nil:
    section.add "$.xgafv", valid_578935
  var valid_578936 = query.getOrDefault("alt")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("json"))
  if valid_578936 != nil:
    section.add "alt", valid_578936
  var valid_578937 = query.getOrDefault("uploadType")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "uploadType", valid_578937
  var valid_578938 = query.getOrDefault("quotaUser")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "quotaUser", valid_578938
  var valid_578939 = query.getOrDefault("callback")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "callback", valid_578939
  var valid_578940 = query.getOrDefault("fields")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "fields", valid_578940
  var valid_578941 = query.getOrDefault("access_token")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "access_token", valid_578941
  var valid_578942 = query.getOrDefault("upload_protocol")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "upload_protocol", valid_578942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578943: Call_ContaineranalysisProjectsNotesDelete_578928;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified note.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_ContaineranalysisProjectsNotesDelete_578928;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsNotesDelete
  ## Deletes the specified note.
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
  ##   name: string (required)
  ##       : The name of the note in the form of
  ## `projects/[PROVIDER_ID]/notes/[NOTE_ID]`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578945 = newJObject()
  var query_578946 = newJObject()
  add(query_578946, "key", newJString(key))
  add(query_578946, "prettyPrint", newJBool(prettyPrint))
  add(query_578946, "oauth_token", newJString(oauthToken))
  add(query_578946, "$.xgafv", newJString(Xgafv))
  add(query_578946, "alt", newJString(alt))
  add(query_578946, "uploadType", newJString(uploadType))
  add(query_578946, "quotaUser", newJString(quotaUser))
  add(path_578945, "name", newJString(name))
  add(query_578946, "callback", newJString(callback))
  add(query_578946, "fields", newJString(fields))
  add(query_578946, "access_token", newJString(accessToken))
  add(query_578946, "upload_protocol", newJString(uploadProtocol))
  result = call_578944.call(path_578945, query_578946, nil, nil, nil)

var containeranalysisProjectsNotesDelete* = Call_ContaineranalysisProjectsNotesDelete_578928(
    name: "containeranalysisProjectsNotesDelete", meth: HttpMethod.HttpDelete,
    host: "containeranalysis.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ContaineranalysisProjectsNotesDelete_578929, base: "/",
    url: url_ContaineranalysisProjectsNotesDelete_578930, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesGetNotes_578969 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsOccurrencesGetNotes_578971(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesGetNotes_578970(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the note attached to the specified occurrence. Consumer projects can
  ## use this method to get a note that belongs to a provider project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the occurrence in the form of
  ## `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578972 = path.getOrDefault("name")
  valid_578972 = validateParameter(valid_578972, JString, required = true,
                                 default = nil)
  if valid_578972 != nil:
    section.add "name", valid_578972
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
  var valid_578973 = query.getOrDefault("key")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "key", valid_578973
  var valid_578974 = query.getOrDefault("prettyPrint")
  valid_578974 = validateParameter(valid_578974, JBool, required = false,
                                 default = newJBool(true))
  if valid_578974 != nil:
    section.add "prettyPrint", valid_578974
  var valid_578975 = query.getOrDefault("oauth_token")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "oauth_token", valid_578975
  var valid_578976 = query.getOrDefault("$.xgafv")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = newJString("1"))
  if valid_578976 != nil:
    section.add "$.xgafv", valid_578976
  var valid_578977 = query.getOrDefault("alt")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("json"))
  if valid_578977 != nil:
    section.add "alt", valid_578977
  var valid_578978 = query.getOrDefault("uploadType")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "uploadType", valid_578978
  var valid_578979 = query.getOrDefault("quotaUser")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "quotaUser", valid_578979
  var valid_578980 = query.getOrDefault("callback")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "callback", valid_578980
  var valid_578981 = query.getOrDefault("fields")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "fields", valid_578981
  var valid_578982 = query.getOrDefault("access_token")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "access_token", valid_578982
  var valid_578983 = query.getOrDefault("upload_protocol")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "upload_protocol", valid_578983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578984: Call_ContaineranalysisProjectsOccurrencesGetNotes_578969;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the note attached to the specified occurrence. Consumer projects can
  ## use this method to get a note that belongs to a provider project.
  ## 
  let valid = call_578984.validator(path, query, header, formData, body)
  let scheme = call_578984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578984.url(scheme.get, call_578984.host, call_578984.base,
                         call_578984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578984, url, valid)

proc call*(call_578985: Call_ContaineranalysisProjectsOccurrencesGetNotes_578969;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesGetNotes
  ## Gets the note attached to the specified occurrence. Consumer projects can
  ## use this method to get a note that belongs to a provider project.
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
  ##   name: string (required)
  ##       : The name of the occurrence in the form of
  ## `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578986 = newJObject()
  var query_578987 = newJObject()
  add(query_578987, "key", newJString(key))
  add(query_578987, "prettyPrint", newJBool(prettyPrint))
  add(query_578987, "oauth_token", newJString(oauthToken))
  add(query_578987, "$.xgafv", newJString(Xgafv))
  add(query_578987, "alt", newJString(alt))
  add(query_578987, "uploadType", newJString(uploadType))
  add(query_578987, "quotaUser", newJString(quotaUser))
  add(path_578986, "name", newJString(name))
  add(query_578987, "callback", newJString(callback))
  add(query_578987, "fields", newJString(fields))
  add(query_578987, "access_token", newJString(accessToken))
  add(query_578987, "upload_protocol", newJString(uploadProtocol))
  result = call_578985.call(path_578986, query_578987, nil, nil, nil)

var containeranalysisProjectsOccurrencesGetNotes* = Call_ContaineranalysisProjectsOccurrencesGetNotes_578969(
    name: "containeranalysisProjectsOccurrencesGetNotes",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{name}/notes",
    validator: validate_ContaineranalysisProjectsOccurrencesGetNotes_578970,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesGetNotes_578971,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesOccurrencesList_578988 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsNotesOccurrencesList_578990(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesOccurrencesList_578989(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists occurrences referencing the specified note. Provider projects can use
  ## this method to get all occurrences across consumer projects referencing the
  ## specified note.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note to list occurrences for in the form of
  ## `projects/[PROVIDER_ID]/notes/[NOTE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578991 = path.getOrDefault("name")
  valid_578991 = validateParameter(valid_578991, JString, required = true,
                                 default = nil)
  if valid_578991 != nil:
    section.add "name", valid_578991
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
  ##   pageSize: JInt
  ##           : Number of occurrences to return in the list.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter expression.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578992 = query.getOrDefault("key")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "key", valid_578992
  var valid_578993 = query.getOrDefault("prettyPrint")
  valid_578993 = validateParameter(valid_578993, JBool, required = false,
                                 default = newJBool(true))
  if valid_578993 != nil:
    section.add "prettyPrint", valid_578993
  var valid_578994 = query.getOrDefault("oauth_token")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "oauth_token", valid_578994
  var valid_578995 = query.getOrDefault("$.xgafv")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("1"))
  if valid_578995 != nil:
    section.add "$.xgafv", valid_578995
  var valid_578996 = query.getOrDefault("pageSize")
  valid_578996 = validateParameter(valid_578996, JInt, required = false, default = nil)
  if valid_578996 != nil:
    section.add "pageSize", valid_578996
  var valid_578997 = query.getOrDefault("alt")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = newJString("json"))
  if valid_578997 != nil:
    section.add "alt", valid_578997
  var valid_578998 = query.getOrDefault("uploadType")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "uploadType", valid_578998
  var valid_578999 = query.getOrDefault("quotaUser")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "quotaUser", valid_578999
  var valid_579000 = query.getOrDefault("filter")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "filter", valid_579000
  var valid_579001 = query.getOrDefault("pageToken")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "pageToken", valid_579001
  var valid_579002 = query.getOrDefault("callback")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "callback", valid_579002
  var valid_579003 = query.getOrDefault("fields")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "fields", valid_579003
  var valid_579004 = query.getOrDefault("access_token")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "access_token", valid_579004
  var valid_579005 = query.getOrDefault("upload_protocol")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "upload_protocol", valid_579005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579006: Call_ContaineranalysisProjectsNotesOccurrencesList_578988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists occurrences referencing the specified note. Provider projects can use
  ## this method to get all occurrences across consumer projects referencing the
  ## specified note.
  ## 
  let valid = call_579006.validator(path, query, header, formData, body)
  let scheme = call_579006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579006.url(scheme.get, call_579006.host, call_579006.base,
                         call_579006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579006, url, valid)

proc call*(call_579007: Call_ContaineranalysisProjectsNotesOccurrencesList_578988;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsNotesOccurrencesList
  ## Lists occurrences referencing the specified note. Provider projects can use
  ## this method to get all occurrences across consumer projects referencing the
  ## specified note.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of occurrences to return in the list.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the note to list occurrences for in the form of
  ## `projects/[PROVIDER_ID]/notes/[NOTE_ID]`.
  ##   filter: string
  ##         : The filter expression.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579008 = newJObject()
  var query_579009 = newJObject()
  add(query_579009, "key", newJString(key))
  add(query_579009, "prettyPrint", newJBool(prettyPrint))
  add(query_579009, "oauth_token", newJString(oauthToken))
  add(query_579009, "$.xgafv", newJString(Xgafv))
  add(query_579009, "pageSize", newJInt(pageSize))
  add(query_579009, "alt", newJString(alt))
  add(query_579009, "uploadType", newJString(uploadType))
  add(query_579009, "quotaUser", newJString(quotaUser))
  add(path_579008, "name", newJString(name))
  add(query_579009, "filter", newJString(filter))
  add(query_579009, "pageToken", newJString(pageToken))
  add(query_579009, "callback", newJString(callback))
  add(query_579009, "fields", newJString(fields))
  add(query_579009, "access_token", newJString(accessToken))
  add(query_579009, "upload_protocol", newJString(uploadProtocol))
  result = call_579007.call(path_579008, query_579009, nil, nil, nil)

var containeranalysisProjectsNotesOccurrencesList* = Call_ContaineranalysisProjectsNotesOccurrencesList_578988(
    name: "containeranalysisProjectsNotesOccurrencesList",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{name}/occurrences",
    validator: validate_ContaineranalysisProjectsNotesOccurrencesList_578989,
    base: "/", url: url_ContaineranalysisProjectsNotesOccurrencesList_578990,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesCreate_579032 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsNotesCreate_579034(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesCreate_579033(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new note.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the note is to be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579035 = path.getOrDefault("parent")
  valid_579035 = validateParameter(valid_579035, JString, required = true,
                                 default = nil)
  if valid_579035 != nil:
    section.add "parent", valid_579035
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
  ##   noteId: JString
  ##         : The ID to use for this note.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579036 = query.getOrDefault("key")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "key", valid_579036
  var valid_579037 = query.getOrDefault("prettyPrint")
  valid_579037 = validateParameter(valid_579037, JBool, required = false,
                                 default = newJBool(true))
  if valid_579037 != nil:
    section.add "prettyPrint", valid_579037
  var valid_579038 = query.getOrDefault("oauth_token")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "oauth_token", valid_579038
  var valid_579039 = query.getOrDefault("$.xgafv")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = newJString("1"))
  if valid_579039 != nil:
    section.add "$.xgafv", valid_579039
  var valid_579040 = query.getOrDefault("alt")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("json"))
  if valid_579040 != nil:
    section.add "alt", valid_579040
  var valid_579041 = query.getOrDefault("uploadType")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "uploadType", valid_579041
  var valid_579042 = query.getOrDefault("quotaUser")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "quotaUser", valid_579042
  var valid_579043 = query.getOrDefault("noteId")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "noteId", valid_579043
  var valid_579044 = query.getOrDefault("callback")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "callback", valid_579044
  var valid_579045 = query.getOrDefault("fields")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "fields", valid_579045
  var valid_579046 = query.getOrDefault("access_token")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "access_token", valid_579046
  var valid_579047 = query.getOrDefault("upload_protocol")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "upload_protocol", valid_579047
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

proc call*(call_579049: Call_ContaineranalysisProjectsNotesCreate_579032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new note.
  ## 
  let valid = call_579049.validator(path, query, header, formData, body)
  let scheme = call_579049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579049.url(scheme.get, call_579049.host, call_579049.base,
                         call_579049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579049, url, valid)

proc call*(call_579050: Call_ContaineranalysisProjectsNotesCreate_579032;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; noteId: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsNotesCreate
  ## Creates a new note.
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
  ##   noteId: string
  ##         : The ID to use for this note.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the note is to be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579051 = newJObject()
  var query_579052 = newJObject()
  var body_579053 = newJObject()
  add(query_579052, "key", newJString(key))
  add(query_579052, "prettyPrint", newJBool(prettyPrint))
  add(query_579052, "oauth_token", newJString(oauthToken))
  add(query_579052, "$.xgafv", newJString(Xgafv))
  add(query_579052, "alt", newJString(alt))
  add(query_579052, "uploadType", newJString(uploadType))
  add(query_579052, "quotaUser", newJString(quotaUser))
  add(query_579052, "noteId", newJString(noteId))
  if body != nil:
    body_579053 = body
  add(query_579052, "callback", newJString(callback))
  add(path_579051, "parent", newJString(parent))
  add(query_579052, "fields", newJString(fields))
  add(query_579052, "access_token", newJString(accessToken))
  add(query_579052, "upload_protocol", newJString(uploadProtocol))
  result = call_579050.call(path_579051, query_579052, nil, nil, body_579053)

var containeranalysisProjectsNotesCreate* = Call_ContaineranalysisProjectsNotesCreate_579032(
    name: "containeranalysisProjectsNotesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com", route: "/v1beta1/{parent}/notes",
    validator: validate_ContaineranalysisProjectsNotesCreate_579033, base: "/",
    url: url_ContaineranalysisProjectsNotesCreate_579034, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesList_579010 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsNotesList_579012(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesList_579011(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists notes for the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project to list notes for in the form of
  ## `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579013 = path.getOrDefault("parent")
  valid_579013 = validateParameter(valid_579013, JString, required = true,
                                 default = nil)
  if valid_579013 != nil:
    section.add "parent", valid_579013
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
  ##   pageSize: JInt
  ##           : Number of notes to return in the list. Must be positive. Max allowed page
  ## size is 1000. If not specified, page size defaults to 20.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter expression.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579014 = query.getOrDefault("key")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "key", valid_579014
  var valid_579015 = query.getOrDefault("prettyPrint")
  valid_579015 = validateParameter(valid_579015, JBool, required = false,
                                 default = newJBool(true))
  if valid_579015 != nil:
    section.add "prettyPrint", valid_579015
  var valid_579016 = query.getOrDefault("oauth_token")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "oauth_token", valid_579016
  var valid_579017 = query.getOrDefault("$.xgafv")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = newJString("1"))
  if valid_579017 != nil:
    section.add "$.xgafv", valid_579017
  var valid_579018 = query.getOrDefault("pageSize")
  valid_579018 = validateParameter(valid_579018, JInt, required = false, default = nil)
  if valid_579018 != nil:
    section.add "pageSize", valid_579018
  var valid_579019 = query.getOrDefault("alt")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = newJString("json"))
  if valid_579019 != nil:
    section.add "alt", valid_579019
  var valid_579020 = query.getOrDefault("uploadType")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "uploadType", valid_579020
  var valid_579021 = query.getOrDefault("quotaUser")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "quotaUser", valid_579021
  var valid_579022 = query.getOrDefault("filter")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "filter", valid_579022
  var valid_579023 = query.getOrDefault("pageToken")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "pageToken", valid_579023
  var valid_579024 = query.getOrDefault("callback")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "callback", valid_579024
  var valid_579025 = query.getOrDefault("fields")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "fields", valid_579025
  var valid_579026 = query.getOrDefault("access_token")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "access_token", valid_579026
  var valid_579027 = query.getOrDefault("upload_protocol")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "upload_protocol", valid_579027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579028: Call_ContaineranalysisProjectsNotesList_579010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists notes for the specified project.
  ## 
  let valid = call_579028.validator(path, query, header, formData, body)
  let scheme = call_579028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579028.url(scheme.get, call_579028.host, call_579028.base,
                         call_579028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579028, url, valid)

proc call*(call_579029: Call_ContaineranalysisProjectsNotesList_579010;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsNotesList
  ## Lists notes for the specified project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of notes to return in the list. Must be positive. Max allowed page
  ## size is 1000. If not specified, page size defaults to 20.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The filter expression.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the project to list notes for in the form of
  ## `projects/[PROJECT_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579030 = newJObject()
  var query_579031 = newJObject()
  add(query_579031, "key", newJString(key))
  add(query_579031, "prettyPrint", newJBool(prettyPrint))
  add(query_579031, "oauth_token", newJString(oauthToken))
  add(query_579031, "$.xgafv", newJString(Xgafv))
  add(query_579031, "pageSize", newJInt(pageSize))
  add(query_579031, "alt", newJString(alt))
  add(query_579031, "uploadType", newJString(uploadType))
  add(query_579031, "quotaUser", newJString(quotaUser))
  add(query_579031, "filter", newJString(filter))
  add(query_579031, "pageToken", newJString(pageToken))
  add(query_579031, "callback", newJString(callback))
  add(path_579030, "parent", newJString(parent))
  add(query_579031, "fields", newJString(fields))
  add(query_579031, "access_token", newJString(accessToken))
  add(query_579031, "upload_protocol", newJString(uploadProtocol))
  result = call_579029.call(path_579030, query_579031, nil, nil, nil)

var containeranalysisProjectsNotesList* = Call_ContaineranalysisProjectsNotesList_579010(
    name: "containeranalysisProjectsNotesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1beta1/{parent}/notes",
    validator: validate_ContaineranalysisProjectsNotesList_579011, base: "/",
    url: url_ContaineranalysisProjectsNotesList_579012, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesBatchCreate_579054 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsNotesBatchCreate_579056(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes:batchCreate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesBatchCreate_579055(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates new notes in batch.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the notes are to be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579057 = path.getOrDefault("parent")
  valid_579057 = validateParameter(valid_579057, JString, required = true,
                                 default = nil)
  if valid_579057 != nil:
    section.add "parent", valid_579057
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
  var valid_579058 = query.getOrDefault("key")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "key", valid_579058
  var valid_579059 = query.getOrDefault("prettyPrint")
  valid_579059 = validateParameter(valid_579059, JBool, required = false,
                                 default = newJBool(true))
  if valid_579059 != nil:
    section.add "prettyPrint", valid_579059
  var valid_579060 = query.getOrDefault("oauth_token")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "oauth_token", valid_579060
  var valid_579061 = query.getOrDefault("$.xgafv")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = newJString("1"))
  if valid_579061 != nil:
    section.add "$.xgafv", valid_579061
  var valid_579062 = query.getOrDefault("alt")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = newJString("json"))
  if valid_579062 != nil:
    section.add "alt", valid_579062
  var valid_579063 = query.getOrDefault("uploadType")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "uploadType", valid_579063
  var valid_579064 = query.getOrDefault("quotaUser")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "quotaUser", valid_579064
  var valid_579065 = query.getOrDefault("callback")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "callback", valid_579065
  var valid_579066 = query.getOrDefault("fields")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "fields", valid_579066
  var valid_579067 = query.getOrDefault("access_token")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "access_token", valid_579067
  var valid_579068 = query.getOrDefault("upload_protocol")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "upload_protocol", valid_579068
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

proc call*(call_579070: Call_ContaineranalysisProjectsNotesBatchCreate_579054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new notes in batch.
  ## 
  let valid = call_579070.validator(path, query, header, formData, body)
  let scheme = call_579070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579070.url(scheme.get, call_579070.host, call_579070.base,
                         call_579070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579070, url, valid)

proc call*(call_579071: Call_ContaineranalysisProjectsNotesBatchCreate_579054;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsNotesBatchCreate
  ## Creates new notes in batch.
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
  ##   parent: string (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the notes are to be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579072 = newJObject()
  var query_579073 = newJObject()
  var body_579074 = newJObject()
  add(query_579073, "key", newJString(key))
  add(query_579073, "prettyPrint", newJBool(prettyPrint))
  add(query_579073, "oauth_token", newJString(oauthToken))
  add(query_579073, "$.xgafv", newJString(Xgafv))
  add(query_579073, "alt", newJString(alt))
  add(query_579073, "uploadType", newJString(uploadType))
  add(query_579073, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579074 = body
  add(query_579073, "callback", newJString(callback))
  add(path_579072, "parent", newJString(parent))
  add(query_579073, "fields", newJString(fields))
  add(query_579073, "access_token", newJString(accessToken))
  add(query_579073, "upload_protocol", newJString(uploadProtocol))
  result = call_579071.call(path_579072, query_579073, nil, nil, body_579074)

var containeranalysisProjectsNotesBatchCreate* = Call_ContaineranalysisProjectsNotesBatchCreate_579054(
    name: "containeranalysisProjectsNotesBatchCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{parent}/notes:batchCreate",
    validator: validate_ContaineranalysisProjectsNotesBatchCreate_579055,
    base: "/", url: url_ContaineranalysisProjectsNotesBatchCreate_579056,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesCreate_579097 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsOccurrencesCreate_579099(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesCreate_579098(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new occurrence.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the occurrence is to be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579100 = path.getOrDefault("parent")
  valid_579100 = validateParameter(valid_579100, JString, required = true,
                                 default = nil)
  if valid_579100 != nil:
    section.add "parent", valid_579100
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
  var valid_579101 = query.getOrDefault("key")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "key", valid_579101
  var valid_579102 = query.getOrDefault("prettyPrint")
  valid_579102 = validateParameter(valid_579102, JBool, required = false,
                                 default = newJBool(true))
  if valid_579102 != nil:
    section.add "prettyPrint", valid_579102
  var valid_579103 = query.getOrDefault("oauth_token")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "oauth_token", valid_579103
  var valid_579104 = query.getOrDefault("$.xgafv")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = newJString("1"))
  if valid_579104 != nil:
    section.add "$.xgafv", valid_579104
  var valid_579105 = query.getOrDefault("alt")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = newJString("json"))
  if valid_579105 != nil:
    section.add "alt", valid_579105
  var valid_579106 = query.getOrDefault("uploadType")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "uploadType", valid_579106
  var valid_579107 = query.getOrDefault("quotaUser")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "quotaUser", valid_579107
  var valid_579108 = query.getOrDefault("callback")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "callback", valid_579108
  var valid_579109 = query.getOrDefault("fields")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "fields", valid_579109
  var valid_579110 = query.getOrDefault("access_token")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "access_token", valid_579110
  var valid_579111 = query.getOrDefault("upload_protocol")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "upload_protocol", valid_579111
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

proc call*(call_579113: Call_ContaineranalysisProjectsOccurrencesCreate_579097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new occurrence.
  ## 
  let valid = call_579113.validator(path, query, header, formData, body)
  let scheme = call_579113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579113.url(scheme.get, call_579113.host, call_579113.base,
                         call_579113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579113, url, valid)

proc call*(call_579114: Call_ContaineranalysisProjectsOccurrencesCreate_579097;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesCreate
  ## Creates a new occurrence.
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
  ##   parent: string (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the occurrence is to be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579115 = newJObject()
  var query_579116 = newJObject()
  var body_579117 = newJObject()
  add(query_579116, "key", newJString(key))
  add(query_579116, "prettyPrint", newJBool(prettyPrint))
  add(query_579116, "oauth_token", newJString(oauthToken))
  add(query_579116, "$.xgafv", newJString(Xgafv))
  add(query_579116, "alt", newJString(alt))
  add(query_579116, "uploadType", newJString(uploadType))
  add(query_579116, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579117 = body
  add(query_579116, "callback", newJString(callback))
  add(path_579115, "parent", newJString(parent))
  add(query_579116, "fields", newJString(fields))
  add(query_579116, "access_token", newJString(accessToken))
  add(query_579116, "upload_protocol", newJString(uploadProtocol))
  result = call_579114.call(path_579115, query_579116, nil, nil, body_579117)

var containeranalysisProjectsOccurrencesCreate* = Call_ContaineranalysisProjectsOccurrencesCreate_579097(
    name: "containeranalysisProjectsOccurrencesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{parent}/occurrences",
    validator: validate_ContaineranalysisProjectsOccurrencesCreate_579098,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesCreate_579099,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesList_579075 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsOccurrencesList_579077(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesList_579076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists occurrences for the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project to list occurrences for in the form of
  ## `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579078 = path.getOrDefault("parent")
  valid_579078 = validateParameter(valid_579078, JString, required = true,
                                 default = nil)
  if valid_579078 != nil:
    section.add "parent", valid_579078
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
  ##   pageSize: JInt
  ##           : Number of occurrences to return in the list. Must be positive. Max allowed
  ## page size is 1000. If not specified, page size defaults to 20.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter expression.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579079 = query.getOrDefault("key")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "key", valid_579079
  var valid_579080 = query.getOrDefault("prettyPrint")
  valid_579080 = validateParameter(valid_579080, JBool, required = false,
                                 default = newJBool(true))
  if valid_579080 != nil:
    section.add "prettyPrint", valid_579080
  var valid_579081 = query.getOrDefault("oauth_token")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "oauth_token", valid_579081
  var valid_579082 = query.getOrDefault("$.xgafv")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = newJString("1"))
  if valid_579082 != nil:
    section.add "$.xgafv", valid_579082
  var valid_579083 = query.getOrDefault("pageSize")
  valid_579083 = validateParameter(valid_579083, JInt, required = false, default = nil)
  if valid_579083 != nil:
    section.add "pageSize", valid_579083
  var valid_579084 = query.getOrDefault("alt")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = newJString("json"))
  if valid_579084 != nil:
    section.add "alt", valid_579084
  var valid_579085 = query.getOrDefault("uploadType")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "uploadType", valid_579085
  var valid_579086 = query.getOrDefault("quotaUser")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "quotaUser", valid_579086
  var valid_579087 = query.getOrDefault("filter")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "filter", valid_579087
  var valid_579088 = query.getOrDefault("pageToken")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "pageToken", valid_579088
  var valid_579089 = query.getOrDefault("callback")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "callback", valid_579089
  var valid_579090 = query.getOrDefault("fields")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "fields", valid_579090
  var valid_579091 = query.getOrDefault("access_token")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "access_token", valid_579091
  var valid_579092 = query.getOrDefault("upload_protocol")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "upload_protocol", valid_579092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579093: Call_ContaineranalysisProjectsOccurrencesList_579075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists occurrences for the specified project.
  ## 
  let valid = call_579093.validator(path, query, header, formData, body)
  let scheme = call_579093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579093.url(scheme.get, call_579093.host, call_579093.base,
                         call_579093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579093, url, valid)

proc call*(call_579094: Call_ContaineranalysisProjectsOccurrencesList_579075;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesList
  ## Lists occurrences for the specified project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of occurrences to return in the list. Must be positive. Max allowed
  ## page size is 1000. If not specified, page size defaults to 20.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The filter expression.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the project to list occurrences for in the form of
  ## `projects/[PROJECT_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579095 = newJObject()
  var query_579096 = newJObject()
  add(query_579096, "key", newJString(key))
  add(query_579096, "prettyPrint", newJBool(prettyPrint))
  add(query_579096, "oauth_token", newJString(oauthToken))
  add(query_579096, "$.xgafv", newJString(Xgafv))
  add(query_579096, "pageSize", newJInt(pageSize))
  add(query_579096, "alt", newJString(alt))
  add(query_579096, "uploadType", newJString(uploadType))
  add(query_579096, "quotaUser", newJString(quotaUser))
  add(query_579096, "filter", newJString(filter))
  add(query_579096, "pageToken", newJString(pageToken))
  add(query_579096, "callback", newJString(callback))
  add(path_579095, "parent", newJString(parent))
  add(query_579096, "fields", newJString(fields))
  add(query_579096, "access_token", newJString(accessToken))
  add(query_579096, "upload_protocol", newJString(uploadProtocol))
  result = call_579094.call(path_579095, query_579096, nil, nil, nil)

var containeranalysisProjectsOccurrencesList* = Call_ContaineranalysisProjectsOccurrencesList_579075(
    name: "containeranalysisProjectsOccurrencesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{parent}/occurrences",
    validator: validate_ContaineranalysisProjectsOccurrencesList_579076,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesList_579077,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesBatchCreate_579118 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsOccurrencesBatchCreate_579120(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences:batchCreate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesBatchCreate_579119(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates new occurrences in batch.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the occurrences are to be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579121 = path.getOrDefault("parent")
  valid_579121 = validateParameter(valid_579121, JString, required = true,
                                 default = nil)
  if valid_579121 != nil:
    section.add "parent", valid_579121
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
  var valid_579122 = query.getOrDefault("key")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "key", valid_579122
  var valid_579123 = query.getOrDefault("prettyPrint")
  valid_579123 = validateParameter(valid_579123, JBool, required = false,
                                 default = newJBool(true))
  if valid_579123 != nil:
    section.add "prettyPrint", valid_579123
  var valid_579124 = query.getOrDefault("oauth_token")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "oauth_token", valid_579124
  var valid_579125 = query.getOrDefault("$.xgafv")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = newJString("1"))
  if valid_579125 != nil:
    section.add "$.xgafv", valid_579125
  var valid_579126 = query.getOrDefault("alt")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = newJString("json"))
  if valid_579126 != nil:
    section.add "alt", valid_579126
  var valid_579127 = query.getOrDefault("uploadType")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "uploadType", valid_579127
  var valid_579128 = query.getOrDefault("quotaUser")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "quotaUser", valid_579128
  var valid_579129 = query.getOrDefault("callback")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "callback", valid_579129
  var valid_579130 = query.getOrDefault("fields")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "fields", valid_579130
  var valid_579131 = query.getOrDefault("access_token")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "access_token", valid_579131
  var valid_579132 = query.getOrDefault("upload_protocol")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "upload_protocol", valid_579132
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

proc call*(call_579134: Call_ContaineranalysisProjectsOccurrencesBatchCreate_579118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new occurrences in batch.
  ## 
  let valid = call_579134.validator(path, query, header, formData, body)
  let scheme = call_579134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579134.url(scheme.get, call_579134.host, call_579134.base,
                         call_579134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579134, url, valid)

proc call*(call_579135: Call_ContaineranalysisProjectsOccurrencesBatchCreate_579118;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesBatchCreate
  ## Creates new occurrences in batch.
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
  ##   parent: string (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the occurrences are to be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579136 = newJObject()
  var query_579137 = newJObject()
  var body_579138 = newJObject()
  add(query_579137, "key", newJString(key))
  add(query_579137, "prettyPrint", newJBool(prettyPrint))
  add(query_579137, "oauth_token", newJString(oauthToken))
  add(query_579137, "$.xgafv", newJString(Xgafv))
  add(query_579137, "alt", newJString(alt))
  add(query_579137, "uploadType", newJString(uploadType))
  add(query_579137, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579138 = body
  add(query_579137, "callback", newJString(callback))
  add(path_579136, "parent", newJString(parent))
  add(query_579137, "fields", newJString(fields))
  add(query_579137, "access_token", newJString(accessToken))
  add(query_579137, "upload_protocol", newJString(uploadProtocol))
  result = call_579135.call(path_579136, query_579137, nil, nil, body_579138)

var containeranalysisProjectsOccurrencesBatchCreate* = Call_ContaineranalysisProjectsOccurrencesBatchCreate_579118(
    name: "containeranalysisProjectsOccurrencesBatchCreate",
    meth: HttpMethod.HttpPost, host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{parent}/occurrences:batchCreate",
    validator: validate_ContaineranalysisProjectsOccurrencesBatchCreate_579119,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesBatchCreate_579120,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579139 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579141(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"), (kind: ConstantSegment,
        value: "/occurrences:vulnerabilitySummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579140(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a summary of the number and severity of occurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project to get a vulnerability summary for in the form of
  ## `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579142 = path.getOrDefault("parent")
  valid_579142 = validateParameter(valid_579142, JString, required = true,
                                 default = nil)
  if valid_579142 != nil:
    section.add "parent", valid_579142
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
  ##   filter: JString
  ##         : The filter expression.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579143 = query.getOrDefault("key")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "key", valid_579143
  var valid_579144 = query.getOrDefault("prettyPrint")
  valid_579144 = validateParameter(valid_579144, JBool, required = false,
                                 default = newJBool(true))
  if valid_579144 != nil:
    section.add "prettyPrint", valid_579144
  var valid_579145 = query.getOrDefault("oauth_token")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "oauth_token", valid_579145
  var valid_579146 = query.getOrDefault("$.xgafv")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = newJString("1"))
  if valid_579146 != nil:
    section.add "$.xgafv", valid_579146
  var valid_579147 = query.getOrDefault("alt")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = newJString("json"))
  if valid_579147 != nil:
    section.add "alt", valid_579147
  var valid_579148 = query.getOrDefault("uploadType")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "uploadType", valid_579148
  var valid_579149 = query.getOrDefault("quotaUser")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "quotaUser", valid_579149
  var valid_579150 = query.getOrDefault("filter")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "filter", valid_579150
  var valid_579151 = query.getOrDefault("callback")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "callback", valid_579151
  var valid_579152 = query.getOrDefault("fields")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "fields", valid_579152
  var valid_579153 = query.getOrDefault("access_token")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "access_token", valid_579153
  var valid_579154 = query.getOrDefault("upload_protocol")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "upload_protocol", valid_579154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579155: Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579139;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a summary of the number and severity of occurrences.
  ## 
  let valid = call_579155.validator(path, query, header, formData, body)
  let scheme = call_579155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579155.url(scheme.get, call_579155.host, call_579155.base,
                         call_579155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579155, url, valid)

proc call*(call_579156: Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579139;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesGetVulnerabilitySummary
  ## Gets a summary of the number and severity of occurrences.
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
  ##   filter: string
  ##         : The filter expression.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the project to get a vulnerability summary for in the form of
  ## `projects/[PROJECT_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579157 = newJObject()
  var query_579158 = newJObject()
  add(query_579158, "key", newJString(key))
  add(query_579158, "prettyPrint", newJBool(prettyPrint))
  add(query_579158, "oauth_token", newJString(oauthToken))
  add(query_579158, "$.xgafv", newJString(Xgafv))
  add(query_579158, "alt", newJString(alt))
  add(query_579158, "uploadType", newJString(uploadType))
  add(query_579158, "quotaUser", newJString(quotaUser))
  add(query_579158, "filter", newJString(filter))
  add(query_579158, "callback", newJString(callback))
  add(path_579157, "parent", newJString(parent))
  add(query_579158, "fields", newJString(fields))
  add(query_579158, "access_token", newJString(accessToken))
  add(query_579158, "upload_protocol", newJString(uploadProtocol))
  result = call_579156.call(path_579157, query_579158, nil, nil, nil)

var containeranalysisProjectsOccurrencesGetVulnerabilitySummary* = Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579139(
    name: "containeranalysisProjectsOccurrencesGetVulnerabilitySummary",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{parent}/occurrences:vulnerabilitySummary", validator: validate_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579140,
    base: "/",
    url: url_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579141,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsScanConfigsList_579159 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsScanConfigsList_579161(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/scanConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsScanConfigsList_579160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists scan configurations for the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project to list scan configurations for in the form of
  ## `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579162 = path.getOrDefault("parent")
  valid_579162 = validateParameter(valid_579162, JString, required = true,
                                 default = nil)
  if valid_579162 != nil:
    section.add "parent", valid_579162
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
  ##   pageSize: JInt
  ##           : The number of scan configs to return in the list.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter expression.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579163 = query.getOrDefault("key")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "key", valid_579163
  var valid_579164 = query.getOrDefault("prettyPrint")
  valid_579164 = validateParameter(valid_579164, JBool, required = false,
                                 default = newJBool(true))
  if valid_579164 != nil:
    section.add "prettyPrint", valid_579164
  var valid_579165 = query.getOrDefault("oauth_token")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "oauth_token", valid_579165
  var valid_579166 = query.getOrDefault("$.xgafv")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = newJString("1"))
  if valid_579166 != nil:
    section.add "$.xgafv", valid_579166
  var valid_579167 = query.getOrDefault("pageSize")
  valid_579167 = validateParameter(valid_579167, JInt, required = false, default = nil)
  if valid_579167 != nil:
    section.add "pageSize", valid_579167
  var valid_579168 = query.getOrDefault("alt")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = newJString("json"))
  if valid_579168 != nil:
    section.add "alt", valid_579168
  var valid_579169 = query.getOrDefault("uploadType")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "uploadType", valid_579169
  var valid_579170 = query.getOrDefault("quotaUser")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "quotaUser", valid_579170
  var valid_579171 = query.getOrDefault("filter")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "filter", valid_579171
  var valid_579172 = query.getOrDefault("pageToken")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "pageToken", valid_579172
  var valid_579173 = query.getOrDefault("callback")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "callback", valid_579173
  var valid_579174 = query.getOrDefault("fields")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "fields", valid_579174
  var valid_579175 = query.getOrDefault("access_token")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "access_token", valid_579175
  var valid_579176 = query.getOrDefault("upload_protocol")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "upload_protocol", valid_579176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579177: Call_ContaineranalysisProjectsScanConfigsList_579159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists scan configurations for the specified project.
  ## 
  let valid = call_579177.validator(path, query, header, formData, body)
  let scheme = call_579177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579177.url(scheme.get, call_579177.host, call_579177.base,
                         call_579177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579177, url, valid)

proc call*(call_579178: Call_ContaineranalysisProjectsScanConfigsList_579159;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsScanConfigsList
  ## Lists scan configurations for the specified project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of scan configs to return in the list.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The filter expression.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the project to list scan configurations for in the form of
  ## `projects/[PROJECT_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579179 = newJObject()
  var query_579180 = newJObject()
  add(query_579180, "key", newJString(key))
  add(query_579180, "prettyPrint", newJBool(prettyPrint))
  add(query_579180, "oauth_token", newJString(oauthToken))
  add(query_579180, "$.xgafv", newJString(Xgafv))
  add(query_579180, "pageSize", newJInt(pageSize))
  add(query_579180, "alt", newJString(alt))
  add(query_579180, "uploadType", newJString(uploadType))
  add(query_579180, "quotaUser", newJString(quotaUser))
  add(query_579180, "filter", newJString(filter))
  add(query_579180, "pageToken", newJString(pageToken))
  add(query_579180, "callback", newJString(callback))
  add(path_579179, "parent", newJString(parent))
  add(query_579180, "fields", newJString(fields))
  add(query_579180, "access_token", newJString(accessToken))
  add(query_579180, "upload_protocol", newJString(uploadProtocol))
  result = call_579178.call(path_579179, query_579180, nil, nil, nil)

var containeranalysisProjectsScanConfigsList* = Call_ContaineranalysisProjectsScanConfigsList_579159(
    name: "containeranalysisProjectsScanConfigsList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{parent}/scanConfigs",
    validator: validate_ContaineranalysisProjectsScanConfigsList_579160,
    base: "/", url: url_ContaineranalysisProjectsScanConfigsList_579161,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesGetIamPolicy_579181 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsNotesGetIamPolicy_579183(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesGetIamPolicy_579182(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a note or an occurrence resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579184 = path.getOrDefault("resource")
  valid_579184 = validateParameter(valid_579184, JString, required = true,
                                 default = nil)
  if valid_579184 != nil:
    section.add "resource", valid_579184
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
  var valid_579185 = query.getOrDefault("key")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "key", valid_579185
  var valid_579186 = query.getOrDefault("prettyPrint")
  valid_579186 = validateParameter(valid_579186, JBool, required = false,
                                 default = newJBool(true))
  if valid_579186 != nil:
    section.add "prettyPrint", valid_579186
  var valid_579187 = query.getOrDefault("oauth_token")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "oauth_token", valid_579187
  var valid_579188 = query.getOrDefault("$.xgafv")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = newJString("1"))
  if valid_579188 != nil:
    section.add "$.xgafv", valid_579188
  var valid_579189 = query.getOrDefault("alt")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = newJString("json"))
  if valid_579189 != nil:
    section.add "alt", valid_579189
  var valid_579190 = query.getOrDefault("uploadType")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "uploadType", valid_579190
  var valid_579191 = query.getOrDefault("quotaUser")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "quotaUser", valid_579191
  var valid_579192 = query.getOrDefault("callback")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "callback", valid_579192
  var valid_579193 = query.getOrDefault("fields")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "fields", valid_579193
  var valid_579194 = query.getOrDefault("access_token")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "access_token", valid_579194
  var valid_579195 = query.getOrDefault("upload_protocol")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "upload_protocol", valid_579195
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

proc call*(call_579197: Call_ContaineranalysisProjectsNotesGetIamPolicy_579181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a note or an occurrence resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
  ## 
  let valid = call_579197.validator(path, query, header, formData, body)
  let scheme = call_579197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579197.url(scheme.get, call_579197.host, call_579197.base,
                         call_579197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579197, url, valid)

proc call*(call_579198: Call_ContaineranalysisProjectsNotesGetIamPolicy_579181;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsNotesGetIamPolicy
  ## Gets the access control policy for a note or an occurrence resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579199 = newJObject()
  var query_579200 = newJObject()
  var body_579201 = newJObject()
  add(query_579200, "key", newJString(key))
  add(query_579200, "prettyPrint", newJBool(prettyPrint))
  add(query_579200, "oauth_token", newJString(oauthToken))
  add(query_579200, "$.xgafv", newJString(Xgafv))
  add(query_579200, "alt", newJString(alt))
  add(query_579200, "uploadType", newJString(uploadType))
  add(query_579200, "quotaUser", newJString(quotaUser))
  add(path_579199, "resource", newJString(resource))
  if body != nil:
    body_579201 = body
  add(query_579200, "callback", newJString(callback))
  add(query_579200, "fields", newJString(fields))
  add(query_579200, "access_token", newJString(accessToken))
  add(query_579200, "upload_protocol", newJString(uploadProtocol))
  result = call_579198.call(path_579199, query_579200, nil, nil, body_579201)

var containeranalysisProjectsNotesGetIamPolicy* = Call_ContaineranalysisProjectsNotesGetIamPolicy_579181(
    name: "containeranalysisProjectsNotesGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_ContaineranalysisProjectsNotesGetIamPolicy_579182,
    base: "/", url: url_ContaineranalysisProjectsNotesGetIamPolicy_579183,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesSetIamPolicy_579202 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsNotesSetIamPolicy_579204(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesSetIamPolicy_579203(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified note or occurrence.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or an occurrence, respectively.
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579205 = path.getOrDefault("resource")
  valid_579205 = validateParameter(valid_579205, JString, required = true,
                                 default = nil)
  if valid_579205 != nil:
    section.add "resource", valid_579205
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
  var valid_579206 = query.getOrDefault("key")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "key", valid_579206
  var valid_579207 = query.getOrDefault("prettyPrint")
  valid_579207 = validateParameter(valid_579207, JBool, required = false,
                                 default = newJBool(true))
  if valid_579207 != nil:
    section.add "prettyPrint", valid_579207
  var valid_579208 = query.getOrDefault("oauth_token")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "oauth_token", valid_579208
  var valid_579209 = query.getOrDefault("$.xgafv")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = newJString("1"))
  if valid_579209 != nil:
    section.add "$.xgafv", valid_579209
  var valid_579210 = query.getOrDefault("alt")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = newJString("json"))
  if valid_579210 != nil:
    section.add "alt", valid_579210
  var valid_579211 = query.getOrDefault("uploadType")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "uploadType", valid_579211
  var valid_579212 = query.getOrDefault("quotaUser")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "quotaUser", valid_579212
  var valid_579213 = query.getOrDefault("callback")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "callback", valid_579213
  var valid_579214 = query.getOrDefault("fields")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "fields", valid_579214
  var valid_579215 = query.getOrDefault("access_token")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "access_token", valid_579215
  var valid_579216 = query.getOrDefault("upload_protocol")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "upload_protocol", valid_579216
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

proc call*(call_579218: Call_ContaineranalysisProjectsNotesSetIamPolicy_579202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified note or occurrence.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or an occurrence, respectively.
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
  ## 
  let valid = call_579218.validator(path, query, header, formData, body)
  let scheme = call_579218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579218.url(scheme.get, call_579218.host, call_579218.base,
                         call_579218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579218, url, valid)

proc call*(call_579219: Call_ContaineranalysisProjectsNotesSetIamPolicy_579202;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsNotesSetIamPolicy
  ## Sets the access control policy on the specified note or occurrence.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or an occurrence, respectively.
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579220 = newJObject()
  var query_579221 = newJObject()
  var body_579222 = newJObject()
  add(query_579221, "key", newJString(key))
  add(query_579221, "prettyPrint", newJBool(prettyPrint))
  add(query_579221, "oauth_token", newJString(oauthToken))
  add(query_579221, "$.xgafv", newJString(Xgafv))
  add(query_579221, "alt", newJString(alt))
  add(query_579221, "uploadType", newJString(uploadType))
  add(query_579221, "quotaUser", newJString(quotaUser))
  add(path_579220, "resource", newJString(resource))
  if body != nil:
    body_579222 = body
  add(query_579221, "callback", newJString(callback))
  add(query_579221, "fields", newJString(fields))
  add(query_579221, "access_token", newJString(accessToken))
  add(query_579221, "upload_protocol", newJString(uploadProtocol))
  result = call_579219.call(path_579220, query_579221, nil, nil, body_579222)

var containeranalysisProjectsNotesSetIamPolicy* = Call_ContaineranalysisProjectsNotesSetIamPolicy_579202(
    name: "containeranalysisProjectsNotesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_ContaineranalysisProjectsNotesSetIamPolicy_579203,
    base: "/", url: url_ContaineranalysisProjectsNotesSetIamPolicy_579204,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesTestIamPermissions_579223 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsNotesTestIamPermissions_579225(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesTestIamPermissions_579224(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence. Requires list permission on the project (for example,
  ## `containeranalysis.notes.list`).
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579226 = path.getOrDefault("resource")
  valid_579226 = validateParameter(valid_579226, JString, required = true,
                                 default = nil)
  if valid_579226 != nil:
    section.add "resource", valid_579226
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
  var valid_579227 = query.getOrDefault("key")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "key", valid_579227
  var valid_579228 = query.getOrDefault("prettyPrint")
  valid_579228 = validateParameter(valid_579228, JBool, required = false,
                                 default = newJBool(true))
  if valid_579228 != nil:
    section.add "prettyPrint", valid_579228
  var valid_579229 = query.getOrDefault("oauth_token")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "oauth_token", valid_579229
  var valid_579230 = query.getOrDefault("$.xgafv")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = newJString("1"))
  if valid_579230 != nil:
    section.add "$.xgafv", valid_579230
  var valid_579231 = query.getOrDefault("alt")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = newJString("json"))
  if valid_579231 != nil:
    section.add "alt", valid_579231
  var valid_579232 = query.getOrDefault("uploadType")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "uploadType", valid_579232
  var valid_579233 = query.getOrDefault("quotaUser")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "quotaUser", valid_579233
  var valid_579234 = query.getOrDefault("callback")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "callback", valid_579234
  var valid_579235 = query.getOrDefault("fields")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "fields", valid_579235
  var valid_579236 = query.getOrDefault("access_token")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "access_token", valid_579236
  var valid_579237 = query.getOrDefault("upload_protocol")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "upload_protocol", valid_579237
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

proc call*(call_579239: Call_ContaineranalysisProjectsNotesTestIamPermissions_579223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence. Requires list permission on the project (for example,
  ## `containeranalysis.notes.list`).
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
  ## 
  let valid = call_579239.validator(path, query, header, formData, body)
  let scheme = call_579239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579239.url(scheme.get, call_579239.host, call_579239.base,
                         call_579239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579239, url, valid)

proc call*(call_579240: Call_ContaineranalysisProjectsNotesTestIamPermissions_579223;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsNotesTestIamPermissions
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence. Requires list permission on the project (for example,
  ## `containeranalysis.notes.list`).
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579241 = newJObject()
  var query_579242 = newJObject()
  var body_579243 = newJObject()
  add(query_579242, "key", newJString(key))
  add(query_579242, "prettyPrint", newJBool(prettyPrint))
  add(query_579242, "oauth_token", newJString(oauthToken))
  add(query_579242, "$.xgafv", newJString(Xgafv))
  add(query_579242, "alt", newJString(alt))
  add(query_579242, "uploadType", newJString(uploadType))
  add(query_579242, "quotaUser", newJString(quotaUser))
  add(path_579241, "resource", newJString(resource))
  if body != nil:
    body_579243 = body
  add(query_579242, "callback", newJString(callback))
  add(query_579242, "fields", newJString(fields))
  add(query_579242, "access_token", newJString(accessToken))
  add(query_579242, "upload_protocol", newJString(uploadProtocol))
  result = call_579240.call(path_579241, query_579242, nil, nil, body_579243)

var containeranalysisProjectsNotesTestIamPermissions* = Call_ContaineranalysisProjectsNotesTestIamPermissions_579223(
    name: "containeranalysisProjectsNotesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_ContaineranalysisProjectsNotesTestIamPermissions_579224,
    base: "/", url: url_ContaineranalysisProjectsNotesTestIamPermissions_579225,
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
