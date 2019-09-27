
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Web Security Scanner
## version: v1alpha
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Scans your Compute and App Engine apps for common web vulnerabilities.
## 
## https://cloud.google.com/security-scanner/
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  gcpServiceName = "websecurityscanner"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WebsecurityscannerProjectsScanConfigsScanRunsFindingsGet_593677 = ref object of OpenApiRestCall_593408
proc url_WebsecurityscannerProjectsScanConfigsScanRunsFindingsGet_593679(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebsecurityscannerProjectsScanConfigsScanRunsFindingsGet_593678(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a Finding.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the Finding to be returned. The name follows the
  ## format of
  ## 
  ## 'projects/{projectId}/scanConfigs/{scanConfigId}/scanRuns/{scanRunId}/findings/{findingId}'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593805 = path.getOrDefault("name")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "name", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("quotaUser")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "quotaUser", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("oauth_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "oauth_token", valid_593823
  var valid_593824 = query.getOrDefault("callback")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "callback", valid_593824
  var valid_593825 = query.getOrDefault("access_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "access_token", valid_593825
  var valid_593826 = query.getOrDefault("uploadType")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "uploadType", valid_593826
  var valid_593827 = query.getOrDefault("key")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "key", valid_593827
  var valid_593828 = query.getOrDefault("$.xgafv")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = newJString("1"))
  if valid_593828 != nil:
    section.add "$.xgafv", valid_593828
  var valid_593829 = query.getOrDefault("prettyPrint")
  valid_593829 = validateParameter(valid_593829, JBool, required = false,
                                 default = newJBool(true))
  if valid_593829 != nil:
    section.add "prettyPrint", valid_593829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593852: Call_WebsecurityscannerProjectsScanConfigsScanRunsFindingsGet_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a Finding.
  ## 
  let valid = call_593852.validator(path, query, header, formData, body)
  let scheme = call_593852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593852.url(scheme.get, call_593852.host, call_593852.base,
                         call_593852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593852, url, valid)

proc call*(call_593923: Call_WebsecurityscannerProjectsScanConfigsScanRunsFindingsGet_593677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## websecurityscannerProjectsScanConfigsScanRunsFindingsGet
  ## Gets a Finding.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the Finding to be returned. The name follows the
  ## format of
  ## 
  ## 'projects/{projectId}/scanConfigs/{scanConfigId}/scanRuns/{scanRunId}/findings/{findingId}'.
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
  var path_593924 = newJObject()
  var query_593926 = newJObject()
  add(query_593926, "upload_protocol", newJString(uploadProtocol))
  add(query_593926, "fields", newJString(fields))
  add(query_593926, "quotaUser", newJString(quotaUser))
  add(path_593924, "name", newJString(name))
  add(query_593926, "alt", newJString(alt))
  add(query_593926, "oauth_token", newJString(oauthToken))
  add(query_593926, "callback", newJString(callback))
  add(query_593926, "access_token", newJString(accessToken))
  add(query_593926, "uploadType", newJString(uploadType))
  add(query_593926, "key", newJString(key))
  add(query_593926, "$.xgafv", newJString(Xgafv))
  add(query_593926, "prettyPrint", newJBool(prettyPrint))
  result = call_593923.call(path_593924, query_593926, nil, nil, nil)

var websecurityscannerProjectsScanConfigsScanRunsFindingsGet* = Call_WebsecurityscannerProjectsScanConfigsScanRunsFindingsGet_593677(
    name: "websecurityscannerProjectsScanConfigsScanRunsFindingsGet",
    meth: HttpMethod.HttpGet, host: "websecurityscanner.googleapis.com",
    route: "/v1alpha/{name}", validator: validate_WebsecurityscannerProjectsScanConfigsScanRunsFindingsGet_593678,
    base: "/", url: url_WebsecurityscannerProjectsScanConfigsScanRunsFindingsGet_593679,
    schemes: {Scheme.Https})
type
  Call_WebsecurityscannerProjectsScanConfigsPatch_593984 = ref object of OpenApiRestCall_593408
proc url_WebsecurityscannerProjectsScanConfigsPatch_593986(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebsecurityscannerProjectsScanConfigsPatch_593985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a ScanConfig. This method support partial update of a ScanConfig.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the ScanConfig. The name follows the format of
  ## 'projects/{projectId}/scanConfigs/{scanConfigId}'. The ScanConfig IDs are
  ## generated by the system.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593987 = path.getOrDefault("name")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "name", valid_593987
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
  ##             : Required. The update mask applies to the resource. For the `FieldMask` definition,
  ## see
  ## 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#fieldmask
  section = newJObject()
  var valid_593988 = query.getOrDefault("upload_protocol")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "upload_protocol", valid_593988
  var valid_593989 = query.getOrDefault("fields")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "fields", valid_593989
  var valid_593990 = query.getOrDefault("quotaUser")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "quotaUser", valid_593990
  var valid_593991 = query.getOrDefault("alt")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("json"))
  if valid_593991 != nil:
    section.add "alt", valid_593991
  var valid_593992 = query.getOrDefault("oauth_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "oauth_token", valid_593992
  var valid_593993 = query.getOrDefault("callback")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "callback", valid_593993
  var valid_593994 = query.getOrDefault("access_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "access_token", valid_593994
  var valid_593995 = query.getOrDefault("uploadType")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "uploadType", valid_593995
  var valid_593996 = query.getOrDefault("key")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "key", valid_593996
  var valid_593997 = query.getOrDefault("$.xgafv")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = newJString("1"))
  if valid_593997 != nil:
    section.add "$.xgafv", valid_593997
  var valid_593998 = query.getOrDefault("prettyPrint")
  valid_593998 = validateParameter(valid_593998, JBool, required = false,
                                 default = newJBool(true))
  if valid_593998 != nil:
    section.add "prettyPrint", valid_593998
  var valid_593999 = query.getOrDefault("updateMask")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "updateMask", valid_593999
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

proc call*(call_594001: Call_WebsecurityscannerProjectsScanConfigsPatch_593984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a ScanConfig. This method support partial update of a ScanConfig.
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_WebsecurityscannerProjectsScanConfigsPatch_593984;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## websecurityscannerProjectsScanConfigsPatch
  ## Updates a ScanConfig. This method support partial update of a ScanConfig.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the ScanConfig. The name follows the format of
  ## 'projects/{projectId}/scanConfigs/{scanConfigId}'. The ScanConfig IDs are
  ## generated by the system.
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
  ##             : Required. The update mask applies to the resource. For the `FieldMask` definition,
  ## see
  ## 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#fieldmask
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  var body_594005 = newJObject()
  add(query_594004, "upload_protocol", newJString(uploadProtocol))
  add(query_594004, "fields", newJString(fields))
  add(query_594004, "quotaUser", newJString(quotaUser))
  add(path_594003, "name", newJString(name))
  add(query_594004, "alt", newJString(alt))
  add(query_594004, "oauth_token", newJString(oauthToken))
  add(query_594004, "callback", newJString(callback))
  add(query_594004, "access_token", newJString(accessToken))
  add(query_594004, "uploadType", newJString(uploadType))
  add(query_594004, "key", newJString(key))
  add(query_594004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594005 = body
  add(query_594004, "prettyPrint", newJBool(prettyPrint))
  add(query_594004, "updateMask", newJString(updateMask))
  result = call_594002.call(path_594003, query_594004, nil, nil, body_594005)

var websecurityscannerProjectsScanConfigsPatch* = Call_WebsecurityscannerProjectsScanConfigsPatch_593984(
    name: "websecurityscannerProjectsScanConfigsPatch",
    meth: HttpMethod.HttpPatch, host: "websecurityscanner.googleapis.com",
    route: "/v1alpha/{name}",
    validator: validate_WebsecurityscannerProjectsScanConfigsPatch_593985,
    base: "/", url: url_WebsecurityscannerProjectsScanConfigsPatch_593986,
    schemes: {Scheme.Https})
type
  Call_WebsecurityscannerProjectsScanConfigsDelete_593965 = ref object of OpenApiRestCall_593408
proc url_WebsecurityscannerProjectsScanConfigsDelete_593967(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebsecurityscannerProjectsScanConfigsDelete_593966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing ScanConfig and its child resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the ScanConfig to be deleted. The name follows the
  ## format of 'projects/{projectId}/scanConfigs/{scanConfigId}'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593968 = path.getOrDefault("name")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "name", valid_593968
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
  var valid_593969 = query.getOrDefault("upload_protocol")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "upload_protocol", valid_593969
  var valid_593970 = query.getOrDefault("fields")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "fields", valid_593970
  var valid_593971 = query.getOrDefault("quotaUser")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "quotaUser", valid_593971
  var valid_593972 = query.getOrDefault("alt")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = newJString("json"))
  if valid_593972 != nil:
    section.add "alt", valid_593972
  var valid_593973 = query.getOrDefault("oauth_token")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "oauth_token", valid_593973
  var valid_593974 = query.getOrDefault("callback")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "callback", valid_593974
  var valid_593975 = query.getOrDefault("access_token")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "access_token", valid_593975
  var valid_593976 = query.getOrDefault("uploadType")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "uploadType", valid_593976
  var valid_593977 = query.getOrDefault("key")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "key", valid_593977
  var valid_593978 = query.getOrDefault("$.xgafv")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("1"))
  if valid_593978 != nil:
    section.add "$.xgafv", valid_593978
  var valid_593979 = query.getOrDefault("prettyPrint")
  valid_593979 = validateParameter(valid_593979, JBool, required = false,
                                 default = newJBool(true))
  if valid_593979 != nil:
    section.add "prettyPrint", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_WebsecurityscannerProjectsScanConfigsDelete_593965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing ScanConfig and its child resources.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_WebsecurityscannerProjectsScanConfigsDelete_593965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## websecurityscannerProjectsScanConfigsDelete
  ## Deletes an existing ScanConfig and its child resources.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the ScanConfig to be deleted. The name follows the
  ## format of 'projects/{projectId}/scanConfigs/{scanConfigId}'.
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
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(query_593983, "upload_protocol", newJString(uploadProtocol))
  add(query_593983, "fields", newJString(fields))
  add(query_593983, "quotaUser", newJString(quotaUser))
  add(path_593982, "name", newJString(name))
  add(query_593983, "alt", newJString(alt))
  add(query_593983, "oauth_token", newJString(oauthToken))
  add(query_593983, "callback", newJString(callback))
  add(query_593983, "access_token", newJString(accessToken))
  add(query_593983, "uploadType", newJString(uploadType))
  add(query_593983, "key", newJString(key))
  add(query_593983, "$.xgafv", newJString(Xgafv))
  add(query_593983, "prettyPrint", newJBool(prettyPrint))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var websecurityscannerProjectsScanConfigsDelete* = Call_WebsecurityscannerProjectsScanConfigsDelete_593965(
    name: "websecurityscannerProjectsScanConfigsDelete",
    meth: HttpMethod.HttpDelete, host: "websecurityscanner.googleapis.com",
    route: "/v1alpha/{name}",
    validator: validate_WebsecurityscannerProjectsScanConfigsDelete_593966,
    base: "/", url: url_WebsecurityscannerProjectsScanConfigsDelete_593967,
    schemes: {Scheme.Https})
type
  Call_WebsecurityscannerProjectsScanConfigsStart_594006 = ref object of OpenApiRestCall_593408
proc url_WebsecurityscannerProjectsScanConfigsStart_594008(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebsecurityscannerProjectsScanConfigsStart_594007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start a ScanRun according to the given ScanConfig.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the ScanConfig to be used. The name follows the
  ## format of 'projects/{projectId}/scanConfigs/{scanConfigId}'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594009 = path.getOrDefault("name")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "name", valid_594009
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
  var valid_594010 = query.getOrDefault("upload_protocol")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "upload_protocol", valid_594010
  var valid_594011 = query.getOrDefault("fields")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "fields", valid_594011
  var valid_594012 = query.getOrDefault("quotaUser")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "quotaUser", valid_594012
  var valid_594013 = query.getOrDefault("alt")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = newJString("json"))
  if valid_594013 != nil:
    section.add "alt", valid_594013
  var valid_594014 = query.getOrDefault("oauth_token")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "oauth_token", valid_594014
  var valid_594015 = query.getOrDefault("callback")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "callback", valid_594015
  var valid_594016 = query.getOrDefault("access_token")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "access_token", valid_594016
  var valid_594017 = query.getOrDefault("uploadType")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "uploadType", valid_594017
  var valid_594018 = query.getOrDefault("key")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "key", valid_594018
  var valid_594019 = query.getOrDefault("$.xgafv")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = newJString("1"))
  if valid_594019 != nil:
    section.add "$.xgafv", valid_594019
  var valid_594020 = query.getOrDefault("prettyPrint")
  valid_594020 = validateParameter(valid_594020, JBool, required = false,
                                 default = newJBool(true))
  if valid_594020 != nil:
    section.add "prettyPrint", valid_594020
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

proc call*(call_594022: Call_WebsecurityscannerProjectsScanConfigsStart_594006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start a ScanRun according to the given ScanConfig.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_WebsecurityscannerProjectsScanConfigsStart_594006;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## websecurityscannerProjectsScanConfigsStart
  ## Start a ScanRun according to the given ScanConfig.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the ScanConfig to be used. The name follows the
  ## format of 'projects/{projectId}/scanConfigs/{scanConfigId}'.
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
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  var body_594026 = newJObject()
  add(query_594025, "upload_protocol", newJString(uploadProtocol))
  add(query_594025, "fields", newJString(fields))
  add(query_594025, "quotaUser", newJString(quotaUser))
  add(path_594024, "name", newJString(name))
  add(query_594025, "alt", newJString(alt))
  add(query_594025, "oauth_token", newJString(oauthToken))
  add(query_594025, "callback", newJString(callback))
  add(query_594025, "access_token", newJString(accessToken))
  add(query_594025, "uploadType", newJString(uploadType))
  add(query_594025, "key", newJString(key))
  add(query_594025, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594026 = body
  add(query_594025, "prettyPrint", newJBool(prettyPrint))
  result = call_594023.call(path_594024, query_594025, nil, nil, body_594026)

var websecurityscannerProjectsScanConfigsStart* = Call_WebsecurityscannerProjectsScanConfigsStart_594006(
    name: "websecurityscannerProjectsScanConfigsStart", meth: HttpMethod.HttpPost,
    host: "websecurityscanner.googleapis.com", route: "/v1alpha/{name}:start",
    validator: validate_WebsecurityscannerProjectsScanConfigsStart_594007,
    base: "/", url: url_WebsecurityscannerProjectsScanConfigsStart_594008,
    schemes: {Scheme.Https})
type
  Call_WebsecurityscannerProjectsScanConfigsScanRunsStop_594027 = ref object of OpenApiRestCall_593408
proc url_WebsecurityscannerProjectsScanConfigsScanRunsStop_594029(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebsecurityscannerProjectsScanConfigsScanRunsStop_594028(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Stops a ScanRun. The stopped ScanRun is returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the ScanRun to be stopped. The name follows the
  ## format of
  ## 'projects/{projectId}/scanConfigs/{scanConfigId}/scanRuns/{scanRunId}'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594030 = path.getOrDefault("name")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "name", valid_594030
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
  var valid_594031 = query.getOrDefault("upload_protocol")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "upload_protocol", valid_594031
  var valid_594032 = query.getOrDefault("fields")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "fields", valid_594032
  var valid_594033 = query.getOrDefault("quotaUser")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "quotaUser", valid_594033
  var valid_594034 = query.getOrDefault("alt")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = newJString("json"))
  if valid_594034 != nil:
    section.add "alt", valid_594034
  var valid_594035 = query.getOrDefault("oauth_token")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "oauth_token", valid_594035
  var valid_594036 = query.getOrDefault("callback")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "callback", valid_594036
  var valid_594037 = query.getOrDefault("access_token")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "access_token", valid_594037
  var valid_594038 = query.getOrDefault("uploadType")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "uploadType", valid_594038
  var valid_594039 = query.getOrDefault("key")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "key", valid_594039
  var valid_594040 = query.getOrDefault("$.xgafv")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = newJString("1"))
  if valid_594040 != nil:
    section.add "$.xgafv", valid_594040
  var valid_594041 = query.getOrDefault("prettyPrint")
  valid_594041 = validateParameter(valid_594041, JBool, required = false,
                                 default = newJBool(true))
  if valid_594041 != nil:
    section.add "prettyPrint", valid_594041
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

proc call*(call_594043: Call_WebsecurityscannerProjectsScanConfigsScanRunsStop_594027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops a ScanRun. The stopped ScanRun is returned.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_WebsecurityscannerProjectsScanConfigsScanRunsStop_594027;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## websecurityscannerProjectsScanConfigsScanRunsStop
  ## Stops a ScanRun. The stopped ScanRun is returned.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the ScanRun to be stopped. The name follows the
  ## format of
  ## 'projects/{projectId}/scanConfigs/{scanConfigId}/scanRuns/{scanRunId}'.
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
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  var body_594047 = newJObject()
  add(query_594046, "upload_protocol", newJString(uploadProtocol))
  add(query_594046, "fields", newJString(fields))
  add(query_594046, "quotaUser", newJString(quotaUser))
  add(path_594045, "name", newJString(name))
  add(query_594046, "alt", newJString(alt))
  add(query_594046, "oauth_token", newJString(oauthToken))
  add(query_594046, "callback", newJString(callback))
  add(query_594046, "access_token", newJString(accessToken))
  add(query_594046, "uploadType", newJString(uploadType))
  add(query_594046, "key", newJString(key))
  add(query_594046, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594047 = body
  add(query_594046, "prettyPrint", newJBool(prettyPrint))
  result = call_594044.call(path_594045, query_594046, nil, nil, body_594047)

var websecurityscannerProjectsScanConfigsScanRunsStop* = Call_WebsecurityscannerProjectsScanConfigsScanRunsStop_594027(
    name: "websecurityscannerProjectsScanConfigsScanRunsStop",
    meth: HttpMethod.HttpPost, host: "websecurityscanner.googleapis.com",
    route: "/v1alpha/{name}:stop",
    validator: validate_WebsecurityscannerProjectsScanConfigsScanRunsStop_594028,
    base: "/", url: url_WebsecurityscannerProjectsScanConfigsScanRunsStop_594029,
    schemes: {Scheme.Https})
type
  Call_WebsecurityscannerProjectsScanConfigsScanRunsCrawledUrlsList_594048 = ref object of OpenApiRestCall_593408
proc url_WebsecurityscannerProjectsScanConfigsScanRunsCrawledUrlsList_594050(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/crawledUrls")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebsecurityscannerProjectsScanConfigsScanRunsCrawledUrlsList_594049(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List CrawledUrls under a given ScanRun.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, which should be a scan run resource name in the
  ## format
  ## 'projects/{projectId}/scanConfigs/{scanConfigId}/scanRuns/{scanRunId}'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594051 = path.getOrDefault("parent")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "parent", valid_594051
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous List request.
  ## If unspecified, the first page of results is returned.
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
  ##           : The maximum number of CrawledUrls to return, can be limited by server.
  ## If not specified or not positive, the implementation will select a
  ## reasonable value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594052 = query.getOrDefault("upload_protocol")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "upload_protocol", valid_594052
  var valid_594053 = query.getOrDefault("fields")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "fields", valid_594053
  var valid_594054 = query.getOrDefault("pageToken")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "pageToken", valid_594054
  var valid_594055 = query.getOrDefault("quotaUser")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "quotaUser", valid_594055
  var valid_594056 = query.getOrDefault("alt")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = newJString("json"))
  if valid_594056 != nil:
    section.add "alt", valid_594056
  var valid_594057 = query.getOrDefault("oauth_token")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "oauth_token", valid_594057
  var valid_594058 = query.getOrDefault("callback")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "callback", valid_594058
  var valid_594059 = query.getOrDefault("access_token")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "access_token", valid_594059
  var valid_594060 = query.getOrDefault("uploadType")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "uploadType", valid_594060
  var valid_594061 = query.getOrDefault("key")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "key", valid_594061
  var valid_594062 = query.getOrDefault("$.xgafv")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = newJString("1"))
  if valid_594062 != nil:
    section.add "$.xgafv", valid_594062
  var valid_594063 = query.getOrDefault("pageSize")
  valid_594063 = validateParameter(valid_594063, JInt, required = false, default = nil)
  if valid_594063 != nil:
    section.add "pageSize", valid_594063
  var valid_594064 = query.getOrDefault("prettyPrint")
  valid_594064 = validateParameter(valid_594064, JBool, required = false,
                                 default = newJBool(true))
  if valid_594064 != nil:
    section.add "prettyPrint", valid_594064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594065: Call_WebsecurityscannerProjectsScanConfigsScanRunsCrawledUrlsList_594048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List CrawledUrls under a given ScanRun.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_WebsecurityscannerProjectsScanConfigsScanRunsCrawledUrlsList_594048;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## websecurityscannerProjectsScanConfigsScanRunsCrawledUrlsList
  ## List CrawledUrls under a given ScanRun.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous List request.
  ## If unspecified, the first page of results is returned.
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
  ##         : Required. The parent resource name, which should be a scan run resource name in the
  ## format
  ## 'projects/{projectId}/scanConfigs/{scanConfigId}/scanRuns/{scanRunId}'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of CrawledUrls to return, can be limited by server.
  ## If not specified or not positive, the implementation will select a
  ## reasonable value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  add(query_594068, "upload_protocol", newJString(uploadProtocol))
  add(query_594068, "fields", newJString(fields))
  add(query_594068, "pageToken", newJString(pageToken))
  add(query_594068, "quotaUser", newJString(quotaUser))
  add(query_594068, "alt", newJString(alt))
  add(query_594068, "oauth_token", newJString(oauthToken))
  add(query_594068, "callback", newJString(callback))
  add(query_594068, "access_token", newJString(accessToken))
  add(query_594068, "uploadType", newJString(uploadType))
  add(path_594067, "parent", newJString(parent))
  add(query_594068, "key", newJString(key))
  add(query_594068, "$.xgafv", newJString(Xgafv))
  add(query_594068, "pageSize", newJInt(pageSize))
  add(query_594068, "prettyPrint", newJBool(prettyPrint))
  result = call_594066.call(path_594067, query_594068, nil, nil, nil)

var websecurityscannerProjectsScanConfigsScanRunsCrawledUrlsList* = Call_WebsecurityscannerProjectsScanConfigsScanRunsCrawledUrlsList_594048(
    name: "websecurityscannerProjectsScanConfigsScanRunsCrawledUrlsList",
    meth: HttpMethod.HttpGet, host: "websecurityscanner.googleapis.com",
    route: "/v1alpha/{parent}/crawledUrls", validator: validate_WebsecurityscannerProjectsScanConfigsScanRunsCrawledUrlsList_594049,
    base: "/",
    url: url_WebsecurityscannerProjectsScanConfigsScanRunsCrawledUrlsList_594050,
    schemes: {Scheme.Https})
type
  Call_WebsecurityscannerProjectsScanConfigsScanRunsFindingTypeStatsList_594069 = ref object of OpenApiRestCall_593408
proc url_WebsecurityscannerProjectsScanConfigsScanRunsFindingTypeStatsList_594071(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/findingTypeStats")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebsecurityscannerProjectsScanConfigsScanRunsFindingTypeStatsList_594070(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all FindingTypeStats under a given ScanRun.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, which should be a scan run resource name in the
  ## format
  ## 'projects/{projectId}/scanConfigs/{scanConfigId}/scanRuns/{scanRunId}'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594072 = path.getOrDefault("parent")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "parent", valid_594072
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
  var valid_594073 = query.getOrDefault("upload_protocol")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "upload_protocol", valid_594073
  var valid_594074 = query.getOrDefault("fields")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "fields", valid_594074
  var valid_594075 = query.getOrDefault("quotaUser")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "quotaUser", valid_594075
  var valid_594076 = query.getOrDefault("alt")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = newJString("json"))
  if valid_594076 != nil:
    section.add "alt", valid_594076
  var valid_594077 = query.getOrDefault("oauth_token")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "oauth_token", valid_594077
  var valid_594078 = query.getOrDefault("callback")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "callback", valid_594078
  var valid_594079 = query.getOrDefault("access_token")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "access_token", valid_594079
  var valid_594080 = query.getOrDefault("uploadType")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "uploadType", valid_594080
  var valid_594081 = query.getOrDefault("key")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "key", valid_594081
  var valid_594082 = query.getOrDefault("$.xgafv")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = newJString("1"))
  if valid_594082 != nil:
    section.add "$.xgafv", valid_594082
  var valid_594083 = query.getOrDefault("prettyPrint")
  valid_594083 = validateParameter(valid_594083, JBool, required = false,
                                 default = newJBool(true))
  if valid_594083 != nil:
    section.add "prettyPrint", valid_594083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594084: Call_WebsecurityscannerProjectsScanConfigsScanRunsFindingTypeStatsList_594069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all FindingTypeStats under a given ScanRun.
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_WebsecurityscannerProjectsScanConfigsScanRunsFindingTypeStatsList_594069;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## websecurityscannerProjectsScanConfigsScanRunsFindingTypeStatsList
  ## List all FindingTypeStats under a given ScanRun.
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
  ##         : Required. The parent resource name, which should be a scan run resource name in the
  ## format
  ## 'projects/{projectId}/scanConfigs/{scanConfigId}/scanRuns/{scanRunId}'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  add(query_594087, "upload_protocol", newJString(uploadProtocol))
  add(query_594087, "fields", newJString(fields))
  add(query_594087, "quotaUser", newJString(quotaUser))
  add(query_594087, "alt", newJString(alt))
  add(query_594087, "oauth_token", newJString(oauthToken))
  add(query_594087, "callback", newJString(callback))
  add(query_594087, "access_token", newJString(accessToken))
  add(query_594087, "uploadType", newJString(uploadType))
  add(path_594086, "parent", newJString(parent))
  add(query_594087, "key", newJString(key))
  add(query_594087, "$.xgafv", newJString(Xgafv))
  add(query_594087, "prettyPrint", newJBool(prettyPrint))
  result = call_594085.call(path_594086, query_594087, nil, nil, nil)

var websecurityscannerProjectsScanConfigsScanRunsFindingTypeStatsList* = Call_WebsecurityscannerProjectsScanConfigsScanRunsFindingTypeStatsList_594069(
    name: "websecurityscannerProjectsScanConfigsScanRunsFindingTypeStatsList",
    meth: HttpMethod.HttpGet, host: "websecurityscanner.googleapis.com",
    route: "/v1alpha/{parent}/findingTypeStats", validator: validate_WebsecurityscannerProjectsScanConfigsScanRunsFindingTypeStatsList_594070,
    base: "/",
    url: url_WebsecurityscannerProjectsScanConfigsScanRunsFindingTypeStatsList_594071,
    schemes: {Scheme.Https})
type
  Call_WebsecurityscannerProjectsScanConfigsScanRunsFindingsList_594088 = ref object of OpenApiRestCall_593408
proc url_WebsecurityscannerProjectsScanConfigsScanRunsFindingsList_594090(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/findings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebsecurityscannerProjectsScanConfigsScanRunsFindingsList_594089(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List Findings under a given ScanRun.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, which should be a scan run resource name in the
  ## format
  ## 'projects/{projectId}/scanConfigs/{scanConfigId}/scanRuns/{scanRunId}'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594091 = path.getOrDefault("parent")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "parent", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous List request.
  ## If unspecified, the first page of results is returned.
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
  ##           : The maximum number of Findings to return, can be limited by server.
  ## If not specified or not positive, the implementation will select a
  ## reasonable value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression. The expression must be in the format: <field>
  ## <operator> <value>.
  ## Supported field: 'finding_type'.
  ## Supported operator: '='.
  section = newJObject()
  var valid_594092 = query.getOrDefault("upload_protocol")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "upload_protocol", valid_594092
  var valid_594093 = query.getOrDefault("fields")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "fields", valid_594093
  var valid_594094 = query.getOrDefault("pageToken")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "pageToken", valid_594094
  var valid_594095 = query.getOrDefault("quotaUser")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "quotaUser", valid_594095
  var valid_594096 = query.getOrDefault("alt")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = newJString("json"))
  if valid_594096 != nil:
    section.add "alt", valid_594096
  var valid_594097 = query.getOrDefault("oauth_token")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "oauth_token", valid_594097
  var valid_594098 = query.getOrDefault("callback")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "callback", valid_594098
  var valid_594099 = query.getOrDefault("access_token")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "access_token", valid_594099
  var valid_594100 = query.getOrDefault("uploadType")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "uploadType", valid_594100
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
  var valid_594103 = query.getOrDefault("pageSize")
  valid_594103 = validateParameter(valid_594103, JInt, required = false, default = nil)
  if valid_594103 != nil:
    section.add "pageSize", valid_594103
  var valid_594104 = query.getOrDefault("prettyPrint")
  valid_594104 = validateParameter(valid_594104, JBool, required = false,
                                 default = newJBool(true))
  if valid_594104 != nil:
    section.add "prettyPrint", valid_594104
  var valid_594105 = query.getOrDefault("filter")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "filter", valid_594105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594106: Call_WebsecurityscannerProjectsScanConfigsScanRunsFindingsList_594088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Findings under a given ScanRun.
  ## 
  let valid = call_594106.validator(path, query, header, formData, body)
  let scheme = call_594106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594106.url(scheme.get, call_594106.host, call_594106.base,
                         call_594106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594106, url, valid)

proc call*(call_594107: Call_WebsecurityscannerProjectsScanConfigsScanRunsFindingsList_594088;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## websecurityscannerProjectsScanConfigsScanRunsFindingsList
  ## List Findings under a given ScanRun.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous List request.
  ## If unspecified, the first page of results is returned.
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
  ##         : Required. The parent resource name, which should be a scan run resource name in the
  ## format
  ## 'projects/{projectId}/scanConfigs/{scanConfigId}/scanRuns/{scanRunId}'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Findings to return, can be limited by server.
  ## If not specified or not positive, the implementation will select a
  ## reasonable value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression. The expression must be in the format: <field>
  ## <operator> <value>.
  ## Supported field: 'finding_type'.
  ## Supported operator: '='.
  var path_594108 = newJObject()
  var query_594109 = newJObject()
  add(query_594109, "upload_protocol", newJString(uploadProtocol))
  add(query_594109, "fields", newJString(fields))
  add(query_594109, "pageToken", newJString(pageToken))
  add(query_594109, "quotaUser", newJString(quotaUser))
  add(query_594109, "alt", newJString(alt))
  add(query_594109, "oauth_token", newJString(oauthToken))
  add(query_594109, "callback", newJString(callback))
  add(query_594109, "access_token", newJString(accessToken))
  add(query_594109, "uploadType", newJString(uploadType))
  add(path_594108, "parent", newJString(parent))
  add(query_594109, "key", newJString(key))
  add(query_594109, "$.xgafv", newJString(Xgafv))
  add(query_594109, "pageSize", newJInt(pageSize))
  add(query_594109, "prettyPrint", newJBool(prettyPrint))
  add(query_594109, "filter", newJString(filter))
  result = call_594107.call(path_594108, query_594109, nil, nil, nil)

var websecurityscannerProjectsScanConfigsScanRunsFindingsList* = Call_WebsecurityscannerProjectsScanConfigsScanRunsFindingsList_594088(
    name: "websecurityscannerProjectsScanConfigsScanRunsFindingsList",
    meth: HttpMethod.HttpGet, host: "websecurityscanner.googleapis.com",
    route: "/v1alpha/{parent}/findings", validator: validate_WebsecurityscannerProjectsScanConfigsScanRunsFindingsList_594089,
    base: "/", url: url_WebsecurityscannerProjectsScanConfigsScanRunsFindingsList_594090,
    schemes: {Scheme.Https})
type
  Call_WebsecurityscannerProjectsScanConfigsCreate_594131 = ref object of OpenApiRestCall_593408
proc url_WebsecurityscannerProjectsScanConfigsCreate_594133(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/scanConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebsecurityscannerProjectsScanConfigsCreate_594132(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new ScanConfig.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name where the scan is created, which should be a
  ## project resource name in the format 'projects/{projectId}'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594134 = path.getOrDefault("parent")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "parent", valid_594134
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
  var valid_594135 = query.getOrDefault("upload_protocol")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "upload_protocol", valid_594135
  var valid_594136 = query.getOrDefault("fields")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "fields", valid_594136
  var valid_594137 = query.getOrDefault("quotaUser")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "quotaUser", valid_594137
  var valid_594138 = query.getOrDefault("alt")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = newJString("json"))
  if valid_594138 != nil:
    section.add "alt", valid_594138
  var valid_594139 = query.getOrDefault("oauth_token")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "oauth_token", valid_594139
  var valid_594140 = query.getOrDefault("callback")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "callback", valid_594140
  var valid_594141 = query.getOrDefault("access_token")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "access_token", valid_594141
  var valid_594142 = query.getOrDefault("uploadType")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "uploadType", valid_594142
  var valid_594143 = query.getOrDefault("key")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "key", valid_594143
  var valid_594144 = query.getOrDefault("$.xgafv")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = newJString("1"))
  if valid_594144 != nil:
    section.add "$.xgafv", valid_594144
  var valid_594145 = query.getOrDefault("prettyPrint")
  valid_594145 = validateParameter(valid_594145, JBool, required = false,
                                 default = newJBool(true))
  if valid_594145 != nil:
    section.add "prettyPrint", valid_594145
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

proc call*(call_594147: Call_WebsecurityscannerProjectsScanConfigsCreate_594131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ScanConfig.
  ## 
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_WebsecurityscannerProjectsScanConfigsCreate_594131;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## websecurityscannerProjectsScanConfigsCreate
  ## Creates a new ScanConfig.
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
  ##         : Required. The parent resource name where the scan is created, which should be a
  ## project resource name in the format 'projects/{projectId}'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594149 = newJObject()
  var query_594150 = newJObject()
  var body_594151 = newJObject()
  add(query_594150, "upload_protocol", newJString(uploadProtocol))
  add(query_594150, "fields", newJString(fields))
  add(query_594150, "quotaUser", newJString(quotaUser))
  add(query_594150, "alt", newJString(alt))
  add(query_594150, "oauth_token", newJString(oauthToken))
  add(query_594150, "callback", newJString(callback))
  add(query_594150, "access_token", newJString(accessToken))
  add(query_594150, "uploadType", newJString(uploadType))
  add(path_594149, "parent", newJString(parent))
  add(query_594150, "key", newJString(key))
  add(query_594150, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594151 = body
  add(query_594150, "prettyPrint", newJBool(prettyPrint))
  result = call_594148.call(path_594149, query_594150, nil, nil, body_594151)

var websecurityscannerProjectsScanConfigsCreate* = Call_WebsecurityscannerProjectsScanConfigsCreate_594131(
    name: "websecurityscannerProjectsScanConfigsCreate",
    meth: HttpMethod.HttpPost, host: "websecurityscanner.googleapis.com",
    route: "/v1alpha/{parent}/scanConfigs",
    validator: validate_WebsecurityscannerProjectsScanConfigsCreate_594132,
    base: "/", url: url_WebsecurityscannerProjectsScanConfigsCreate_594133,
    schemes: {Scheme.Https})
type
  Call_WebsecurityscannerProjectsScanConfigsList_594110 = ref object of OpenApiRestCall_593408
proc url_WebsecurityscannerProjectsScanConfigsList_594112(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/scanConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebsecurityscannerProjectsScanConfigsList_594111(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists ScanConfigs under a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, which should be a project resource name in the
  ## format 'projects/{projectId}'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594113 = path.getOrDefault("parent")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "parent", valid_594113
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous List request.
  ## If unspecified, the first page of results is returned.
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
  ##           : The maximum number of ScanConfigs to return, can be limited by server.
  ## If not specified or not positive, the implementation will select a
  ## reasonable value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594114 = query.getOrDefault("upload_protocol")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "upload_protocol", valid_594114
  var valid_594115 = query.getOrDefault("fields")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "fields", valid_594115
  var valid_594116 = query.getOrDefault("pageToken")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "pageToken", valid_594116
  var valid_594117 = query.getOrDefault("quotaUser")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "quotaUser", valid_594117
  var valid_594118 = query.getOrDefault("alt")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = newJString("json"))
  if valid_594118 != nil:
    section.add "alt", valid_594118
  var valid_594119 = query.getOrDefault("oauth_token")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "oauth_token", valid_594119
  var valid_594120 = query.getOrDefault("callback")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "callback", valid_594120
  var valid_594121 = query.getOrDefault("access_token")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "access_token", valid_594121
  var valid_594122 = query.getOrDefault("uploadType")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "uploadType", valid_594122
  var valid_594123 = query.getOrDefault("key")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "key", valid_594123
  var valid_594124 = query.getOrDefault("$.xgafv")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = newJString("1"))
  if valid_594124 != nil:
    section.add "$.xgafv", valid_594124
  var valid_594125 = query.getOrDefault("pageSize")
  valid_594125 = validateParameter(valid_594125, JInt, required = false, default = nil)
  if valid_594125 != nil:
    section.add "pageSize", valid_594125
  var valid_594126 = query.getOrDefault("prettyPrint")
  valid_594126 = validateParameter(valid_594126, JBool, required = false,
                                 default = newJBool(true))
  if valid_594126 != nil:
    section.add "prettyPrint", valid_594126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594127: Call_WebsecurityscannerProjectsScanConfigsList_594110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ScanConfigs under a given project.
  ## 
  let valid = call_594127.validator(path, query, header, formData, body)
  let scheme = call_594127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594127.url(scheme.get, call_594127.host, call_594127.base,
                         call_594127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594127, url, valid)

proc call*(call_594128: Call_WebsecurityscannerProjectsScanConfigsList_594110;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## websecurityscannerProjectsScanConfigsList
  ## Lists ScanConfigs under a given project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous List request.
  ## If unspecified, the first page of results is returned.
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
  ##         : Required. The parent resource name, which should be a project resource name in the
  ## format 'projects/{projectId}'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of ScanConfigs to return, can be limited by server.
  ## If not specified or not positive, the implementation will select a
  ## reasonable value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594129 = newJObject()
  var query_594130 = newJObject()
  add(query_594130, "upload_protocol", newJString(uploadProtocol))
  add(query_594130, "fields", newJString(fields))
  add(query_594130, "pageToken", newJString(pageToken))
  add(query_594130, "quotaUser", newJString(quotaUser))
  add(query_594130, "alt", newJString(alt))
  add(query_594130, "oauth_token", newJString(oauthToken))
  add(query_594130, "callback", newJString(callback))
  add(query_594130, "access_token", newJString(accessToken))
  add(query_594130, "uploadType", newJString(uploadType))
  add(path_594129, "parent", newJString(parent))
  add(query_594130, "key", newJString(key))
  add(query_594130, "$.xgafv", newJString(Xgafv))
  add(query_594130, "pageSize", newJInt(pageSize))
  add(query_594130, "prettyPrint", newJBool(prettyPrint))
  result = call_594128.call(path_594129, query_594130, nil, nil, nil)

var websecurityscannerProjectsScanConfigsList* = Call_WebsecurityscannerProjectsScanConfigsList_594110(
    name: "websecurityscannerProjectsScanConfigsList", meth: HttpMethod.HttpGet,
    host: "websecurityscanner.googleapis.com",
    route: "/v1alpha/{parent}/scanConfigs",
    validator: validate_WebsecurityscannerProjectsScanConfigsList_594111,
    base: "/", url: url_WebsecurityscannerProjectsScanConfigsList_594112,
    schemes: {Scheme.Https})
type
  Call_WebsecurityscannerProjectsScanConfigsScanRunsList_594152 = ref object of OpenApiRestCall_593408
proc url_WebsecurityscannerProjectsScanConfigsScanRunsList_594154(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/scanRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WebsecurityscannerProjectsScanConfigsScanRunsList_594153(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists ScanRuns under a given ScanConfig, in descending order of ScanRun
  ## stop time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource name, which should be a scan resource name in the
  ## format 'projects/{projectId}/scanConfigs/{scanConfigId}'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594155 = path.getOrDefault("parent")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "parent", valid_594155
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous List request.
  ## If unspecified, the first page of results is returned.
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
  ##           : The maximum number of ScanRuns to return, can be limited by server.
  ## If not specified or not positive, the implementation will select a
  ## reasonable value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594156 = query.getOrDefault("upload_protocol")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "upload_protocol", valid_594156
  var valid_594157 = query.getOrDefault("fields")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "fields", valid_594157
  var valid_594158 = query.getOrDefault("pageToken")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "pageToken", valid_594158
  var valid_594159 = query.getOrDefault("quotaUser")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "quotaUser", valid_594159
  var valid_594160 = query.getOrDefault("alt")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = newJString("json"))
  if valid_594160 != nil:
    section.add "alt", valid_594160
  var valid_594161 = query.getOrDefault("oauth_token")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "oauth_token", valid_594161
  var valid_594162 = query.getOrDefault("callback")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "callback", valid_594162
  var valid_594163 = query.getOrDefault("access_token")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "access_token", valid_594163
  var valid_594164 = query.getOrDefault("uploadType")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "uploadType", valid_594164
  var valid_594165 = query.getOrDefault("key")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "key", valid_594165
  var valid_594166 = query.getOrDefault("$.xgafv")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = newJString("1"))
  if valid_594166 != nil:
    section.add "$.xgafv", valid_594166
  var valid_594167 = query.getOrDefault("pageSize")
  valid_594167 = validateParameter(valid_594167, JInt, required = false, default = nil)
  if valid_594167 != nil:
    section.add "pageSize", valid_594167
  var valid_594168 = query.getOrDefault("prettyPrint")
  valid_594168 = validateParameter(valid_594168, JBool, required = false,
                                 default = newJBool(true))
  if valid_594168 != nil:
    section.add "prettyPrint", valid_594168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594169: Call_WebsecurityscannerProjectsScanConfigsScanRunsList_594152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ScanRuns under a given ScanConfig, in descending order of ScanRun
  ## stop time.
  ## 
  let valid = call_594169.validator(path, query, header, formData, body)
  let scheme = call_594169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594169.url(scheme.get, call_594169.host, call_594169.base,
                         call_594169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594169, url, valid)

proc call*(call_594170: Call_WebsecurityscannerProjectsScanConfigsScanRunsList_594152;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## websecurityscannerProjectsScanConfigsScanRunsList
  ## Lists ScanRuns under a given ScanConfig, in descending order of ScanRun
  ## stop time.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous List request.
  ## If unspecified, the first page of results is returned.
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
  ##         : Required. The parent resource name, which should be a scan resource name in the
  ## format 'projects/{projectId}/scanConfigs/{scanConfigId}'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of ScanRuns to return, can be limited by server.
  ## If not specified or not positive, the implementation will select a
  ## reasonable value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594171 = newJObject()
  var query_594172 = newJObject()
  add(query_594172, "upload_protocol", newJString(uploadProtocol))
  add(query_594172, "fields", newJString(fields))
  add(query_594172, "pageToken", newJString(pageToken))
  add(query_594172, "quotaUser", newJString(quotaUser))
  add(query_594172, "alt", newJString(alt))
  add(query_594172, "oauth_token", newJString(oauthToken))
  add(query_594172, "callback", newJString(callback))
  add(query_594172, "access_token", newJString(accessToken))
  add(query_594172, "uploadType", newJString(uploadType))
  add(path_594171, "parent", newJString(parent))
  add(query_594172, "key", newJString(key))
  add(query_594172, "$.xgafv", newJString(Xgafv))
  add(query_594172, "pageSize", newJInt(pageSize))
  add(query_594172, "prettyPrint", newJBool(prettyPrint))
  result = call_594170.call(path_594171, query_594172, nil, nil, nil)

var websecurityscannerProjectsScanConfigsScanRunsList* = Call_WebsecurityscannerProjectsScanConfigsScanRunsList_594152(
    name: "websecurityscannerProjectsScanConfigsScanRunsList",
    meth: HttpMethod.HttpGet, host: "websecurityscanner.googleapis.com",
    route: "/v1alpha/{parent}/scanRuns",
    validator: validate_WebsecurityscannerProjectsScanConfigsScanRunsList_594153,
    base: "/", url: url_WebsecurityscannerProjectsScanConfigsScanRunsList_594154,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
