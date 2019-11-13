
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Run
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Deploy and manage user provided container images that scale automatically based on HTTP traffic.
## 
## https://cloud.google.com/run/
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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
  gcpServiceName = "run"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RunNamespacesAutodomainmappingsReplaceAutoDomainMapping_579932 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesAutodomainmappingsReplaceAutoDomainMapping_579934(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesAutodomainmappingsReplaceAutoDomainMapping_579933(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Replace an auto domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the auto domain mapping being retrieved.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579935 = path.getOrDefault("name")
  valid_579935 = validateParameter(valid_579935, JString, required = true,
                                 default = nil)
  if valid_579935 != nil:
    section.add "name", valid_579935
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
  var valid_579936 = query.getOrDefault("key")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "key", valid_579936
  var valid_579937 = query.getOrDefault("prettyPrint")
  valid_579937 = validateParameter(valid_579937, JBool, required = false,
                                 default = newJBool(true))
  if valid_579937 != nil:
    section.add "prettyPrint", valid_579937
  var valid_579938 = query.getOrDefault("oauth_token")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "oauth_token", valid_579938
  var valid_579939 = query.getOrDefault("$.xgafv")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = newJString("1"))
  if valid_579939 != nil:
    section.add "$.xgafv", valid_579939
  var valid_579940 = query.getOrDefault("alt")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = newJString("json"))
  if valid_579940 != nil:
    section.add "alt", valid_579940
  var valid_579941 = query.getOrDefault("uploadType")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "uploadType", valid_579941
  var valid_579942 = query.getOrDefault("quotaUser")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "quotaUser", valid_579942
  var valid_579943 = query.getOrDefault("callback")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "callback", valid_579943
  var valid_579944 = query.getOrDefault("fields")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "fields", valid_579944
  var valid_579945 = query.getOrDefault("access_token")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "access_token", valid_579945
  var valid_579946 = query.getOrDefault("upload_protocol")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "upload_protocol", valid_579946
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

proc call*(call_579948: Call_RunNamespacesAutodomainmappingsReplaceAutoDomainMapping_579932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace an auto domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_579948.validator(path, query, header, formData, body)
  let scheme = call_579948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579948.url(scheme.get, call_579948.host, call_579948.base,
                         call_579948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579948, url, valid)

proc call*(call_579949: Call_RunNamespacesAutodomainmappingsReplaceAutoDomainMapping_579932;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesAutodomainmappingsReplaceAutoDomainMapping
  ## Replace an auto domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
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
  ##       : The name of the auto domain mapping being retrieved.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579950 = newJObject()
  var query_579951 = newJObject()
  var body_579952 = newJObject()
  add(query_579951, "key", newJString(key))
  add(query_579951, "prettyPrint", newJBool(prettyPrint))
  add(query_579951, "oauth_token", newJString(oauthToken))
  add(query_579951, "$.xgafv", newJString(Xgafv))
  add(query_579951, "alt", newJString(alt))
  add(query_579951, "uploadType", newJString(uploadType))
  add(query_579951, "quotaUser", newJString(quotaUser))
  add(path_579950, "name", newJString(name))
  if body != nil:
    body_579952 = body
  add(query_579951, "callback", newJString(callback))
  add(query_579951, "fields", newJString(fields))
  add(query_579951, "access_token", newJString(accessToken))
  add(query_579951, "upload_protocol", newJString(uploadProtocol))
  result = call_579949.call(path_579950, query_579951, nil, nil, body_579952)

var runNamespacesAutodomainmappingsReplaceAutoDomainMapping* = Call_RunNamespacesAutodomainmappingsReplaceAutoDomainMapping_579932(
    name: "runNamespacesAutodomainmappingsReplaceAutoDomainMapping",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{name}", validator: validate_RunNamespacesAutodomainmappingsReplaceAutoDomainMapping_579933,
    base: "/", url: url_RunNamespacesAutodomainmappingsReplaceAutoDomainMapping_579934,
    schemes: {Scheme.Https})
type
  Call_RunNamespacesAutodomainmappingsGet_579644 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesAutodomainmappingsGet_579646(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesAutodomainmappingsGet_579645(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about an auto domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the auto domain mapping being retrieved.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579772 = path.getOrDefault("name")
  valid_579772 = validateParameter(valid_579772, JString, required = true,
                                 default = nil)
  if valid_579772 != nil:
    section.add "name", valid_579772
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
  var valid_579773 = query.getOrDefault("key")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "key", valid_579773
  var valid_579787 = query.getOrDefault("prettyPrint")
  valid_579787 = validateParameter(valid_579787, JBool, required = false,
                                 default = newJBool(true))
  if valid_579787 != nil:
    section.add "prettyPrint", valid_579787
  var valid_579788 = query.getOrDefault("oauth_token")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "oauth_token", valid_579788
  var valid_579789 = query.getOrDefault("$.xgafv")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = newJString("1"))
  if valid_579789 != nil:
    section.add "$.xgafv", valid_579789
  var valid_579790 = query.getOrDefault("alt")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = newJString("json"))
  if valid_579790 != nil:
    section.add "alt", valid_579790
  var valid_579791 = query.getOrDefault("uploadType")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "uploadType", valid_579791
  var valid_579792 = query.getOrDefault("quotaUser")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "quotaUser", valid_579792
  var valid_579793 = query.getOrDefault("callback")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "callback", valid_579793
  var valid_579794 = query.getOrDefault("fields")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "fields", valid_579794
  var valid_579795 = query.getOrDefault("access_token")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "access_token", valid_579795
  var valid_579796 = query.getOrDefault("upload_protocol")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "upload_protocol", valid_579796
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579819: Call_RunNamespacesAutodomainmappingsGet_579644;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about an auto domain mapping.
  ## 
  let valid = call_579819.validator(path, query, header, formData, body)
  let scheme = call_579819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579819.url(scheme.get, call_579819.host, call_579819.base,
                         call_579819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579819, url, valid)

proc call*(call_579890: Call_RunNamespacesAutodomainmappingsGet_579644;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesAutodomainmappingsGet
  ## Get information about an auto domain mapping.
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
  ##       : The name of the auto domain mapping being retrieved.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579891 = newJObject()
  var query_579893 = newJObject()
  add(query_579893, "key", newJString(key))
  add(query_579893, "prettyPrint", newJBool(prettyPrint))
  add(query_579893, "oauth_token", newJString(oauthToken))
  add(query_579893, "$.xgafv", newJString(Xgafv))
  add(query_579893, "alt", newJString(alt))
  add(query_579893, "uploadType", newJString(uploadType))
  add(query_579893, "quotaUser", newJString(quotaUser))
  add(path_579891, "name", newJString(name))
  add(query_579893, "callback", newJString(callback))
  add(query_579893, "fields", newJString(fields))
  add(query_579893, "access_token", newJString(accessToken))
  add(query_579893, "upload_protocol", newJString(uploadProtocol))
  result = call_579890.call(path_579891, query_579893, nil, nil, nil)

var runNamespacesAutodomainmappingsGet* = Call_RunNamespacesAutodomainmappingsGet_579644(
    name: "runNamespacesAutodomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesAutodomainmappingsGet_579645, base: "/",
    url: url_RunNamespacesAutodomainmappingsGet_579646, schemes: {Scheme.Https})
type
  Call_RunNamespacesAutodomainmappingsDelete_579953 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesAutodomainmappingsDelete_579955(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesAutodomainmappingsDelete_579954(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an auto domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the auto domain mapping being deleted.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579956 = path.getOrDefault("name")
  valid_579956 = validateParameter(valid_579956, JString, required = true,
                                 default = nil)
  if valid_579956 != nil:
    section.add "name", valid_579956
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
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: JString
  ##           : JSONP
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579957 = query.getOrDefault("key")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "key", valid_579957
  var valid_579958 = query.getOrDefault("prettyPrint")
  valid_579958 = validateParameter(valid_579958, JBool, required = false,
                                 default = newJBool(true))
  if valid_579958 != nil:
    section.add "prettyPrint", valid_579958
  var valid_579959 = query.getOrDefault("oauth_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "oauth_token", valid_579959
  var valid_579960 = query.getOrDefault("$.xgafv")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = newJString("1"))
  if valid_579960 != nil:
    section.add "$.xgafv", valid_579960
  var valid_579961 = query.getOrDefault("alt")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = newJString("json"))
  if valid_579961 != nil:
    section.add "alt", valid_579961
  var valid_579962 = query.getOrDefault("uploadType")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "uploadType", valid_579962
  var valid_579963 = query.getOrDefault("quotaUser")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "quotaUser", valid_579963
  var valid_579964 = query.getOrDefault("propagationPolicy")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "propagationPolicy", valid_579964
  var valid_579965 = query.getOrDefault("callback")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "callback", valid_579965
  var valid_579966 = query.getOrDefault("apiVersion")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "apiVersion", valid_579966
  var valid_579967 = query.getOrDefault("kind")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "kind", valid_579967
  var valid_579968 = query.getOrDefault("fields")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "fields", valid_579968
  var valid_579969 = query.getOrDefault("access_token")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "access_token", valid_579969
  var valid_579970 = query.getOrDefault("upload_protocol")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "upload_protocol", valid_579970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579971: Call_RunNamespacesAutodomainmappingsDelete_579953;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an auto domain mapping.
  ## 
  let valid = call_579971.validator(path, query, header, formData, body)
  let scheme = call_579971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579971.url(scheme.get, call_579971.host, call_579971.base,
                         call_579971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579971, url, valid)

proc call*(call_579972: Call_RunNamespacesAutodomainmappingsDelete_579953;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          propagationPolicy: string = ""; callback: string = "";
          apiVersion: string = ""; kind: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesAutodomainmappingsDelete
  ## Delete an auto domain mapping.
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
  ##       : The name of the auto domain mapping being deleted.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: string
  ##           : JSONP
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579973 = newJObject()
  var query_579974 = newJObject()
  add(query_579974, "key", newJString(key))
  add(query_579974, "prettyPrint", newJBool(prettyPrint))
  add(query_579974, "oauth_token", newJString(oauthToken))
  add(query_579974, "$.xgafv", newJString(Xgafv))
  add(query_579974, "alt", newJString(alt))
  add(query_579974, "uploadType", newJString(uploadType))
  add(query_579974, "quotaUser", newJString(quotaUser))
  add(path_579973, "name", newJString(name))
  add(query_579974, "propagationPolicy", newJString(propagationPolicy))
  add(query_579974, "callback", newJString(callback))
  add(query_579974, "apiVersion", newJString(apiVersion))
  add(query_579974, "kind", newJString(kind))
  add(query_579974, "fields", newJString(fields))
  add(query_579974, "access_token", newJString(accessToken))
  add(query_579974, "upload_protocol", newJString(uploadProtocol))
  result = call_579972.call(path_579973, query_579974, nil, nil, nil)

var runNamespacesAutodomainmappingsDelete* = Call_RunNamespacesAutodomainmappingsDelete_579953(
    name: "runNamespacesAutodomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesAutodomainmappingsDelete_579954, base: "/",
    url: url_RunNamespacesAutodomainmappingsDelete_579955, schemes: {Scheme.Https})
type
  Call_RunNamespacesAuthorizeddomainsList_579975 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesAuthorizeddomainsList_579977(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/authorizeddomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesAuthorizeddomainsList_579976(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List authorized domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579978 = path.getOrDefault("parent")
  valid_579978 = validateParameter(valid_579978, JString, required = true,
                                 default = nil)
  if valid_579978 != nil:
    section.add "parent", valid_579978
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
  ##           : Maximum results to return per page.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579979 = query.getOrDefault("key")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "key", valid_579979
  var valid_579980 = query.getOrDefault("prettyPrint")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "prettyPrint", valid_579980
  var valid_579981 = query.getOrDefault("oauth_token")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "oauth_token", valid_579981
  var valid_579982 = query.getOrDefault("$.xgafv")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("1"))
  if valid_579982 != nil:
    section.add "$.xgafv", valid_579982
  var valid_579983 = query.getOrDefault("pageSize")
  valid_579983 = validateParameter(valid_579983, JInt, required = false, default = nil)
  if valid_579983 != nil:
    section.add "pageSize", valid_579983
  var valid_579984 = query.getOrDefault("alt")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("json"))
  if valid_579984 != nil:
    section.add "alt", valid_579984
  var valid_579985 = query.getOrDefault("uploadType")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "uploadType", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("pageToken")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "pageToken", valid_579987
  var valid_579988 = query.getOrDefault("callback")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "callback", valid_579988
  var valid_579989 = query.getOrDefault("fields")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "fields", valid_579989
  var valid_579990 = query.getOrDefault("access_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "access_token", valid_579990
  var valid_579991 = query.getOrDefault("upload_protocol")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "upload_protocol", valid_579991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579992: Call_RunNamespacesAuthorizeddomainsList_579975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List authorized domains.
  ## 
  let valid = call_579992.validator(path, query, header, formData, body)
  let scheme = call_579992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579992.url(scheme.get, call_579992.host, call_579992.base,
                         call_579992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579992, url, valid)

proc call*(call_579993: Call_RunNamespacesAuthorizeddomainsList_579975;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesAuthorizeddomainsList
  ## List authorized domains.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579994 = newJObject()
  var query_579995 = newJObject()
  add(query_579995, "key", newJString(key))
  add(query_579995, "prettyPrint", newJBool(prettyPrint))
  add(query_579995, "oauth_token", newJString(oauthToken))
  add(query_579995, "$.xgafv", newJString(Xgafv))
  add(query_579995, "pageSize", newJInt(pageSize))
  add(query_579995, "alt", newJString(alt))
  add(query_579995, "uploadType", newJString(uploadType))
  add(query_579995, "quotaUser", newJString(quotaUser))
  add(query_579995, "pageToken", newJString(pageToken))
  add(query_579995, "callback", newJString(callback))
  add(path_579994, "parent", newJString(parent))
  add(query_579995, "fields", newJString(fields))
  add(query_579995, "access_token", newJString(accessToken))
  add(query_579995, "upload_protocol", newJString(uploadProtocol))
  result = call_579993.call(path_579994, query_579995, nil, nil, nil)

var runNamespacesAuthorizeddomainsList* = Call_RunNamespacesAuthorizeddomainsList_579975(
    name: "runNamespacesAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/authorizeddomains",
    validator: validate_RunNamespacesAuthorizeddomainsList_579976, base: "/",
    url: url_RunNamespacesAuthorizeddomainsList_579977, schemes: {Scheme.Https})
type
  Call_RunNamespacesAutodomainmappingsCreate_580022 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesAutodomainmappingsCreate_580024(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autodomainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesAutodomainmappingsCreate_580023(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new auto domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580025 = path.getOrDefault("parent")
  valid_580025 = validateParameter(valid_580025, JString, required = true,
                                 default = nil)
  if valid_580025 != nil:
    section.add "parent", valid_580025
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
  var valid_580026 = query.getOrDefault("key")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "key", valid_580026
  var valid_580027 = query.getOrDefault("prettyPrint")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "prettyPrint", valid_580027
  var valid_580028 = query.getOrDefault("oauth_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "oauth_token", valid_580028
  var valid_580029 = query.getOrDefault("$.xgafv")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("1"))
  if valid_580029 != nil:
    section.add "$.xgafv", valid_580029
  var valid_580030 = query.getOrDefault("alt")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("json"))
  if valid_580030 != nil:
    section.add "alt", valid_580030
  var valid_580031 = query.getOrDefault("uploadType")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "uploadType", valid_580031
  var valid_580032 = query.getOrDefault("quotaUser")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "quotaUser", valid_580032
  var valid_580033 = query.getOrDefault("callback")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "callback", valid_580033
  var valid_580034 = query.getOrDefault("fields")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "fields", valid_580034
  var valid_580035 = query.getOrDefault("access_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "access_token", valid_580035
  var valid_580036 = query.getOrDefault("upload_protocol")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "upload_protocol", valid_580036
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

proc call*(call_580038: Call_RunNamespacesAutodomainmappingsCreate_580022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new auto domain mapping.
  ## 
  let valid = call_580038.validator(path, query, header, formData, body)
  let scheme = call_580038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580038.url(scheme.get, call_580038.host, call_580038.base,
                         call_580038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580038, url, valid)

proc call*(call_580039: Call_RunNamespacesAutodomainmappingsCreate_580022;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesAutodomainmappingsCreate
  ## Creates a new auto domain mapping.
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
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580040 = newJObject()
  var query_580041 = newJObject()
  var body_580042 = newJObject()
  add(query_580041, "key", newJString(key))
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  add(query_580041, "oauth_token", newJString(oauthToken))
  add(query_580041, "$.xgafv", newJString(Xgafv))
  add(query_580041, "alt", newJString(alt))
  add(query_580041, "uploadType", newJString(uploadType))
  add(query_580041, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580042 = body
  add(query_580041, "callback", newJString(callback))
  add(path_580040, "parent", newJString(parent))
  add(query_580041, "fields", newJString(fields))
  add(query_580041, "access_token", newJString(accessToken))
  add(query_580041, "upload_protocol", newJString(uploadProtocol))
  result = call_580039.call(path_580040, query_580041, nil, nil, body_580042)

var runNamespacesAutodomainmappingsCreate* = Call_RunNamespacesAutodomainmappingsCreate_580022(
    name: "runNamespacesAutodomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/autodomainmappings",
    validator: validate_RunNamespacesAutodomainmappingsCreate_580023, base: "/",
    url: url_RunNamespacesAutodomainmappingsCreate_580024, schemes: {Scheme.Https})
type
  Call_RunNamespacesAutodomainmappingsList_579996 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesAutodomainmappingsList_579998(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autodomainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesAutodomainmappingsList_579997(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List auto domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579999 = path.getOrDefault("parent")
  valid_579999 = validateParameter(valid_579999, JString, required = true,
                                 default = nil)
  if valid_579999 != nil:
    section.add "parent", valid_579999
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_580000 = query.getOrDefault("key")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "key", valid_580000
  var valid_580001 = query.getOrDefault("includeUninitialized")
  valid_580001 = validateParameter(valid_580001, JBool, required = false, default = nil)
  if valid_580001 != nil:
    section.add "includeUninitialized", valid_580001
  var valid_580002 = query.getOrDefault("prettyPrint")
  valid_580002 = validateParameter(valid_580002, JBool, required = false,
                                 default = newJBool(true))
  if valid_580002 != nil:
    section.add "prettyPrint", valid_580002
  var valid_580003 = query.getOrDefault("oauth_token")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "oauth_token", valid_580003
  var valid_580004 = query.getOrDefault("fieldSelector")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "fieldSelector", valid_580004
  var valid_580005 = query.getOrDefault("labelSelector")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "labelSelector", valid_580005
  var valid_580006 = query.getOrDefault("$.xgafv")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = newJString("1"))
  if valid_580006 != nil:
    section.add "$.xgafv", valid_580006
  var valid_580007 = query.getOrDefault("limit")
  valid_580007 = validateParameter(valid_580007, JInt, required = false, default = nil)
  if valid_580007 != nil:
    section.add "limit", valid_580007
  var valid_580008 = query.getOrDefault("alt")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = newJString("json"))
  if valid_580008 != nil:
    section.add "alt", valid_580008
  var valid_580009 = query.getOrDefault("uploadType")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "uploadType", valid_580009
  var valid_580010 = query.getOrDefault("quotaUser")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "quotaUser", valid_580010
  var valid_580011 = query.getOrDefault("watch")
  valid_580011 = validateParameter(valid_580011, JBool, required = false, default = nil)
  if valid_580011 != nil:
    section.add "watch", valid_580011
  var valid_580012 = query.getOrDefault("callback")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "callback", valid_580012
  var valid_580013 = query.getOrDefault("resourceVersion")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "resourceVersion", valid_580013
  var valid_580014 = query.getOrDefault("fields")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "fields", valid_580014
  var valid_580015 = query.getOrDefault("access_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "access_token", valid_580015
  var valid_580016 = query.getOrDefault("upload_protocol")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "upload_protocol", valid_580016
  var valid_580017 = query.getOrDefault("continue")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "continue", valid_580017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580018: Call_RunNamespacesAutodomainmappingsList_579996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List auto domain mappings.
  ## 
  let valid = call_580018.validator(path, query, header, formData, body)
  let scheme = call_580018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580018.url(scheme.get, call_580018.host, call_580018.base,
                         call_580018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580018, url, valid)

proc call*(call_580019: Call_RunNamespacesAutodomainmappingsList_579996;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesAutodomainmappingsList
  ## List auto domain mappings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_580020 = newJObject()
  var query_580021 = newJObject()
  add(query_580021, "key", newJString(key))
  add(query_580021, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580021, "prettyPrint", newJBool(prettyPrint))
  add(query_580021, "oauth_token", newJString(oauthToken))
  add(query_580021, "fieldSelector", newJString(fieldSelector))
  add(query_580021, "labelSelector", newJString(labelSelector))
  add(query_580021, "$.xgafv", newJString(Xgafv))
  add(query_580021, "limit", newJInt(limit))
  add(query_580021, "alt", newJString(alt))
  add(query_580021, "uploadType", newJString(uploadType))
  add(query_580021, "quotaUser", newJString(quotaUser))
  add(query_580021, "watch", newJBool(watch))
  add(query_580021, "callback", newJString(callback))
  add(path_580020, "parent", newJString(parent))
  add(query_580021, "resourceVersion", newJString(resourceVersion))
  add(query_580021, "fields", newJString(fields))
  add(query_580021, "access_token", newJString(accessToken))
  add(query_580021, "upload_protocol", newJString(uploadProtocol))
  add(query_580021, "continue", newJString(`continue`))
  result = call_580019.call(path_580020, query_580021, nil, nil, nil)

var runNamespacesAutodomainmappingsList* = Call_RunNamespacesAutodomainmappingsList_579996(
    name: "runNamespacesAutodomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/autodomainmappings",
    validator: validate_RunNamespacesAutodomainmappingsList_579997, base: "/",
    url: url_RunNamespacesAutodomainmappingsList_579998, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsCreate_580069 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesDomainmappingsCreate_580071(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsCreate_580070(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace in which the domain mapping should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580072 = path.getOrDefault("parent")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "parent", valid_580072
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
  var valid_580073 = query.getOrDefault("key")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "key", valid_580073
  var valid_580074 = query.getOrDefault("prettyPrint")
  valid_580074 = validateParameter(valid_580074, JBool, required = false,
                                 default = newJBool(true))
  if valid_580074 != nil:
    section.add "prettyPrint", valid_580074
  var valid_580075 = query.getOrDefault("oauth_token")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "oauth_token", valid_580075
  var valid_580076 = query.getOrDefault("$.xgafv")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("1"))
  if valid_580076 != nil:
    section.add "$.xgafv", valid_580076
  var valid_580077 = query.getOrDefault("alt")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("json"))
  if valid_580077 != nil:
    section.add "alt", valid_580077
  var valid_580078 = query.getOrDefault("uploadType")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "uploadType", valid_580078
  var valid_580079 = query.getOrDefault("quotaUser")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "quotaUser", valid_580079
  var valid_580080 = query.getOrDefault("callback")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "callback", valid_580080
  var valid_580081 = query.getOrDefault("fields")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "fields", valid_580081
  var valid_580082 = query.getOrDefault("access_token")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "access_token", valid_580082
  var valid_580083 = query.getOrDefault("upload_protocol")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "upload_protocol", valid_580083
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

proc call*(call_580085: Call_RunNamespacesDomainmappingsCreate_580069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new domain mapping.
  ## 
  let valid = call_580085.validator(path, query, header, formData, body)
  let scheme = call_580085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580085.url(scheme.get, call_580085.host, call_580085.base,
                         call_580085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580085, url, valid)

proc call*(call_580086: Call_RunNamespacesDomainmappingsCreate_580069;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesDomainmappingsCreate
  ## Create a new domain mapping.
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
  ##         : The namespace in which the domain mapping should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580087 = newJObject()
  var query_580088 = newJObject()
  var body_580089 = newJObject()
  add(query_580088, "key", newJString(key))
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(query_580088, "$.xgafv", newJString(Xgafv))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "uploadType", newJString(uploadType))
  add(query_580088, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580089 = body
  add(query_580088, "callback", newJString(callback))
  add(path_580087, "parent", newJString(parent))
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "access_token", newJString(accessToken))
  add(query_580088, "upload_protocol", newJString(uploadProtocol))
  result = call_580086.call(path_580087, query_580088, nil, nil, body_580089)

var runNamespacesDomainmappingsCreate* = Call_RunNamespacesDomainmappingsCreate_580069(
    name: "runNamespacesDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsCreate_580070, base: "/",
    url: url_RunNamespacesDomainmappingsCreate_580071, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsList_580043 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesDomainmappingsList_580045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsList_580044(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace from which the domain mappings should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580046 = path.getOrDefault("parent")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "parent", valid_580046
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_580047 = query.getOrDefault("key")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "key", valid_580047
  var valid_580048 = query.getOrDefault("includeUninitialized")
  valid_580048 = validateParameter(valid_580048, JBool, required = false, default = nil)
  if valid_580048 != nil:
    section.add "includeUninitialized", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
  var valid_580050 = query.getOrDefault("oauth_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "oauth_token", valid_580050
  var valid_580051 = query.getOrDefault("fieldSelector")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "fieldSelector", valid_580051
  var valid_580052 = query.getOrDefault("labelSelector")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "labelSelector", valid_580052
  var valid_580053 = query.getOrDefault("$.xgafv")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("1"))
  if valid_580053 != nil:
    section.add "$.xgafv", valid_580053
  var valid_580054 = query.getOrDefault("limit")
  valid_580054 = validateParameter(valid_580054, JInt, required = false, default = nil)
  if valid_580054 != nil:
    section.add "limit", valid_580054
  var valid_580055 = query.getOrDefault("alt")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("json"))
  if valid_580055 != nil:
    section.add "alt", valid_580055
  var valid_580056 = query.getOrDefault("uploadType")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "uploadType", valid_580056
  var valid_580057 = query.getOrDefault("quotaUser")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "quotaUser", valid_580057
  var valid_580058 = query.getOrDefault("watch")
  valid_580058 = validateParameter(valid_580058, JBool, required = false, default = nil)
  if valid_580058 != nil:
    section.add "watch", valid_580058
  var valid_580059 = query.getOrDefault("callback")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "callback", valid_580059
  var valid_580060 = query.getOrDefault("resourceVersion")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "resourceVersion", valid_580060
  var valid_580061 = query.getOrDefault("fields")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "fields", valid_580061
  var valid_580062 = query.getOrDefault("access_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "access_token", valid_580062
  var valid_580063 = query.getOrDefault("upload_protocol")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "upload_protocol", valid_580063
  var valid_580064 = query.getOrDefault("continue")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "continue", valid_580064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580065: Call_RunNamespacesDomainmappingsList_580043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List domain mappings.
  ## 
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_RunNamespacesDomainmappingsList_580043;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesDomainmappingsList
  ## List domain mappings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The namespace from which the domain mappings should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_580067 = newJObject()
  var query_580068 = newJObject()
  add(query_580068, "key", newJString(key))
  add(query_580068, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "fieldSelector", newJString(fieldSelector))
  add(query_580068, "labelSelector", newJString(labelSelector))
  add(query_580068, "$.xgafv", newJString(Xgafv))
  add(query_580068, "limit", newJInt(limit))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "uploadType", newJString(uploadType))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(query_580068, "watch", newJBool(watch))
  add(query_580068, "callback", newJString(callback))
  add(path_580067, "parent", newJString(parent))
  add(query_580068, "resourceVersion", newJString(resourceVersion))
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "access_token", newJString(accessToken))
  add(query_580068, "upload_protocol", newJString(uploadProtocol))
  add(query_580068, "continue", newJString(`continue`))
  result = call_580066.call(path_580067, query_580068, nil, nil, nil)

var runNamespacesDomainmappingsList* = Call_RunNamespacesDomainmappingsList_580043(
    name: "runNamespacesDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsList_580044, base: "/",
    url: url_RunNamespacesDomainmappingsList_580045, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsReplaceConfiguration_580109 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesConfigurationsReplaceConfiguration_580111(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsReplaceConfiguration_580110(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Replace a configuration.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the configuration being replaced.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580112 = path.getOrDefault("name")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "name", valid_580112
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
  var valid_580113 = query.getOrDefault("key")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "key", valid_580113
  var valid_580114 = query.getOrDefault("prettyPrint")
  valid_580114 = validateParameter(valid_580114, JBool, required = false,
                                 default = newJBool(true))
  if valid_580114 != nil:
    section.add "prettyPrint", valid_580114
  var valid_580115 = query.getOrDefault("oauth_token")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "oauth_token", valid_580115
  var valid_580116 = query.getOrDefault("$.xgafv")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("1"))
  if valid_580116 != nil:
    section.add "$.xgafv", valid_580116
  var valid_580117 = query.getOrDefault("alt")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = newJString("json"))
  if valid_580117 != nil:
    section.add "alt", valid_580117
  var valid_580118 = query.getOrDefault("uploadType")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "uploadType", valid_580118
  var valid_580119 = query.getOrDefault("quotaUser")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "quotaUser", valid_580119
  var valid_580120 = query.getOrDefault("callback")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "callback", valid_580120
  var valid_580121 = query.getOrDefault("fields")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "fields", valid_580121
  var valid_580122 = query.getOrDefault("access_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "access_token", valid_580122
  var valid_580123 = query.getOrDefault("upload_protocol")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "upload_protocol", valid_580123
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

proc call*(call_580125: Call_RunNamespacesConfigurationsReplaceConfiguration_580109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace a configuration.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_580125.validator(path, query, header, formData, body)
  let scheme = call_580125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580125.url(scheme.get, call_580125.host, call_580125.base,
                         call_580125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580125, url, valid)

proc call*(call_580126: Call_RunNamespacesConfigurationsReplaceConfiguration_580109;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesConfigurationsReplaceConfiguration
  ## Replace a configuration.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
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
  ##       : The name of the configuration being replaced.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580127 = newJObject()
  var query_580128 = newJObject()
  var body_580129 = newJObject()
  add(query_580128, "key", newJString(key))
  add(query_580128, "prettyPrint", newJBool(prettyPrint))
  add(query_580128, "oauth_token", newJString(oauthToken))
  add(query_580128, "$.xgafv", newJString(Xgafv))
  add(query_580128, "alt", newJString(alt))
  add(query_580128, "uploadType", newJString(uploadType))
  add(query_580128, "quotaUser", newJString(quotaUser))
  add(path_580127, "name", newJString(name))
  if body != nil:
    body_580129 = body
  add(query_580128, "callback", newJString(callback))
  add(query_580128, "fields", newJString(fields))
  add(query_580128, "access_token", newJString(accessToken))
  add(query_580128, "upload_protocol", newJString(uploadProtocol))
  result = call_580126.call(path_580127, query_580128, nil, nil, body_580129)

var runNamespacesConfigurationsReplaceConfiguration* = Call_RunNamespacesConfigurationsReplaceConfiguration_580109(
    name: "runNamespacesConfigurationsReplaceConfiguration",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsReplaceConfiguration_580110,
    base: "/", url: url_RunNamespacesConfigurationsReplaceConfiguration_580111,
    schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsGet_580090 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesConfigurationsGet_580092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsGet_580091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the configuration to retrieve.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580093 = path.getOrDefault("name")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "name", valid_580093
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
  var valid_580094 = query.getOrDefault("key")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "key", valid_580094
  var valid_580095 = query.getOrDefault("prettyPrint")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "prettyPrint", valid_580095
  var valid_580096 = query.getOrDefault("oauth_token")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "oauth_token", valid_580096
  var valid_580097 = query.getOrDefault("$.xgafv")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("1"))
  if valid_580097 != nil:
    section.add "$.xgafv", valid_580097
  var valid_580098 = query.getOrDefault("alt")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("json"))
  if valid_580098 != nil:
    section.add "alt", valid_580098
  var valid_580099 = query.getOrDefault("uploadType")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "uploadType", valid_580099
  var valid_580100 = query.getOrDefault("quotaUser")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "quotaUser", valid_580100
  var valid_580101 = query.getOrDefault("callback")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "callback", valid_580101
  var valid_580102 = query.getOrDefault("fields")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "fields", valid_580102
  var valid_580103 = query.getOrDefault("access_token")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "access_token", valid_580103
  var valid_580104 = query.getOrDefault("upload_protocol")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "upload_protocol", valid_580104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580105: Call_RunNamespacesConfigurationsGet_580090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a configuration.
  ## 
  let valid = call_580105.validator(path, query, header, formData, body)
  let scheme = call_580105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580105.url(scheme.get, call_580105.host, call_580105.base,
                         call_580105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580105, url, valid)

proc call*(call_580106: Call_RunNamespacesConfigurationsGet_580090; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesConfigurationsGet
  ## Get information about a configuration.
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
  ##       : The name of the configuration to retrieve.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580107 = newJObject()
  var query_580108 = newJObject()
  add(query_580108, "key", newJString(key))
  add(query_580108, "prettyPrint", newJBool(prettyPrint))
  add(query_580108, "oauth_token", newJString(oauthToken))
  add(query_580108, "$.xgafv", newJString(Xgafv))
  add(query_580108, "alt", newJString(alt))
  add(query_580108, "uploadType", newJString(uploadType))
  add(query_580108, "quotaUser", newJString(quotaUser))
  add(path_580107, "name", newJString(name))
  add(query_580108, "callback", newJString(callback))
  add(query_580108, "fields", newJString(fields))
  add(query_580108, "access_token", newJString(accessToken))
  add(query_580108, "upload_protocol", newJString(uploadProtocol))
  result = call_580106.call(path_580107, query_580108, nil, nil, nil)

var runNamespacesConfigurationsGet* = Call_RunNamespacesConfigurationsGet_580090(
    name: "runNamespacesConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsGet_580091, base: "/",
    url: url_RunNamespacesConfigurationsGet_580092, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsDelete_580130 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesConfigurationsDelete_580132(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsDelete_580131(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## delete a configuration.
  ## This will cause the configuration to delete all child revisions. Prior to
  ## calling this, any route referencing the configuration (or revision
  ## from the configuration) must be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the configuration to delete.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580133 = path.getOrDefault("name")
  valid_580133 = validateParameter(valid_580133, JString, required = true,
                                 default = nil)
  if valid_580133 != nil:
    section.add "name", valid_580133
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
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: JString
  ##           : JSONP
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580134 = query.getOrDefault("key")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "key", valid_580134
  var valid_580135 = query.getOrDefault("prettyPrint")
  valid_580135 = validateParameter(valid_580135, JBool, required = false,
                                 default = newJBool(true))
  if valid_580135 != nil:
    section.add "prettyPrint", valid_580135
  var valid_580136 = query.getOrDefault("oauth_token")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "oauth_token", valid_580136
  var valid_580137 = query.getOrDefault("$.xgafv")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = newJString("1"))
  if valid_580137 != nil:
    section.add "$.xgafv", valid_580137
  var valid_580138 = query.getOrDefault("alt")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = newJString("json"))
  if valid_580138 != nil:
    section.add "alt", valid_580138
  var valid_580139 = query.getOrDefault("uploadType")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "uploadType", valid_580139
  var valid_580140 = query.getOrDefault("quotaUser")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "quotaUser", valid_580140
  var valid_580141 = query.getOrDefault("propagationPolicy")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "propagationPolicy", valid_580141
  var valid_580142 = query.getOrDefault("callback")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "callback", valid_580142
  var valid_580143 = query.getOrDefault("apiVersion")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "apiVersion", valid_580143
  var valid_580144 = query.getOrDefault("kind")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "kind", valid_580144
  var valid_580145 = query.getOrDefault("fields")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "fields", valid_580145
  var valid_580146 = query.getOrDefault("access_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "access_token", valid_580146
  var valid_580147 = query.getOrDefault("upload_protocol")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "upload_protocol", valid_580147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580148: Call_RunNamespacesConfigurationsDelete_580130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## delete a configuration.
  ## This will cause the configuration to delete all child revisions. Prior to
  ## calling this, any route referencing the configuration (or revision
  ## from the configuration) must be deleted.
  ## 
  let valid = call_580148.validator(path, query, header, formData, body)
  let scheme = call_580148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580148.url(scheme.get, call_580148.host, call_580148.base,
                         call_580148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580148, url, valid)

proc call*(call_580149: Call_RunNamespacesConfigurationsDelete_580130;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          propagationPolicy: string = ""; callback: string = "";
          apiVersion: string = ""; kind: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesConfigurationsDelete
  ## delete a configuration.
  ## This will cause the configuration to delete all child revisions. Prior to
  ## calling this, any route referencing the configuration (or revision
  ## from the configuration) must be deleted.
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
  ##       : The name of the configuration to delete.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: string
  ##           : JSONP
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580150 = newJObject()
  var query_580151 = newJObject()
  add(query_580151, "key", newJString(key))
  add(query_580151, "prettyPrint", newJBool(prettyPrint))
  add(query_580151, "oauth_token", newJString(oauthToken))
  add(query_580151, "$.xgafv", newJString(Xgafv))
  add(query_580151, "alt", newJString(alt))
  add(query_580151, "uploadType", newJString(uploadType))
  add(query_580151, "quotaUser", newJString(quotaUser))
  add(path_580150, "name", newJString(name))
  add(query_580151, "propagationPolicy", newJString(propagationPolicy))
  add(query_580151, "callback", newJString(callback))
  add(query_580151, "apiVersion", newJString(apiVersion))
  add(query_580151, "kind", newJString(kind))
  add(query_580151, "fields", newJString(fields))
  add(query_580151, "access_token", newJString(accessToken))
  add(query_580151, "upload_protocol", newJString(uploadProtocol))
  result = call_580149.call(path_580150, query_580151, nil, nil, nil)

var runNamespacesConfigurationsDelete* = Call_RunNamespacesConfigurationsDelete_580130(
    name: "runNamespacesConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsDelete_580131, base: "/",
    url: url_RunNamespacesConfigurationsDelete_580132, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsCreate_580178 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesConfigurationsCreate_580180(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsCreate_580179(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace in which the configuration should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580181 = path.getOrDefault("parent")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "parent", valid_580181
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
  var valid_580182 = query.getOrDefault("key")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "key", valid_580182
  var valid_580183 = query.getOrDefault("prettyPrint")
  valid_580183 = validateParameter(valid_580183, JBool, required = false,
                                 default = newJBool(true))
  if valid_580183 != nil:
    section.add "prettyPrint", valid_580183
  var valid_580184 = query.getOrDefault("oauth_token")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "oauth_token", valid_580184
  var valid_580185 = query.getOrDefault("$.xgafv")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = newJString("1"))
  if valid_580185 != nil:
    section.add "$.xgafv", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("uploadType")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "uploadType", valid_580187
  var valid_580188 = query.getOrDefault("quotaUser")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "quotaUser", valid_580188
  var valid_580189 = query.getOrDefault("callback")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "callback", valid_580189
  var valid_580190 = query.getOrDefault("fields")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "fields", valid_580190
  var valid_580191 = query.getOrDefault("access_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "access_token", valid_580191
  var valid_580192 = query.getOrDefault("upload_protocol")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "upload_protocol", valid_580192
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

proc call*(call_580194: Call_RunNamespacesConfigurationsCreate_580178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a configuration.
  ## 
  let valid = call_580194.validator(path, query, header, formData, body)
  let scheme = call_580194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580194.url(scheme.get, call_580194.host, call_580194.base,
                         call_580194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580194, url, valid)

proc call*(call_580195: Call_RunNamespacesConfigurationsCreate_580178;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesConfigurationsCreate
  ## Create a configuration.
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
  ##         : The namespace in which the configuration should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580196 = newJObject()
  var query_580197 = newJObject()
  var body_580198 = newJObject()
  add(query_580197, "key", newJString(key))
  add(query_580197, "prettyPrint", newJBool(prettyPrint))
  add(query_580197, "oauth_token", newJString(oauthToken))
  add(query_580197, "$.xgafv", newJString(Xgafv))
  add(query_580197, "alt", newJString(alt))
  add(query_580197, "uploadType", newJString(uploadType))
  add(query_580197, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580198 = body
  add(query_580197, "callback", newJString(callback))
  add(path_580196, "parent", newJString(parent))
  add(query_580197, "fields", newJString(fields))
  add(query_580197, "access_token", newJString(accessToken))
  add(query_580197, "upload_protocol", newJString(uploadProtocol))
  result = call_580195.call(path_580196, query_580197, nil, nil, body_580198)

var runNamespacesConfigurationsCreate* = Call_RunNamespacesConfigurationsCreate_580178(
    name: "runNamespacesConfigurationsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsCreate_580179, base: "/",
    url: url_RunNamespacesConfigurationsCreate_580180, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsList_580152 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesConfigurationsList_580154(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsList_580153(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace from which the configurations should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580155 = path.getOrDefault("parent")
  valid_580155 = validateParameter(valid_580155, JString, required = true,
                                 default = nil)
  if valid_580155 != nil:
    section.add "parent", valid_580155
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_580156 = query.getOrDefault("key")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "key", valid_580156
  var valid_580157 = query.getOrDefault("includeUninitialized")
  valid_580157 = validateParameter(valid_580157, JBool, required = false, default = nil)
  if valid_580157 != nil:
    section.add "includeUninitialized", valid_580157
  var valid_580158 = query.getOrDefault("prettyPrint")
  valid_580158 = validateParameter(valid_580158, JBool, required = false,
                                 default = newJBool(true))
  if valid_580158 != nil:
    section.add "prettyPrint", valid_580158
  var valid_580159 = query.getOrDefault("oauth_token")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "oauth_token", valid_580159
  var valid_580160 = query.getOrDefault("fieldSelector")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "fieldSelector", valid_580160
  var valid_580161 = query.getOrDefault("labelSelector")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "labelSelector", valid_580161
  var valid_580162 = query.getOrDefault("$.xgafv")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = newJString("1"))
  if valid_580162 != nil:
    section.add "$.xgafv", valid_580162
  var valid_580163 = query.getOrDefault("limit")
  valid_580163 = validateParameter(valid_580163, JInt, required = false, default = nil)
  if valid_580163 != nil:
    section.add "limit", valid_580163
  var valid_580164 = query.getOrDefault("alt")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("json"))
  if valid_580164 != nil:
    section.add "alt", valid_580164
  var valid_580165 = query.getOrDefault("uploadType")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "uploadType", valid_580165
  var valid_580166 = query.getOrDefault("quotaUser")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "quotaUser", valid_580166
  var valid_580167 = query.getOrDefault("watch")
  valid_580167 = validateParameter(valid_580167, JBool, required = false, default = nil)
  if valid_580167 != nil:
    section.add "watch", valid_580167
  var valid_580168 = query.getOrDefault("callback")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "callback", valid_580168
  var valid_580169 = query.getOrDefault("resourceVersion")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "resourceVersion", valid_580169
  var valid_580170 = query.getOrDefault("fields")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "fields", valid_580170
  var valid_580171 = query.getOrDefault("access_token")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "access_token", valid_580171
  var valid_580172 = query.getOrDefault("upload_protocol")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "upload_protocol", valid_580172
  var valid_580173 = query.getOrDefault("continue")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "continue", valid_580173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580174: Call_RunNamespacesConfigurationsList_580152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List configurations.
  ## 
  let valid = call_580174.validator(path, query, header, formData, body)
  let scheme = call_580174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580174.url(scheme.get, call_580174.host, call_580174.base,
                         call_580174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580174, url, valid)

proc call*(call_580175: Call_RunNamespacesConfigurationsList_580152;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesConfigurationsList
  ## List configurations.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The namespace from which the configurations should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_580176 = newJObject()
  var query_580177 = newJObject()
  add(query_580177, "key", newJString(key))
  add(query_580177, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580177, "prettyPrint", newJBool(prettyPrint))
  add(query_580177, "oauth_token", newJString(oauthToken))
  add(query_580177, "fieldSelector", newJString(fieldSelector))
  add(query_580177, "labelSelector", newJString(labelSelector))
  add(query_580177, "$.xgafv", newJString(Xgafv))
  add(query_580177, "limit", newJInt(limit))
  add(query_580177, "alt", newJString(alt))
  add(query_580177, "uploadType", newJString(uploadType))
  add(query_580177, "quotaUser", newJString(quotaUser))
  add(query_580177, "watch", newJBool(watch))
  add(query_580177, "callback", newJString(callback))
  add(path_580176, "parent", newJString(parent))
  add(query_580177, "resourceVersion", newJString(resourceVersion))
  add(query_580177, "fields", newJString(fields))
  add(query_580177, "access_token", newJString(accessToken))
  add(query_580177, "upload_protocol", newJString(uploadProtocol))
  add(query_580177, "continue", newJString(`continue`))
  result = call_580175.call(path_580176, query_580177, nil, nil, nil)

var runNamespacesConfigurationsList* = Call_RunNamespacesConfigurationsList_580152(
    name: "runNamespacesConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsList_580153, base: "/",
    url: url_RunNamespacesConfigurationsList_580154, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsList_580199 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesRevisionsList_580201(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesRevisionsList_580200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace from which the revisions should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580202 = path.getOrDefault("parent")
  valid_580202 = validateParameter(valid_580202, JString, required = true,
                                 default = nil)
  if valid_580202 != nil:
    section.add "parent", valid_580202
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_580203 = query.getOrDefault("key")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "key", valid_580203
  var valid_580204 = query.getOrDefault("includeUninitialized")
  valid_580204 = validateParameter(valid_580204, JBool, required = false, default = nil)
  if valid_580204 != nil:
    section.add "includeUninitialized", valid_580204
  var valid_580205 = query.getOrDefault("prettyPrint")
  valid_580205 = validateParameter(valid_580205, JBool, required = false,
                                 default = newJBool(true))
  if valid_580205 != nil:
    section.add "prettyPrint", valid_580205
  var valid_580206 = query.getOrDefault("oauth_token")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "oauth_token", valid_580206
  var valid_580207 = query.getOrDefault("fieldSelector")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "fieldSelector", valid_580207
  var valid_580208 = query.getOrDefault("labelSelector")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "labelSelector", valid_580208
  var valid_580209 = query.getOrDefault("$.xgafv")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = newJString("1"))
  if valid_580209 != nil:
    section.add "$.xgafv", valid_580209
  var valid_580210 = query.getOrDefault("limit")
  valid_580210 = validateParameter(valid_580210, JInt, required = false, default = nil)
  if valid_580210 != nil:
    section.add "limit", valid_580210
  var valid_580211 = query.getOrDefault("alt")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("json"))
  if valid_580211 != nil:
    section.add "alt", valid_580211
  var valid_580212 = query.getOrDefault("uploadType")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "uploadType", valid_580212
  var valid_580213 = query.getOrDefault("quotaUser")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "quotaUser", valid_580213
  var valid_580214 = query.getOrDefault("watch")
  valid_580214 = validateParameter(valid_580214, JBool, required = false, default = nil)
  if valid_580214 != nil:
    section.add "watch", valid_580214
  var valid_580215 = query.getOrDefault("callback")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "callback", valid_580215
  var valid_580216 = query.getOrDefault("resourceVersion")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "resourceVersion", valid_580216
  var valid_580217 = query.getOrDefault("fields")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "fields", valid_580217
  var valid_580218 = query.getOrDefault("access_token")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "access_token", valid_580218
  var valid_580219 = query.getOrDefault("upload_protocol")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "upload_protocol", valid_580219
  var valid_580220 = query.getOrDefault("continue")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "continue", valid_580220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580221: Call_RunNamespacesRevisionsList_580199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List revisions.
  ## 
  let valid = call_580221.validator(path, query, header, formData, body)
  let scheme = call_580221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580221.url(scheme.get, call_580221.host, call_580221.base,
                         call_580221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580221, url, valid)

proc call*(call_580222: Call_RunNamespacesRevisionsList_580199; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesRevisionsList
  ## List revisions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The namespace from which the revisions should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_580223 = newJObject()
  var query_580224 = newJObject()
  add(query_580224, "key", newJString(key))
  add(query_580224, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580224, "prettyPrint", newJBool(prettyPrint))
  add(query_580224, "oauth_token", newJString(oauthToken))
  add(query_580224, "fieldSelector", newJString(fieldSelector))
  add(query_580224, "labelSelector", newJString(labelSelector))
  add(query_580224, "$.xgafv", newJString(Xgafv))
  add(query_580224, "limit", newJInt(limit))
  add(query_580224, "alt", newJString(alt))
  add(query_580224, "uploadType", newJString(uploadType))
  add(query_580224, "quotaUser", newJString(quotaUser))
  add(query_580224, "watch", newJBool(watch))
  add(query_580224, "callback", newJString(callback))
  add(path_580223, "parent", newJString(parent))
  add(query_580224, "resourceVersion", newJString(resourceVersion))
  add(query_580224, "fields", newJString(fields))
  add(query_580224, "access_token", newJString(accessToken))
  add(query_580224, "upload_protocol", newJString(uploadProtocol))
  add(query_580224, "continue", newJString(`continue`))
  result = call_580222.call(path_580223, query_580224, nil, nil, nil)

var runNamespacesRevisionsList* = Call_RunNamespacesRevisionsList_580199(
    name: "runNamespacesRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/revisions",
    validator: validate_RunNamespacesRevisionsList_580200, base: "/",
    url: url_RunNamespacesRevisionsList_580201, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesCreate_580251 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesRoutesCreate_580253(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesRoutesCreate_580252(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a route.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace in which the route should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580254 = path.getOrDefault("parent")
  valid_580254 = validateParameter(valid_580254, JString, required = true,
                                 default = nil)
  if valid_580254 != nil:
    section.add "parent", valid_580254
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
  var valid_580255 = query.getOrDefault("key")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "key", valid_580255
  var valid_580256 = query.getOrDefault("prettyPrint")
  valid_580256 = validateParameter(valid_580256, JBool, required = false,
                                 default = newJBool(true))
  if valid_580256 != nil:
    section.add "prettyPrint", valid_580256
  var valid_580257 = query.getOrDefault("oauth_token")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "oauth_token", valid_580257
  var valid_580258 = query.getOrDefault("$.xgafv")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = newJString("1"))
  if valid_580258 != nil:
    section.add "$.xgafv", valid_580258
  var valid_580259 = query.getOrDefault("alt")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = newJString("json"))
  if valid_580259 != nil:
    section.add "alt", valid_580259
  var valid_580260 = query.getOrDefault("uploadType")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "uploadType", valid_580260
  var valid_580261 = query.getOrDefault("quotaUser")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "quotaUser", valid_580261
  var valid_580262 = query.getOrDefault("callback")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "callback", valid_580262
  var valid_580263 = query.getOrDefault("fields")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "fields", valid_580263
  var valid_580264 = query.getOrDefault("access_token")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "access_token", valid_580264
  var valid_580265 = query.getOrDefault("upload_protocol")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "upload_protocol", valid_580265
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

proc call*(call_580267: Call_RunNamespacesRoutesCreate_580251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a route.
  ## 
  let valid = call_580267.validator(path, query, header, formData, body)
  let scheme = call_580267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580267.url(scheme.get, call_580267.host, call_580267.base,
                         call_580267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580267, url, valid)

proc call*(call_580268: Call_RunNamespacesRoutesCreate_580251; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesRoutesCreate
  ## Create a route.
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
  ##         : The namespace in which the route should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580269 = newJObject()
  var query_580270 = newJObject()
  var body_580271 = newJObject()
  add(query_580270, "key", newJString(key))
  add(query_580270, "prettyPrint", newJBool(prettyPrint))
  add(query_580270, "oauth_token", newJString(oauthToken))
  add(query_580270, "$.xgafv", newJString(Xgafv))
  add(query_580270, "alt", newJString(alt))
  add(query_580270, "uploadType", newJString(uploadType))
  add(query_580270, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580271 = body
  add(query_580270, "callback", newJString(callback))
  add(path_580269, "parent", newJString(parent))
  add(query_580270, "fields", newJString(fields))
  add(query_580270, "access_token", newJString(accessToken))
  add(query_580270, "upload_protocol", newJString(uploadProtocol))
  result = call_580268.call(path_580269, query_580270, nil, nil, body_580271)

var runNamespacesRoutesCreate* = Call_RunNamespacesRoutesCreate_580251(
    name: "runNamespacesRoutesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/routes",
    validator: validate_RunNamespacesRoutesCreate_580252, base: "/",
    url: url_RunNamespacesRoutesCreate_580253, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesList_580225 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesRoutesList_580227(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesRoutesList_580226(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List routes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace from which the routes should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580228 = path.getOrDefault("parent")
  valid_580228 = validateParameter(valid_580228, JString, required = true,
                                 default = nil)
  if valid_580228 != nil:
    section.add "parent", valid_580228
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_580229 = query.getOrDefault("key")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "key", valid_580229
  var valid_580230 = query.getOrDefault("includeUninitialized")
  valid_580230 = validateParameter(valid_580230, JBool, required = false, default = nil)
  if valid_580230 != nil:
    section.add "includeUninitialized", valid_580230
  var valid_580231 = query.getOrDefault("prettyPrint")
  valid_580231 = validateParameter(valid_580231, JBool, required = false,
                                 default = newJBool(true))
  if valid_580231 != nil:
    section.add "prettyPrint", valid_580231
  var valid_580232 = query.getOrDefault("oauth_token")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "oauth_token", valid_580232
  var valid_580233 = query.getOrDefault("fieldSelector")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "fieldSelector", valid_580233
  var valid_580234 = query.getOrDefault("labelSelector")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "labelSelector", valid_580234
  var valid_580235 = query.getOrDefault("$.xgafv")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = newJString("1"))
  if valid_580235 != nil:
    section.add "$.xgafv", valid_580235
  var valid_580236 = query.getOrDefault("limit")
  valid_580236 = validateParameter(valid_580236, JInt, required = false, default = nil)
  if valid_580236 != nil:
    section.add "limit", valid_580236
  var valid_580237 = query.getOrDefault("alt")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = newJString("json"))
  if valid_580237 != nil:
    section.add "alt", valid_580237
  var valid_580238 = query.getOrDefault("uploadType")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "uploadType", valid_580238
  var valid_580239 = query.getOrDefault("quotaUser")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "quotaUser", valid_580239
  var valid_580240 = query.getOrDefault("watch")
  valid_580240 = validateParameter(valid_580240, JBool, required = false, default = nil)
  if valid_580240 != nil:
    section.add "watch", valid_580240
  var valid_580241 = query.getOrDefault("callback")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "callback", valid_580241
  var valid_580242 = query.getOrDefault("resourceVersion")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "resourceVersion", valid_580242
  var valid_580243 = query.getOrDefault("fields")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "fields", valid_580243
  var valid_580244 = query.getOrDefault("access_token")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "access_token", valid_580244
  var valid_580245 = query.getOrDefault("upload_protocol")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "upload_protocol", valid_580245
  var valid_580246 = query.getOrDefault("continue")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "continue", valid_580246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580247: Call_RunNamespacesRoutesList_580225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List routes.
  ## 
  let valid = call_580247.validator(path, query, header, formData, body)
  let scheme = call_580247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580247.url(scheme.get, call_580247.host, call_580247.base,
                         call_580247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580247, url, valid)

proc call*(call_580248: Call_RunNamespacesRoutesList_580225; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesRoutesList
  ## List routes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The namespace from which the routes should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_580249 = newJObject()
  var query_580250 = newJObject()
  add(query_580250, "key", newJString(key))
  add(query_580250, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580250, "prettyPrint", newJBool(prettyPrint))
  add(query_580250, "oauth_token", newJString(oauthToken))
  add(query_580250, "fieldSelector", newJString(fieldSelector))
  add(query_580250, "labelSelector", newJString(labelSelector))
  add(query_580250, "$.xgafv", newJString(Xgafv))
  add(query_580250, "limit", newJInt(limit))
  add(query_580250, "alt", newJString(alt))
  add(query_580250, "uploadType", newJString(uploadType))
  add(query_580250, "quotaUser", newJString(quotaUser))
  add(query_580250, "watch", newJBool(watch))
  add(query_580250, "callback", newJString(callback))
  add(path_580249, "parent", newJString(parent))
  add(query_580250, "resourceVersion", newJString(resourceVersion))
  add(query_580250, "fields", newJString(fields))
  add(query_580250, "access_token", newJString(accessToken))
  add(query_580250, "upload_protocol", newJString(uploadProtocol))
  add(query_580250, "continue", newJString(`continue`))
  result = call_580248.call(path_580249, query_580250, nil, nil, nil)

var runNamespacesRoutesList* = Call_RunNamespacesRoutesList_580225(
    name: "runNamespacesRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/routes",
    validator: validate_RunNamespacesRoutesList_580226, base: "/",
    url: url_RunNamespacesRoutesList_580227, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesCreate_580298 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesServicesCreate_580300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesServicesCreate_580299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace in which the service should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580301 = path.getOrDefault("parent")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = nil)
  if valid_580301 != nil:
    section.add "parent", valid_580301
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
  var valid_580302 = query.getOrDefault("key")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "key", valid_580302
  var valid_580303 = query.getOrDefault("prettyPrint")
  valid_580303 = validateParameter(valid_580303, JBool, required = false,
                                 default = newJBool(true))
  if valid_580303 != nil:
    section.add "prettyPrint", valid_580303
  var valid_580304 = query.getOrDefault("oauth_token")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "oauth_token", valid_580304
  var valid_580305 = query.getOrDefault("$.xgafv")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = newJString("1"))
  if valid_580305 != nil:
    section.add "$.xgafv", valid_580305
  var valid_580306 = query.getOrDefault("alt")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = newJString("json"))
  if valid_580306 != nil:
    section.add "alt", valid_580306
  var valid_580307 = query.getOrDefault("uploadType")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "uploadType", valid_580307
  var valid_580308 = query.getOrDefault("quotaUser")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "quotaUser", valid_580308
  var valid_580309 = query.getOrDefault("callback")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "callback", valid_580309
  var valid_580310 = query.getOrDefault("fields")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "fields", valid_580310
  var valid_580311 = query.getOrDefault("access_token")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "access_token", valid_580311
  var valid_580312 = query.getOrDefault("upload_protocol")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "upload_protocol", valid_580312
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

proc call*(call_580314: Call_RunNamespacesServicesCreate_580298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a service.
  ## 
  let valid = call_580314.validator(path, query, header, formData, body)
  let scheme = call_580314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580314.url(scheme.get, call_580314.host, call_580314.base,
                         call_580314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580314, url, valid)

proc call*(call_580315: Call_RunNamespacesServicesCreate_580298; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesServicesCreate
  ## Create a service.
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
  ##         : The namespace in which the service should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580316 = newJObject()
  var query_580317 = newJObject()
  var body_580318 = newJObject()
  add(query_580317, "key", newJString(key))
  add(query_580317, "prettyPrint", newJBool(prettyPrint))
  add(query_580317, "oauth_token", newJString(oauthToken))
  add(query_580317, "$.xgafv", newJString(Xgafv))
  add(query_580317, "alt", newJString(alt))
  add(query_580317, "uploadType", newJString(uploadType))
  add(query_580317, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580318 = body
  add(query_580317, "callback", newJString(callback))
  add(path_580316, "parent", newJString(parent))
  add(query_580317, "fields", newJString(fields))
  add(query_580317, "access_token", newJString(accessToken))
  add(query_580317, "upload_protocol", newJString(uploadProtocol))
  result = call_580315.call(path_580316, query_580317, nil, nil, body_580318)

var runNamespacesServicesCreate* = Call_RunNamespacesServicesCreate_580298(
    name: "runNamespacesServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/services",
    validator: validate_RunNamespacesServicesCreate_580299, base: "/",
    url: url_RunNamespacesServicesCreate_580300, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesList_580272 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesServicesList_580274(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesServicesList_580273(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace from which the services should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580275 = path.getOrDefault("parent")
  valid_580275 = validateParameter(valid_580275, JString, required = true,
                                 default = nil)
  if valid_580275 != nil:
    section.add "parent", valid_580275
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_580276 = query.getOrDefault("key")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "key", valid_580276
  var valid_580277 = query.getOrDefault("includeUninitialized")
  valid_580277 = validateParameter(valid_580277, JBool, required = false, default = nil)
  if valid_580277 != nil:
    section.add "includeUninitialized", valid_580277
  var valid_580278 = query.getOrDefault("prettyPrint")
  valid_580278 = validateParameter(valid_580278, JBool, required = false,
                                 default = newJBool(true))
  if valid_580278 != nil:
    section.add "prettyPrint", valid_580278
  var valid_580279 = query.getOrDefault("oauth_token")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "oauth_token", valid_580279
  var valid_580280 = query.getOrDefault("fieldSelector")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "fieldSelector", valid_580280
  var valid_580281 = query.getOrDefault("labelSelector")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "labelSelector", valid_580281
  var valid_580282 = query.getOrDefault("$.xgafv")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = newJString("1"))
  if valid_580282 != nil:
    section.add "$.xgafv", valid_580282
  var valid_580283 = query.getOrDefault("limit")
  valid_580283 = validateParameter(valid_580283, JInt, required = false, default = nil)
  if valid_580283 != nil:
    section.add "limit", valid_580283
  var valid_580284 = query.getOrDefault("alt")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = newJString("json"))
  if valid_580284 != nil:
    section.add "alt", valid_580284
  var valid_580285 = query.getOrDefault("uploadType")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "uploadType", valid_580285
  var valid_580286 = query.getOrDefault("quotaUser")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "quotaUser", valid_580286
  var valid_580287 = query.getOrDefault("watch")
  valid_580287 = validateParameter(valid_580287, JBool, required = false, default = nil)
  if valid_580287 != nil:
    section.add "watch", valid_580287
  var valid_580288 = query.getOrDefault("callback")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "callback", valid_580288
  var valid_580289 = query.getOrDefault("resourceVersion")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "resourceVersion", valid_580289
  var valid_580290 = query.getOrDefault("fields")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "fields", valid_580290
  var valid_580291 = query.getOrDefault("access_token")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "access_token", valid_580291
  var valid_580292 = query.getOrDefault("upload_protocol")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "upload_protocol", valid_580292
  var valid_580293 = query.getOrDefault("continue")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "continue", valid_580293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580294: Call_RunNamespacesServicesList_580272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List services.
  ## 
  let valid = call_580294.validator(path, query, header, formData, body)
  let scheme = call_580294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580294.url(scheme.get, call_580294.host, call_580294.base,
                         call_580294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580294, url, valid)

proc call*(call_580295: Call_RunNamespacesServicesList_580272; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesServicesList
  ## List services.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The namespace from which the services should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_580296 = newJObject()
  var query_580297 = newJObject()
  add(query_580297, "key", newJString(key))
  add(query_580297, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580297, "prettyPrint", newJBool(prettyPrint))
  add(query_580297, "oauth_token", newJString(oauthToken))
  add(query_580297, "fieldSelector", newJString(fieldSelector))
  add(query_580297, "labelSelector", newJString(labelSelector))
  add(query_580297, "$.xgafv", newJString(Xgafv))
  add(query_580297, "limit", newJInt(limit))
  add(query_580297, "alt", newJString(alt))
  add(query_580297, "uploadType", newJString(uploadType))
  add(query_580297, "quotaUser", newJString(quotaUser))
  add(query_580297, "watch", newJBool(watch))
  add(query_580297, "callback", newJString(callback))
  add(path_580296, "parent", newJString(parent))
  add(query_580297, "resourceVersion", newJString(resourceVersion))
  add(query_580297, "fields", newJString(fields))
  add(query_580297, "access_token", newJString(accessToken))
  add(query_580297, "upload_protocol", newJString(uploadProtocol))
  add(query_580297, "continue", newJString(`continue`))
  result = call_580295.call(path_580296, query_580297, nil, nil, nil)

var runNamespacesServicesList* = Call_RunNamespacesServicesList_580272(
    name: "runNamespacesServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/services",
    validator: validate_RunNamespacesServicesList_580273, base: "/",
    url: url_RunNamespacesServicesList_580274, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580338 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580340(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580339(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being retrieved.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580341 = path.getOrDefault("name")
  valid_580341 = validateParameter(valid_580341, JString, required = true,
                                 default = nil)
  if valid_580341 != nil:
    section.add "name", valid_580341
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
  var valid_580342 = query.getOrDefault("key")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "key", valid_580342
  var valid_580343 = query.getOrDefault("prettyPrint")
  valid_580343 = validateParameter(valid_580343, JBool, required = false,
                                 default = newJBool(true))
  if valid_580343 != nil:
    section.add "prettyPrint", valid_580343
  var valid_580344 = query.getOrDefault("oauth_token")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "oauth_token", valid_580344
  var valid_580345 = query.getOrDefault("$.xgafv")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = newJString("1"))
  if valid_580345 != nil:
    section.add "$.xgafv", valid_580345
  var valid_580346 = query.getOrDefault("alt")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = newJString("json"))
  if valid_580346 != nil:
    section.add "alt", valid_580346
  var valid_580347 = query.getOrDefault("uploadType")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "uploadType", valid_580347
  var valid_580348 = query.getOrDefault("quotaUser")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "quotaUser", valid_580348
  var valid_580349 = query.getOrDefault("callback")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "callback", valid_580349
  var valid_580350 = query.getOrDefault("fields")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "fields", valid_580350
  var valid_580351 = query.getOrDefault("access_token")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "access_token", valid_580351
  var valid_580352 = query.getOrDefault("upload_protocol")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "upload_protocol", valid_580352
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

proc call*(call_580354: Call_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_580354.validator(path, query, header, formData, body)
  let scheme = call_580354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580354.url(scheme.get, call_580354.host, call_580354.base,
                         call_580354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580354, url, valid)

proc call*(call_580355: Call_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580338;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsReplaceDomainMapping
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
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
  ##       : The name of the domain mapping being retrieved.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580356 = newJObject()
  var query_580357 = newJObject()
  var body_580358 = newJObject()
  add(query_580357, "key", newJString(key))
  add(query_580357, "prettyPrint", newJBool(prettyPrint))
  add(query_580357, "oauth_token", newJString(oauthToken))
  add(query_580357, "$.xgafv", newJString(Xgafv))
  add(query_580357, "alt", newJString(alt))
  add(query_580357, "uploadType", newJString(uploadType))
  add(query_580357, "quotaUser", newJString(quotaUser))
  add(path_580356, "name", newJString(name))
  if body != nil:
    body_580358 = body
  add(query_580357, "callback", newJString(callback))
  add(query_580357, "fields", newJString(fields))
  add(query_580357, "access_token", newJString(accessToken))
  add(query_580357, "upload_protocol", newJString(uploadProtocol))
  result = call_580355.call(path_580356, query_580357, nil, nil, body_580358)

var runProjectsLocationsDomainmappingsReplaceDomainMapping* = Call_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580338(
    name: "runProjectsLocationsDomainmappingsReplaceDomainMapping",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580339,
    base: "/", url: url_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580340,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsGet_580319 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsDomainmappingsGet_580321(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsGet_580320(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping to retrieve.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580322 = path.getOrDefault("name")
  valid_580322 = validateParameter(valid_580322, JString, required = true,
                                 default = nil)
  if valid_580322 != nil:
    section.add "name", valid_580322
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
  var valid_580323 = query.getOrDefault("key")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "key", valid_580323
  var valid_580324 = query.getOrDefault("prettyPrint")
  valid_580324 = validateParameter(valid_580324, JBool, required = false,
                                 default = newJBool(true))
  if valid_580324 != nil:
    section.add "prettyPrint", valid_580324
  var valid_580325 = query.getOrDefault("oauth_token")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "oauth_token", valid_580325
  var valid_580326 = query.getOrDefault("$.xgafv")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("1"))
  if valid_580326 != nil:
    section.add "$.xgafv", valid_580326
  var valid_580327 = query.getOrDefault("alt")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = newJString("json"))
  if valid_580327 != nil:
    section.add "alt", valid_580327
  var valid_580328 = query.getOrDefault("uploadType")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "uploadType", valid_580328
  var valid_580329 = query.getOrDefault("quotaUser")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "quotaUser", valid_580329
  var valid_580330 = query.getOrDefault("callback")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "callback", valid_580330
  var valid_580331 = query.getOrDefault("fields")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "fields", valid_580331
  var valid_580332 = query.getOrDefault("access_token")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "access_token", valid_580332
  var valid_580333 = query.getOrDefault("upload_protocol")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "upload_protocol", valid_580333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580334: Call_RunProjectsLocationsDomainmappingsGet_580319;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about a domain mapping.
  ## 
  let valid = call_580334.validator(path, query, header, formData, body)
  let scheme = call_580334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580334.url(scheme.get, call_580334.host, call_580334.base,
                         call_580334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580334, url, valid)

proc call*(call_580335: Call_RunProjectsLocationsDomainmappingsGet_580319;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsGet
  ## Get information about a domain mapping.
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
  ##       : The name of the domain mapping to retrieve.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580336 = newJObject()
  var query_580337 = newJObject()
  add(query_580337, "key", newJString(key))
  add(query_580337, "prettyPrint", newJBool(prettyPrint))
  add(query_580337, "oauth_token", newJString(oauthToken))
  add(query_580337, "$.xgafv", newJString(Xgafv))
  add(query_580337, "alt", newJString(alt))
  add(query_580337, "uploadType", newJString(uploadType))
  add(query_580337, "quotaUser", newJString(quotaUser))
  add(path_580336, "name", newJString(name))
  add(query_580337, "callback", newJString(callback))
  add(query_580337, "fields", newJString(fields))
  add(query_580337, "access_token", newJString(accessToken))
  add(query_580337, "upload_protocol", newJString(uploadProtocol))
  result = call_580335.call(path_580336, query_580337, nil, nil, nil)

var runProjectsLocationsDomainmappingsGet* = Call_RunProjectsLocationsDomainmappingsGet_580319(
    name: "runProjectsLocationsDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsGet_580320, base: "/",
    url: url_RunProjectsLocationsDomainmappingsGet_580321, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsDelete_580359 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsDomainmappingsDelete_580361(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsDelete_580360(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping to delete.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580362 = path.getOrDefault("name")
  valid_580362 = validateParameter(valid_580362, JString, required = true,
                                 default = nil)
  if valid_580362 != nil:
    section.add "name", valid_580362
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
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: JString
  ##           : JSONP
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580363 = query.getOrDefault("key")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "key", valid_580363
  var valid_580364 = query.getOrDefault("prettyPrint")
  valid_580364 = validateParameter(valid_580364, JBool, required = false,
                                 default = newJBool(true))
  if valid_580364 != nil:
    section.add "prettyPrint", valid_580364
  var valid_580365 = query.getOrDefault("oauth_token")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "oauth_token", valid_580365
  var valid_580366 = query.getOrDefault("$.xgafv")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = newJString("1"))
  if valid_580366 != nil:
    section.add "$.xgafv", valid_580366
  var valid_580367 = query.getOrDefault("alt")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = newJString("json"))
  if valid_580367 != nil:
    section.add "alt", valid_580367
  var valid_580368 = query.getOrDefault("uploadType")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "uploadType", valid_580368
  var valid_580369 = query.getOrDefault("quotaUser")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "quotaUser", valid_580369
  var valid_580370 = query.getOrDefault("propagationPolicy")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "propagationPolicy", valid_580370
  var valid_580371 = query.getOrDefault("callback")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "callback", valid_580371
  var valid_580372 = query.getOrDefault("apiVersion")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "apiVersion", valid_580372
  var valid_580373 = query.getOrDefault("kind")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "kind", valid_580373
  var valid_580374 = query.getOrDefault("fields")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "fields", valid_580374
  var valid_580375 = query.getOrDefault("access_token")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "access_token", valid_580375
  var valid_580376 = query.getOrDefault("upload_protocol")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "upload_protocol", valid_580376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580377: Call_RunProjectsLocationsDomainmappingsDelete_580359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a domain mapping.
  ## 
  let valid = call_580377.validator(path, query, header, formData, body)
  let scheme = call_580377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580377.url(scheme.get, call_580377.host, call_580377.base,
                         call_580377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580377, url, valid)

proc call*(call_580378: Call_RunProjectsLocationsDomainmappingsDelete_580359;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          propagationPolicy: string = ""; callback: string = "";
          apiVersion: string = ""; kind: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsDelete
  ## Delete a domain mapping.
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
  ##       : The name of the domain mapping to delete.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: string
  ##           : JSONP
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580379 = newJObject()
  var query_580380 = newJObject()
  add(query_580380, "key", newJString(key))
  add(query_580380, "prettyPrint", newJBool(prettyPrint))
  add(query_580380, "oauth_token", newJString(oauthToken))
  add(query_580380, "$.xgafv", newJString(Xgafv))
  add(query_580380, "alt", newJString(alt))
  add(query_580380, "uploadType", newJString(uploadType))
  add(query_580380, "quotaUser", newJString(quotaUser))
  add(path_580379, "name", newJString(name))
  add(query_580380, "propagationPolicy", newJString(propagationPolicy))
  add(query_580380, "callback", newJString(callback))
  add(query_580380, "apiVersion", newJString(apiVersion))
  add(query_580380, "kind", newJString(kind))
  add(query_580380, "fields", newJString(fields))
  add(query_580380, "access_token", newJString(accessToken))
  add(query_580380, "upload_protocol", newJString(uploadProtocol))
  result = call_580378.call(path_580379, query_580380, nil, nil, nil)

var runProjectsLocationsDomainmappingsDelete* = Call_RunProjectsLocationsDomainmappingsDelete_580359(
    name: "runProjectsLocationsDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsDelete_580360,
    base: "/", url: url_RunProjectsLocationsDomainmappingsDelete_580361,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsList_580381 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsList_580383(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsList_580382(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580384 = path.getOrDefault("name")
  valid_580384 = validateParameter(valid_580384, JString, required = true,
                                 default = nil)
  if valid_580384 != nil:
    section.add "name", valid_580384
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
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580385 = query.getOrDefault("key")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "key", valid_580385
  var valid_580386 = query.getOrDefault("prettyPrint")
  valid_580386 = validateParameter(valid_580386, JBool, required = false,
                                 default = newJBool(true))
  if valid_580386 != nil:
    section.add "prettyPrint", valid_580386
  var valid_580387 = query.getOrDefault("oauth_token")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "oauth_token", valid_580387
  var valid_580388 = query.getOrDefault("$.xgafv")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = newJString("1"))
  if valid_580388 != nil:
    section.add "$.xgafv", valid_580388
  var valid_580389 = query.getOrDefault("pageSize")
  valid_580389 = validateParameter(valid_580389, JInt, required = false, default = nil)
  if valid_580389 != nil:
    section.add "pageSize", valid_580389
  var valid_580390 = query.getOrDefault("alt")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = newJString("json"))
  if valid_580390 != nil:
    section.add "alt", valid_580390
  var valid_580391 = query.getOrDefault("uploadType")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "uploadType", valid_580391
  var valid_580392 = query.getOrDefault("quotaUser")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "quotaUser", valid_580392
  var valid_580393 = query.getOrDefault("filter")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "filter", valid_580393
  var valid_580394 = query.getOrDefault("pageToken")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "pageToken", valid_580394
  var valid_580395 = query.getOrDefault("callback")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "callback", valid_580395
  var valid_580396 = query.getOrDefault("fields")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "fields", valid_580396
  var valid_580397 = query.getOrDefault("access_token")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "access_token", valid_580397
  var valid_580398 = query.getOrDefault("upload_protocol")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "upload_protocol", valid_580398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580399: Call_RunProjectsLocationsList_580381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580399.validator(path, query, header, formData, body)
  let scheme = call_580399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580399.url(scheme.get, call_580399.host, call_580399.base,
                         call_580399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580399, url, valid)

proc call*(call_580400: Call_RunProjectsLocationsList_580381; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580401 = newJObject()
  var query_580402 = newJObject()
  add(query_580402, "key", newJString(key))
  add(query_580402, "prettyPrint", newJBool(prettyPrint))
  add(query_580402, "oauth_token", newJString(oauthToken))
  add(query_580402, "$.xgafv", newJString(Xgafv))
  add(query_580402, "pageSize", newJInt(pageSize))
  add(query_580402, "alt", newJString(alt))
  add(query_580402, "uploadType", newJString(uploadType))
  add(query_580402, "quotaUser", newJString(quotaUser))
  add(path_580401, "name", newJString(name))
  add(query_580402, "filter", newJString(filter))
  add(query_580402, "pageToken", newJString(pageToken))
  add(query_580402, "callback", newJString(callback))
  add(query_580402, "fields", newJString(fields))
  add(query_580402, "access_token", newJString(accessToken))
  add(query_580402, "upload_protocol", newJString(uploadProtocol))
  result = call_580400.call(path_580401, query_580402, nil, nil, nil)

var runProjectsLocationsList* = Call_RunProjectsLocationsList_580381(
    name: "runProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_RunProjectsLocationsList_580382, base: "/",
    url: url_RunProjectsLocationsList_580383, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAuthorizeddomainsList_580403 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsAuthorizeddomainsList_580405(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/authorizeddomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsAuthorizeddomainsList_580404(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List authorized domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580406 = path.getOrDefault("parent")
  valid_580406 = validateParameter(valid_580406, JString, required = true,
                                 default = nil)
  if valid_580406 != nil:
    section.add "parent", valid_580406
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
  ##           : Maximum results to return per page.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580407 = query.getOrDefault("key")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "key", valid_580407
  var valid_580408 = query.getOrDefault("prettyPrint")
  valid_580408 = validateParameter(valid_580408, JBool, required = false,
                                 default = newJBool(true))
  if valid_580408 != nil:
    section.add "prettyPrint", valid_580408
  var valid_580409 = query.getOrDefault("oauth_token")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "oauth_token", valid_580409
  var valid_580410 = query.getOrDefault("$.xgafv")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = newJString("1"))
  if valid_580410 != nil:
    section.add "$.xgafv", valid_580410
  var valid_580411 = query.getOrDefault("pageSize")
  valid_580411 = validateParameter(valid_580411, JInt, required = false, default = nil)
  if valid_580411 != nil:
    section.add "pageSize", valid_580411
  var valid_580412 = query.getOrDefault("alt")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = newJString("json"))
  if valid_580412 != nil:
    section.add "alt", valid_580412
  var valid_580413 = query.getOrDefault("uploadType")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "uploadType", valid_580413
  var valid_580414 = query.getOrDefault("quotaUser")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "quotaUser", valid_580414
  var valid_580415 = query.getOrDefault("pageToken")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "pageToken", valid_580415
  var valid_580416 = query.getOrDefault("callback")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "callback", valid_580416
  var valid_580417 = query.getOrDefault("fields")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "fields", valid_580417
  var valid_580418 = query.getOrDefault("access_token")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "access_token", valid_580418
  var valid_580419 = query.getOrDefault("upload_protocol")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "upload_protocol", valid_580419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580420: Call_RunProjectsLocationsAuthorizeddomainsList_580403;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List authorized domains.
  ## 
  let valid = call_580420.validator(path, query, header, formData, body)
  let scheme = call_580420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580420.url(scheme.get, call_580420.host, call_580420.base,
                         call_580420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580420, url, valid)

proc call*(call_580421: Call_RunProjectsLocationsAuthorizeddomainsList_580403;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsAuthorizeddomainsList
  ## List authorized domains.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580422 = newJObject()
  var query_580423 = newJObject()
  add(query_580423, "key", newJString(key))
  add(query_580423, "prettyPrint", newJBool(prettyPrint))
  add(query_580423, "oauth_token", newJString(oauthToken))
  add(query_580423, "$.xgafv", newJString(Xgafv))
  add(query_580423, "pageSize", newJInt(pageSize))
  add(query_580423, "alt", newJString(alt))
  add(query_580423, "uploadType", newJString(uploadType))
  add(query_580423, "quotaUser", newJString(quotaUser))
  add(query_580423, "pageToken", newJString(pageToken))
  add(query_580423, "callback", newJString(callback))
  add(path_580422, "parent", newJString(parent))
  add(query_580423, "fields", newJString(fields))
  add(query_580423, "access_token", newJString(accessToken))
  add(query_580423, "upload_protocol", newJString(uploadProtocol))
  result = call_580421.call(path_580422, query_580423, nil, nil, nil)

var runProjectsLocationsAuthorizeddomainsList* = Call_RunProjectsLocationsAuthorizeddomainsList_580403(
    name: "runProjectsLocationsAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/authorizeddomains",
    validator: validate_RunProjectsLocationsAuthorizeddomainsList_580404,
    base: "/", url: url_RunProjectsLocationsAuthorizeddomainsList_580405,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAutodomainmappingsCreate_580450 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsAutodomainmappingsCreate_580452(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autodomainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsAutodomainmappingsCreate_580451(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new auto domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580453 = path.getOrDefault("parent")
  valid_580453 = validateParameter(valid_580453, JString, required = true,
                                 default = nil)
  if valid_580453 != nil:
    section.add "parent", valid_580453
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
  var valid_580454 = query.getOrDefault("key")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "key", valid_580454
  var valid_580455 = query.getOrDefault("prettyPrint")
  valid_580455 = validateParameter(valid_580455, JBool, required = false,
                                 default = newJBool(true))
  if valid_580455 != nil:
    section.add "prettyPrint", valid_580455
  var valid_580456 = query.getOrDefault("oauth_token")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "oauth_token", valid_580456
  var valid_580457 = query.getOrDefault("$.xgafv")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = newJString("1"))
  if valid_580457 != nil:
    section.add "$.xgafv", valid_580457
  var valid_580458 = query.getOrDefault("alt")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = newJString("json"))
  if valid_580458 != nil:
    section.add "alt", valid_580458
  var valid_580459 = query.getOrDefault("uploadType")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "uploadType", valid_580459
  var valid_580460 = query.getOrDefault("quotaUser")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "quotaUser", valid_580460
  var valid_580461 = query.getOrDefault("callback")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "callback", valid_580461
  var valid_580462 = query.getOrDefault("fields")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "fields", valid_580462
  var valid_580463 = query.getOrDefault("access_token")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "access_token", valid_580463
  var valid_580464 = query.getOrDefault("upload_protocol")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "upload_protocol", valid_580464
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

proc call*(call_580466: Call_RunProjectsLocationsAutodomainmappingsCreate_580450;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new auto domain mapping.
  ## 
  let valid = call_580466.validator(path, query, header, formData, body)
  let scheme = call_580466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580466.url(scheme.get, call_580466.host, call_580466.base,
                         call_580466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580466, url, valid)

proc call*(call_580467: Call_RunProjectsLocationsAutodomainmappingsCreate_580450;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsAutodomainmappingsCreate
  ## Creates a new auto domain mapping.
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
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580468 = newJObject()
  var query_580469 = newJObject()
  var body_580470 = newJObject()
  add(query_580469, "key", newJString(key))
  add(query_580469, "prettyPrint", newJBool(prettyPrint))
  add(query_580469, "oauth_token", newJString(oauthToken))
  add(query_580469, "$.xgafv", newJString(Xgafv))
  add(query_580469, "alt", newJString(alt))
  add(query_580469, "uploadType", newJString(uploadType))
  add(query_580469, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580470 = body
  add(query_580469, "callback", newJString(callback))
  add(path_580468, "parent", newJString(parent))
  add(query_580469, "fields", newJString(fields))
  add(query_580469, "access_token", newJString(accessToken))
  add(query_580469, "upload_protocol", newJString(uploadProtocol))
  result = call_580467.call(path_580468, query_580469, nil, nil, body_580470)

var runProjectsLocationsAutodomainmappingsCreate* = Call_RunProjectsLocationsAutodomainmappingsCreate_580450(
    name: "runProjectsLocationsAutodomainmappingsCreate",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1/{parent}/autodomainmappings",
    validator: validate_RunProjectsLocationsAutodomainmappingsCreate_580451,
    base: "/", url: url_RunProjectsLocationsAutodomainmappingsCreate_580452,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAutodomainmappingsList_580424 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsAutodomainmappingsList_580426(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autodomainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsAutodomainmappingsList_580425(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List auto domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580427 = path.getOrDefault("parent")
  valid_580427 = validateParameter(valid_580427, JString, required = true,
                                 default = nil)
  if valid_580427 != nil:
    section.add "parent", valid_580427
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_580428 = query.getOrDefault("key")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "key", valid_580428
  var valid_580429 = query.getOrDefault("includeUninitialized")
  valid_580429 = validateParameter(valid_580429, JBool, required = false, default = nil)
  if valid_580429 != nil:
    section.add "includeUninitialized", valid_580429
  var valid_580430 = query.getOrDefault("prettyPrint")
  valid_580430 = validateParameter(valid_580430, JBool, required = false,
                                 default = newJBool(true))
  if valid_580430 != nil:
    section.add "prettyPrint", valid_580430
  var valid_580431 = query.getOrDefault("oauth_token")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "oauth_token", valid_580431
  var valid_580432 = query.getOrDefault("fieldSelector")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "fieldSelector", valid_580432
  var valid_580433 = query.getOrDefault("labelSelector")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "labelSelector", valid_580433
  var valid_580434 = query.getOrDefault("$.xgafv")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = newJString("1"))
  if valid_580434 != nil:
    section.add "$.xgafv", valid_580434
  var valid_580435 = query.getOrDefault("limit")
  valid_580435 = validateParameter(valid_580435, JInt, required = false, default = nil)
  if valid_580435 != nil:
    section.add "limit", valid_580435
  var valid_580436 = query.getOrDefault("alt")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = newJString("json"))
  if valid_580436 != nil:
    section.add "alt", valid_580436
  var valid_580437 = query.getOrDefault("uploadType")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "uploadType", valid_580437
  var valid_580438 = query.getOrDefault("quotaUser")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "quotaUser", valid_580438
  var valid_580439 = query.getOrDefault("watch")
  valid_580439 = validateParameter(valid_580439, JBool, required = false, default = nil)
  if valid_580439 != nil:
    section.add "watch", valid_580439
  var valid_580440 = query.getOrDefault("callback")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "callback", valid_580440
  var valid_580441 = query.getOrDefault("resourceVersion")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "resourceVersion", valid_580441
  var valid_580442 = query.getOrDefault("fields")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "fields", valid_580442
  var valid_580443 = query.getOrDefault("access_token")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "access_token", valid_580443
  var valid_580444 = query.getOrDefault("upload_protocol")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "upload_protocol", valid_580444
  var valid_580445 = query.getOrDefault("continue")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "continue", valid_580445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580446: Call_RunProjectsLocationsAutodomainmappingsList_580424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List auto domain mappings.
  ## 
  let valid = call_580446.validator(path, query, header, formData, body)
  let scheme = call_580446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580446.url(scheme.get, call_580446.host, call_580446.base,
                         call_580446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580446, url, valid)

proc call*(call_580447: Call_RunProjectsLocationsAutodomainmappingsList_580424;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsAutodomainmappingsList
  ## List auto domain mappings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_580448 = newJObject()
  var query_580449 = newJObject()
  add(query_580449, "key", newJString(key))
  add(query_580449, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580449, "prettyPrint", newJBool(prettyPrint))
  add(query_580449, "oauth_token", newJString(oauthToken))
  add(query_580449, "fieldSelector", newJString(fieldSelector))
  add(query_580449, "labelSelector", newJString(labelSelector))
  add(query_580449, "$.xgafv", newJString(Xgafv))
  add(query_580449, "limit", newJInt(limit))
  add(query_580449, "alt", newJString(alt))
  add(query_580449, "uploadType", newJString(uploadType))
  add(query_580449, "quotaUser", newJString(quotaUser))
  add(query_580449, "watch", newJBool(watch))
  add(query_580449, "callback", newJString(callback))
  add(path_580448, "parent", newJString(parent))
  add(query_580449, "resourceVersion", newJString(resourceVersion))
  add(query_580449, "fields", newJString(fields))
  add(query_580449, "access_token", newJString(accessToken))
  add(query_580449, "upload_protocol", newJString(uploadProtocol))
  add(query_580449, "continue", newJString(`continue`))
  result = call_580447.call(path_580448, query_580449, nil, nil, nil)

var runProjectsLocationsAutodomainmappingsList* = Call_RunProjectsLocationsAutodomainmappingsList_580424(
    name: "runProjectsLocationsAutodomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/autodomainmappings",
    validator: validate_RunProjectsLocationsAutodomainmappingsList_580425,
    base: "/", url: url_RunProjectsLocationsAutodomainmappingsList_580426,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsCreate_580497 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsConfigurationsCreate_580499(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsConfigurationsCreate_580498(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace in which the configuration should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580500 = path.getOrDefault("parent")
  valid_580500 = validateParameter(valid_580500, JString, required = true,
                                 default = nil)
  if valid_580500 != nil:
    section.add "parent", valid_580500
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
  var valid_580501 = query.getOrDefault("key")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "key", valid_580501
  var valid_580502 = query.getOrDefault("prettyPrint")
  valid_580502 = validateParameter(valid_580502, JBool, required = false,
                                 default = newJBool(true))
  if valid_580502 != nil:
    section.add "prettyPrint", valid_580502
  var valid_580503 = query.getOrDefault("oauth_token")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "oauth_token", valid_580503
  var valid_580504 = query.getOrDefault("$.xgafv")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = newJString("1"))
  if valid_580504 != nil:
    section.add "$.xgafv", valid_580504
  var valid_580505 = query.getOrDefault("alt")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = newJString("json"))
  if valid_580505 != nil:
    section.add "alt", valid_580505
  var valid_580506 = query.getOrDefault("uploadType")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "uploadType", valid_580506
  var valid_580507 = query.getOrDefault("quotaUser")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "quotaUser", valid_580507
  var valid_580508 = query.getOrDefault("callback")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "callback", valid_580508
  var valid_580509 = query.getOrDefault("fields")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "fields", valid_580509
  var valid_580510 = query.getOrDefault("access_token")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "access_token", valid_580510
  var valid_580511 = query.getOrDefault("upload_protocol")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "upload_protocol", valid_580511
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

proc call*(call_580513: Call_RunProjectsLocationsConfigurationsCreate_580497;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a configuration.
  ## 
  let valid = call_580513.validator(path, query, header, formData, body)
  let scheme = call_580513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580513.url(scheme.get, call_580513.host, call_580513.base,
                         call_580513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580513, url, valid)

proc call*(call_580514: Call_RunProjectsLocationsConfigurationsCreate_580497;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsConfigurationsCreate
  ## Create a configuration.
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
  ##         : The namespace in which the configuration should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580515 = newJObject()
  var query_580516 = newJObject()
  var body_580517 = newJObject()
  add(query_580516, "key", newJString(key))
  add(query_580516, "prettyPrint", newJBool(prettyPrint))
  add(query_580516, "oauth_token", newJString(oauthToken))
  add(query_580516, "$.xgafv", newJString(Xgafv))
  add(query_580516, "alt", newJString(alt))
  add(query_580516, "uploadType", newJString(uploadType))
  add(query_580516, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580517 = body
  add(query_580516, "callback", newJString(callback))
  add(path_580515, "parent", newJString(parent))
  add(query_580516, "fields", newJString(fields))
  add(query_580516, "access_token", newJString(accessToken))
  add(query_580516, "upload_protocol", newJString(uploadProtocol))
  result = call_580514.call(path_580515, query_580516, nil, nil, body_580517)

var runProjectsLocationsConfigurationsCreate* = Call_RunProjectsLocationsConfigurationsCreate_580497(
    name: "runProjectsLocationsConfigurationsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsCreate_580498,
    base: "/", url: url_RunProjectsLocationsConfigurationsCreate_580499,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsList_580471 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsConfigurationsList_580473(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsConfigurationsList_580472(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace from which the configurations should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580474 = path.getOrDefault("parent")
  valid_580474 = validateParameter(valid_580474, JString, required = true,
                                 default = nil)
  if valid_580474 != nil:
    section.add "parent", valid_580474
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_580475 = query.getOrDefault("key")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "key", valid_580475
  var valid_580476 = query.getOrDefault("includeUninitialized")
  valid_580476 = validateParameter(valid_580476, JBool, required = false, default = nil)
  if valid_580476 != nil:
    section.add "includeUninitialized", valid_580476
  var valid_580477 = query.getOrDefault("prettyPrint")
  valid_580477 = validateParameter(valid_580477, JBool, required = false,
                                 default = newJBool(true))
  if valid_580477 != nil:
    section.add "prettyPrint", valid_580477
  var valid_580478 = query.getOrDefault("oauth_token")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "oauth_token", valid_580478
  var valid_580479 = query.getOrDefault("fieldSelector")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "fieldSelector", valid_580479
  var valid_580480 = query.getOrDefault("labelSelector")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "labelSelector", valid_580480
  var valid_580481 = query.getOrDefault("$.xgafv")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = newJString("1"))
  if valid_580481 != nil:
    section.add "$.xgafv", valid_580481
  var valid_580482 = query.getOrDefault("limit")
  valid_580482 = validateParameter(valid_580482, JInt, required = false, default = nil)
  if valid_580482 != nil:
    section.add "limit", valid_580482
  var valid_580483 = query.getOrDefault("alt")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = newJString("json"))
  if valid_580483 != nil:
    section.add "alt", valid_580483
  var valid_580484 = query.getOrDefault("uploadType")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "uploadType", valid_580484
  var valid_580485 = query.getOrDefault("quotaUser")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "quotaUser", valid_580485
  var valid_580486 = query.getOrDefault("watch")
  valid_580486 = validateParameter(valid_580486, JBool, required = false, default = nil)
  if valid_580486 != nil:
    section.add "watch", valid_580486
  var valid_580487 = query.getOrDefault("callback")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "callback", valid_580487
  var valid_580488 = query.getOrDefault("resourceVersion")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "resourceVersion", valid_580488
  var valid_580489 = query.getOrDefault("fields")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "fields", valid_580489
  var valid_580490 = query.getOrDefault("access_token")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "access_token", valid_580490
  var valid_580491 = query.getOrDefault("upload_protocol")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "upload_protocol", valid_580491
  var valid_580492 = query.getOrDefault("continue")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "continue", valid_580492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580493: Call_RunProjectsLocationsConfigurationsList_580471;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List configurations.
  ## 
  let valid = call_580493.validator(path, query, header, formData, body)
  let scheme = call_580493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580493.url(scheme.get, call_580493.host, call_580493.base,
                         call_580493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580493, url, valid)

proc call*(call_580494: Call_RunProjectsLocationsConfigurationsList_580471;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsConfigurationsList
  ## List configurations.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The namespace from which the configurations should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_580495 = newJObject()
  var query_580496 = newJObject()
  add(query_580496, "key", newJString(key))
  add(query_580496, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580496, "prettyPrint", newJBool(prettyPrint))
  add(query_580496, "oauth_token", newJString(oauthToken))
  add(query_580496, "fieldSelector", newJString(fieldSelector))
  add(query_580496, "labelSelector", newJString(labelSelector))
  add(query_580496, "$.xgafv", newJString(Xgafv))
  add(query_580496, "limit", newJInt(limit))
  add(query_580496, "alt", newJString(alt))
  add(query_580496, "uploadType", newJString(uploadType))
  add(query_580496, "quotaUser", newJString(quotaUser))
  add(query_580496, "watch", newJBool(watch))
  add(query_580496, "callback", newJString(callback))
  add(path_580495, "parent", newJString(parent))
  add(query_580496, "resourceVersion", newJString(resourceVersion))
  add(query_580496, "fields", newJString(fields))
  add(query_580496, "access_token", newJString(accessToken))
  add(query_580496, "upload_protocol", newJString(uploadProtocol))
  add(query_580496, "continue", newJString(`continue`))
  result = call_580494.call(path_580495, query_580496, nil, nil, nil)

var runProjectsLocationsConfigurationsList* = Call_RunProjectsLocationsConfigurationsList_580471(
    name: "runProjectsLocationsConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsList_580472, base: "/",
    url: url_RunProjectsLocationsConfigurationsList_580473,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsCreate_580544 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsDomainmappingsCreate_580546(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsCreate_580545(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace in which the domain mapping should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580547 = path.getOrDefault("parent")
  valid_580547 = validateParameter(valid_580547, JString, required = true,
                                 default = nil)
  if valid_580547 != nil:
    section.add "parent", valid_580547
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
  var valid_580548 = query.getOrDefault("key")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "key", valid_580548
  var valid_580549 = query.getOrDefault("prettyPrint")
  valid_580549 = validateParameter(valid_580549, JBool, required = false,
                                 default = newJBool(true))
  if valid_580549 != nil:
    section.add "prettyPrint", valid_580549
  var valid_580550 = query.getOrDefault("oauth_token")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "oauth_token", valid_580550
  var valid_580551 = query.getOrDefault("$.xgafv")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = newJString("1"))
  if valid_580551 != nil:
    section.add "$.xgafv", valid_580551
  var valid_580552 = query.getOrDefault("alt")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = newJString("json"))
  if valid_580552 != nil:
    section.add "alt", valid_580552
  var valid_580553 = query.getOrDefault("uploadType")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "uploadType", valid_580553
  var valid_580554 = query.getOrDefault("quotaUser")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "quotaUser", valid_580554
  var valid_580555 = query.getOrDefault("callback")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "callback", valid_580555
  var valid_580556 = query.getOrDefault("fields")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "fields", valid_580556
  var valid_580557 = query.getOrDefault("access_token")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "access_token", valid_580557
  var valid_580558 = query.getOrDefault("upload_protocol")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "upload_protocol", valid_580558
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

proc call*(call_580560: Call_RunProjectsLocationsDomainmappingsCreate_580544;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new domain mapping.
  ## 
  let valid = call_580560.validator(path, query, header, formData, body)
  let scheme = call_580560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580560.url(scheme.get, call_580560.host, call_580560.base,
                         call_580560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580560, url, valid)

proc call*(call_580561: Call_RunProjectsLocationsDomainmappingsCreate_580544;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsCreate
  ## Create a new domain mapping.
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
  ##         : The namespace in which the domain mapping should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580562 = newJObject()
  var query_580563 = newJObject()
  var body_580564 = newJObject()
  add(query_580563, "key", newJString(key))
  add(query_580563, "prettyPrint", newJBool(prettyPrint))
  add(query_580563, "oauth_token", newJString(oauthToken))
  add(query_580563, "$.xgafv", newJString(Xgafv))
  add(query_580563, "alt", newJString(alt))
  add(query_580563, "uploadType", newJString(uploadType))
  add(query_580563, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580564 = body
  add(query_580563, "callback", newJString(callback))
  add(path_580562, "parent", newJString(parent))
  add(query_580563, "fields", newJString(fields))
  add(query_580563, "access_token", newJString(accessToken))
  add(query_580563, "upload_protocol", newJString(uploadProtocol))
  result = call_580561.call(path_580562, query_580563, nil, nil, body_580564)

var runProjectsLocationsDomainmappingsCreate* = Call_RunProjectsLocationsDomainmappingsCreate_580544(
    name: "runProjectsLocationsDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsCreate_580545,
    base: "/", url: url_RunProjectsLocationsDomainmappingsCreate_580546,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsList_580518 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsDomainmappingsList_580520(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsList_580519(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace from which the domain mappings should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580521 = path.getOrDefault("parent")
  valid_580521 = validateParameter(valid_580521, JString, required = true,
                                 default = nil)
  if valid_580521 != nil:
    section.add "parent", valid_580521
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_580522 = query.getOrDefault("key")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "key", valid_580522
  var valid_580523 = query.getOrDefault("includeUninitialized")
  valid_580523 = validateParameter(valid_580523, JBool, required = false, default = nil)
  if valid_580523 != nil:
    section.add "includeUninitialized", valid_580523
  var valid_580524 = query.getOrDefault("prettyPrint")
  valid_580524 = validateParameter(valid_580524, JBool, required = false,
                                 default = newJBool(true))
  if valid_580524 != nil:
    section.add "prettyPrint", valid_580524
  var valid_580525 = query.getOrDefault("oauth_token")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "oauth_token", valid_580525
  var valid_580526 = query.getOrDefault("fieldSelector")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "fieldSelector", valid_580526
  var valid_580527 = query.getOrDefault("labelSelector")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "labelSelector", valid_580527
  var valid_580528 = query.getOrDefault("$.xgafv")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = newJString("1"))
  if valid_580528 != nil:
    section.add "$.xgafv", valid_580528
  var valid_580529 = query.getOrDefault("limit")
  valid_580529 = validateParameter(valid_580529, JInt, required = false, default = nil)
  if valid_580529 != nil:
    section.add "limit", valid_580529
  var valid_580530 = query.getOrDefault("alt")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = newJString("json"))
  if valid_580530 != nil:
    section.add "alt", valid_580530
  var valid_580531 = query.getOrDefault("uploadType")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "uploadType", valid_580531
  var valid_580532 = query.getOrDefault("quotaUser")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "quotaUser", valid_580532
  var valid_580533 = query.getOrDefault("watch")
  valid_580533 = validateParameter(valid_580533, JBool, required = false, default = nil)
  if valid_580533 != nil:
    section.add "watch", valid_580533
  var valid_580534 = query.getOrDefault("callback")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "callback", valid_580534
  var valid_580535 = query.getOrDefault("resourceVersion")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "resourceVersion", valid_580535
  var valid_580536 = query.getOrDefault("fields")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "fields", valid_580536
  var valid_580537 = query.getOrDefault("access_token")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "access_token", valid_580537
  var valid_580538 = query.getOrDefault("upload_protocol")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "upload_protocol", valid_580538
  var valid_580539 = query.getOrDefault("continue")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "continue", valid_580539
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580540: Call_RunProjectsLocationsDomainmappingsList_580518;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List domain mappings.
  ## 
  let valid = call_580540.validator(path, query, header, formData, body)
  let scheme = call_580540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580540.url(scheme.get, call_580540.host, call_580540.base,
                         call_580540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580540, url, valid)

proc call*(call_580541: Call_RunProjectsLocationsDomainmappingsList_580518;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsList
  ## List domain mappings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The namespace from which the domain mappings should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_580542 = newJObject()
  var query_580543 = newJObject()
  add(query_580543, "key", newJString(key))
  add(query_580543, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580543, "prettyPrint", newJBool(prettyPrint))
  add(query_580543, "oauth_token", newJString(oauthToken))
  add(query_580543, "fieldSelector", newJString(fieldSelector))
  add(query_580543, "labelSelector", newJString(labelSelector))
  add(query_580543, "$.xgafv", newJString(Xgafv))
  add(query_580543, "limit", newJInt(limit))
  add(query_580543, "alt", newJString(alt))
  add(query_580543, "uploadType", newJString(uploadType))
  add(query_580543, "quotaUser", newJString(quotaUser))
  add(query_580543, "watch", newJBool(watch))
  add(query_580543, "callback", newJString(callback))
  add(path_580542, "parent", newJString(parent))
  add(query_580543, "resourceVersion", newJString(resourceVersion))
  add(query_580543, "fields", newJString(fields))
  add(query_580543, "access_token", newJString(accessToken))
  add(query_580543, "upload_protocol", newJString(uploadProtocol))
  add(query_580543, "continue", newJString(`continue`))
  result = call_580541.call(path_580542, query_580543, nil, nil, nil)

var runProjectsLocationsDomainmappingsList* = Call_RunProjectsLocationsDomainmappingsList_580518(
    name: "runProjectsLocationsDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsList_580519, base: "/",
    url: url_RunProjectsLocationsDomainmappingsList_580520,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRevisionsList_580565 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsRevisionsList_580567(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsRevisionsList_580566(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace from which the revisions should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580568 = path.getOrDefault("parent")
  valid_580568 = validateParameter(valid_580568, JString, required = true,
                                 default = nil)
  if valid_580568 != nil:
    section.add "parent", valid_580568
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_580569 = query.getOrDefault("key")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "key", valid_580569
  var valid_580570 = query.getOrDefault("includeUninitialized")
  valid_580570 = validateParameter(valid_580570, JBool, required = false, default = nil)
  if valid_580570 != nil:
    section.add "includeUninitialized", valid_580570
  var valid_580571 = query.getOrDefault("prettyPrint")
  valid_580571 = validateParameter(valid_580571, JBool, required = false,
                                 default = newJBool(true))
  if valid_580571 != nil:
    section.add "prettyPrint", valid_580571
  var valid_580572 = query.getOrDefault("oauth_token")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "oauth_token", valid_580572
  var valid_580573 = query.getOrDefault("fieldSelector")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = nil)
  if valid_580573 != nil:
    section.add "fieldSelector", valid_580573
  var valid_580574 = query.getOrDefault("labelSelector")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "labelSelector", valid_580574
  var valid_580575 = query.getOrDefault("$.xgafv")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = newJString("1"))
  if valid_580575 != nil:
    section.add "$.xgafv", valid_580575
  var valid_580576 = query.getOrDefault("limit")
  valid_580576 = validateParameter(valid_580576, JInt, required = false, default = nil)
  if valid_580576 != nil:
    section.add "limit", valid_580576
  var valid_580577 = query.getOrDefault("alt")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = newJString("json"))
  if valid_580577 != nil:
    section.add "alt", valid_580577
  var valid_580578 = query.getOrDefault("uploadType")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "uploadType", valid_580578
  var valid_580579 = query.getOrDefault("quotaUser")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "quotaUser", valid_580579
  var valid_580580 = query.getOrDefault("watch")
  valid_580580 = validateParameter(valid_580580, JBool, required = false, default = nil)
  if valid_580580 != nil:
    section.add "watch", valid_580580
  var valid_580581 = query.getOrDefault("callback")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "callback", valid_580581
  var valid_580582 = query.getOrDefault("resourceVersion")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "resourceVersion", valid_580582
  var valid_580583 = query.getOrDefault("fields")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "fields", valid_580583
  var valid_580584 = query.getOrDefault("access_token")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "access_token", valid_580584
  var valid_580585 = query.getOrDefault("upload_protocol")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "upload_protocol", valid_580585
  var valid_580586 = query.getOrDefault("continue")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = nil)
  if valid_580586 != nil:
    section.add "continue", valid_580586
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580587: Call_RunProjectsLocationsRevisionsList_580565;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List revisions.
  ## 
  let valid = call_580587.validator(path, query, header, formData, body)
  let scheme = call_580587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580587.url(scheme.get, call_580587.host, call_580587.base,
                         call_580587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580587, url, valid)

proc call*(call_580588: Call_RunProjectsLocationsRevisionsList_580565;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsRevisionsList
  ## List revisions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The namespace from which the revisions should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_580589 = newJObject()
  var query_580590 = newJObject()
  add(query_580590, "key", newJString(key))
  add(query_580590, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580590, "prettyPrint", newJBool(prettyPrint))
  add(query_580590, "oauth_token", newJString(oauthToken))
  add(query_580590, "fieldSelector", newJString(fieldSelector))
  add(query_580590, "labelSelector", newJString(labelSelector))
  add(query_580590, "$.xgafv", newJString(Xgafv))
  add(query_580590, "limit", newJInt(limit))
  add(query_580590, "alt", newJString(alt))
  add(query_580590, "uploadType", newJString(uploadType))
  add(query_580590, "quotaUser", newJString(quotaUser))
  add(query_580590, "watch", newJBool(watch))
  add(query_580590, "callback", newJString(callback))
  add(path_580589, "parent", newJString(parent))
  add(query_580590, "resourceVersion", newJString(resourceVersion))
  add(query_580590, "fields", newJString(fields))
  add(query_580590, "access_token", newJString(accessToken))
  add(query_580590, "upload_protocol", newJString(uploadProtocol))
  add(query_580590, "continue", newJString(`continue`))
  result = call_580588.call(path_580589, query_580590, nil, nil, nil)

var runProjectsLocationsRevisionsList* = Call_RunProjectsLocationsRevisionsList_580565(
    name: "runProjectsLocationsRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/revisions",
    validator: validate_RunProjectsLocationsRevisionsList_580566, base: "/",
    url: url_RunProjectsLocationsRevisionsList_580567, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesCreate_580617 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsRoutesCreate_580619(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsRoutesCreate_580618(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a route.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace in which the route should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580620 = path.getOrDefault("parent")
  valid_580620 = validateParameter(valid_580620, JString, required = true,
                                 default = nil)
  if valid_580620 != nil:
    section.add "parent", valid_580620
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
  var valid_580621 = query.getOrDefault("key")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = nil)
  if valid_580621 != nil:
    section.add "key", valid_580621
  var valid_580622 = query.getOrDefault("prettyPrint")
  valid_580622 = validateParameter(valid_580622, JBool, required = false,
                                 default = newJBool(true))
  if valid_580622 != nil:
    section.add "prettyPrint", valid_580622
  var valid_580623 = query.getOrDefault("oauth_token")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = nil)
  if valid_580623 != nil:
    section.add "oauth_token", valid_580623
  var valid_580624 = query.getOrDefault("$.xgafv")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = newJString("1"))
  if valid_580624 != nil:
    section.add "$.xgafv", valid_580624
  var valid_580625 = query.getOrDefault("alt")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = newJString("json"))
  if valid_580625 != nil:
    section.add "alt", valid_580625
  var valid_580626 = query.getOrDefault("uploadType")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "uploadType", valid_580626
  var valid_580627 = query.getOrDefault("quotaUser")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "quotaUser", valid_580627
  var valid_580628 = query.getOrDefault("callback")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "callback", valid_580628
  var valid_580629 = query.getOrDefault("fields")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "fields", valid_580629
  var valid_580630 = query.getOrDefault("access_token")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "access_token", valid_580630
  var valid_580631 = query.getOrDefault("upload_protocol")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "upload_protocol", valid_580631
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

proc call*(call_580633: Call_RunProjectsLocationsRoutesCreate_580617;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a route.
  ## 
  let valid = call_580633.validator(path, query, header, formData, body)
  let scheme = call_580633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580633.url(scheme.get, call_580633.host, call_580633.base,
                         call_580633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580633, url, valid)

proc call*(call_580634: Call_RunProjectsLocationsRoutesCreate_580617;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsRoutesCreate
  ## Create a route.
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
  ##         : The namespace in which the route should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580635 = newJObject()
  var query_580636 = newJObject()
  var body_580637 = newJObject()
  add(query_580636, "key", newJString(key))
  add(query_580636, "prettyPrint", newJBool(prettyPrint))
  add(query_580636, "oauth_token", newJString(oauthToken))
  add(query_580636, "$.xgafv", newJString(Xgafv))
  add(query_580636, "alt", newJString(alt))
  add(query_580636, "uploadType", newJString(uploadType))
  add(query_580636, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580637 = body
  add(query_580636, "callback", newJString(callback))
  add(path_580635, "parent", newJString(parent))
  add(query_580636, "fields", newJString(fields))
  add(query_580636, "access_token", newJString(accessToken))
  add(query_580636, "upload_protocol", newJString(uploadProtocol))
  result = call_580634.call(path_580635, query_580636, nil, nil, body_580637)

var runProjectsLocationsRoutesCreate* = Call_RunProjectsLocationsRoutesCreate_580617(
    name: "runProjectsLocationsRoutesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesCreate_580618, base: "/",
    url: url_RunProjectsLocationsRoutesCreate_580619, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesList_580591 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsRoutesList_580593(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsRoutesList_580592(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List routes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace from which the routes should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580594 = path.getOrDefault("parent")
  valid_580594 = validateParameter(valid_580594, JString, required = true,
                                 default = nil)
  if valid_580594 != nil:
    section.add "parent", valid_580594
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_580595 = query.getOrDefault("key")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "key", valid_580595
  var valid_580596 = query.getOrDefault("includeUninitialized")
  valid_580596 = validateParameter(valid_580596, JBool, required = false, default = nil)
  if valid_580596 != nil:
    section.add "includeUninitialized", valid_580596
  var valid_580597 = query.getOrDefault("prettyPrint")
  valid_580597 = validateParameter(valid_580597, JBool, required = false,
                                 default = newJBool(true))
  if valid_580597 != nil:
    section.add "prettyPrint", valid_580597
  var valid_580598 = query.getOrDefault("oauth_token")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "oauth_token", valid_580598
  var valid_580599 = query.getOrDefault("fieldSelector")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "fieldSelector", valid_580599
  var valid_580600 = query.getOrDefault("labelSelector")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "labelSelector", valid_580600
  var valid_580601 = query.getOrDefault("$.xgafv")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = newJString("1"))
  if valid_580601 != nil:
    section.add "$.xgafv", valid_580601
  var valid_580602 = query.getOrDefault("limit")
  valid_580602 = validateParameter(valid_580602, JInt, required = false, default = nil)
  if valid_580602 != nil:
    section.add "limit", valid_580602
  var valid_580603 = query.getOrDefault("alt")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = newJString("json"))
  if valid_580603 != nil:
    section.add "alt", valid_580603
  var valid_580604 = query.getOrDefault("uploadType")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "uploadType", valid_580604
  var valid_580605 = query.getOrDefault("quotaUser")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "quotaUser", valid_580605
  var valid_580606 = query.getOrDefault("watch")
  valid_580606 = validateParameter(valid_580606, JBool, required = false, default = nil)
  if valid_580606 != nil:
    section.add "watch", valid_580606
  var valid_580607 = query.getOrDefault("callback")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "callback", valid_580607
  var valid_580608 = query.getOrDefault("resourceVersion")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "resourceVersion", valid_580608
  var valid_580609 = query.getOrDefault("fields")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "fields", valid_580609
  var valid_580610 = query.getOrDefault("access_token")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "access_token", valid_580610
  var valid_580611 = query.getOrDefault("upload_protocol")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "upload_protocol", valid_580611
  var valid_580612 = query.getOrDefault("continue")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "continue", valid_580612
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580613: Call_RunProjectsLocationsRoutesList_580591; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List routes.
  ## 
  let valid = call_580613.validator(path, query, header, formData, body)
  let scheme = call_580613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580613.url(scheme.get, call_580613.host, call_580613.base,
                         call_580613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580613, url, valid)

proc call*(call_580614: Call_RunProjectsLocationsRoutesList_580591; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsRoutesList
  ## List routes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The namespace from which the routes should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_580615 = newJObject()
  var query_580616 = newJObject()
  add(query_580616, "key", newJString(key))
  add(query_580616, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580616, "prettyPrint", newJBool(prettyPrint))
  add(query_580616, "oauth_token", newJString(oauthToken))
  add(query_580616, "fieldSelector", newJString(fieldSelector))
  add(query_580616, "labelSelector", newJString(labelSelector))
  add(query_580616, "$.xgafv", newJString(Xgafv))
  add(query_580616, "limit", newJInt(limit))
  add(query_580616, "alt", newJString(alt))
  add(query_580616, "uploadType", newJString(uploadType))
  add(query_580616, "quotaUser", newJString(quotaUser))
  add(query_580616, "watch", newJBool(watch))
  add(query_580616, "callback", newJString(callback))
  add(path_580615, "parent", newJString(parent))
  add(query_580616, "resourceVersion", newJString(resourceVersion))
  add(query_580616, "fields", newJString(fields))
  add(query_580616, "access_token", newJString(accessToken))
  add(query_580616, "upload_protocol", newJString(uploadProtocol))
  add(query_580616, "continue", newJString(`continue`))
  result = call_580614.call(path_580615, query_580616, nil, nil, nil)

var runProjectsLocationsRoutesList* = Call_RunProjectsLocationsRoutesList_580591(
    name: "runProjectsLocationsRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesList_580592, base: "/",
    url: url_RunProjectsLocationsRoutesList_580593, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesCreate_580664 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsServicesCreate_580666(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesCreate_580665(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace in which the service should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580667 = path.getOrDefault("parent")
  valid_580667 = validateParameter(valid_580667, JString, required = true,
                                 default = nil)
  if valid_580667 != nil:
    section.add "parent", valid_580667
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
  var valid_580668 = query.getOrDefault("key")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "key", valid_580668
  var valid_580669 = query.getOrDefault("prettyPrint")
  valid_580669 = validateParameter(valid_580669, JBool, required = false,
                                 default = newJBool(true))
  if valid_580669 != nil:
    section.add "prettyPrint", valid_580669
  var valid_580670 = query.getOrDefault("oauth_token")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "oauth_token", valid_580670
  var valid_580671 = query.getOrDefault("$.xgafv")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = newJString("1"))
  if valid_580671 != nil:
    section.add "$.xgafv", valid_580671
  var valid_580672 = query.getOrDefault("alt")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = newJString("json"))
  if valid_580672 != nil:
    section.add "alt", valid_580672
  var valid_580673 = query.getOrDefault("uploadType")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "uploadType", valid_580673
  var valid_580674 = query.getOrDefault("quotaUser")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "quotaUser", valid_580674
  var valid_580675 = query.getOrDefault("callback")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = nil)
  if valid_580675 != nil:
    section.add "callback", valid_580675
  var valid_580676 = query.getOrDefault("fields")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = nil)
  if valid_580676 != nil:
    section.add "fields", valid_580676
  var valid_580677 = query.getOrDefault("access_token")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "access_token", valid_580677
  var valid_580678 = query.getOrDefault("upload_protocol")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "upload_protocol", valid_580678
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

proc call*(call_580680: Call_RunProjectsLocationsServicesCreate_580664;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a service.
  ## 
  let valid = call_580680.validator(path, query, header, formData, body)
  let scheme = call_580680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580680.url(scheme.get, call_580680.host, call_580680.base,
                         call_580680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580680, url, valid)

proc call*(call_580681: Call_RunProjectsLocationsServicesCreate_580664;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesCreate
  ## Create a service.
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
  ##         : The namespace in which the service should be created.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580682 = newJObject()
  var query_580683 = newJObject()
  var body_580684 = newJObject()
  add(query_580683, "key", newJString(key))
  add(query_580683, "prettyPrint", newJBool(prettyPrint))
  add(query_580683, "oauth_token", newJString(oauthToken))
  add(query_580683, "$.xgafv", newJString(Xgafv))
  add(query_580683, "alt", newJString(alt))
  add(query_580683, "uploadType", newJString(uploadType))
  add(query_580683, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580684 = body
  add(query_580683, "callback", newJString(callback))
  add(path_580682, "parent", newJString(parent))
  add(query_580683, "fields", newJString(fields))
  add(query_580683, "access_token", newJString(accessToken))
  add(query_580683, "upload_protocol", newJString(uploadProtocol))
  result = call_580681.call(path_580682, query_580683, nil, nil, body_580684)

var runProjectsLocationsServicesCreate* = Call_RunProjectsLocationsServicesCreate_580664(
    name: "runProjectsLocationsServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesCreate_580665, base: "/",
    url: url_RunProjectsLocationsServicesCreate_580666, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesList_580638 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsServicesList_580640(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesList_580639(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The namespace from which the services should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580641 = path.getOrDefault("parent")
  valid_580641 = validateParameter(valid_580641, JString, required = true,
                                 default = nil)
  if valid_580641 != nil:
    section.add "parent", valid_580641
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_580642 = query.getOrDefault("key")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "key", valid_580642
  var valid_580643 = query.getOrDefault("includeUninitialized")
  valid_580643 = validateParameter(valid_580643, JBool, required = false, default = nil)
  if valid_580643 != nil:
    section.add "includeUninitialized", valid_580643
  var valid_580644 = query.getOrDefault("prettyPrint")
  valid_580644 = validateParameter(valid_580644, JBool, required = false,
                                 default = newJBool(true))
  if valid_580644 != nil:
    section.add "prettyPrint", valid_580644
  var valid_580645 = query.getOrDefault("oauth_token")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = nil)
  if valid_580645 != nil:
    section.add "oauth_token", valid_580645
  var valid_580646 = query.getOrDefault("fieldSelector")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "fieldSelector", valid_580646
  var valid_580647 = query.getOrDefault("labelSelector")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "labelSelector", valid_580647
  var valid_580648 = query.getOrDefault("$.xgafv")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = newJString("1"))
  if valid_580648 != nil:
    section.add "$.xgafv", valid_580648
  var valid_580649 = query.getOrDefault("limit")
  valid_580649 = validateParameter(valid_580649, JInt, required = false, default = nil)
  if valid_580649 != nil:
    section.add "limit", valid_580649
  var valid_580650 = query.getOrDefault("alt")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = newJString("json"))
  if valid_580650 != nil:
    section.add "alt", valid_580650
  var valid_580651 = query.getOrDefault("uploadType")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "uploadType", valid_580651
  var valid_580652 = query.getOrDefault("quotaUser")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "quotaUser", valid_580652
  var valid_580653 = query.getOrDefault("watch")
  valid_580653 = validateParameter(valid_580653, JBool, required = false, default = nil)
  if valid_580653 != nil:
    section.add "watch", valid_580653
  var valid_580654 = query.getOrDefault("callback")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "callback", valid_580654
  var valid_580655 = query.getOrDefault("resourceVersion")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "resourceVersion", valid_580655
  var valid_580656 = query.getOrDefault("fields")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = nil)
  if valid_580656 != nil:
    section.add "fields", valid_580656
  var valid_580657 = query.getOrDefault("access_token")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "access_token", valid_580657
  var valid_580658 = query.getOrDefault("upload_protocol")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = nil)
  if valid_580658 != nil:
    section.add "upload_protocol", valid_580658
  var valid_580659 = query.getOrDefault("continue")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "continue", valid_580659
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580660: Call_RunProjectsLocationsServicesList_580638;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List services.
  ## 
  let valid = call_580660.validator(path, query, header, formData, body)
  let scheme = call_580660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580660.url(scheme.get, call_580660.host, call_580660.base,
                         call_580660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580660, url, valid)

proc call*(call_580661: Call_RunProjectsLocationsServicesList_580638;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsServicesList
  ## List services.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The namespace from which the services should be listed.
  ## For Cloud Run (fully managed), replace {namespace_id} with the project ID
  ## or number.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_580662 = newJObject()
  var query_580663 = newJObject()
  add(query_580663, "key", newJString(key))
  add(query_580663, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580663, "prettyPrint", newJBool(prettyPrint))
  add(query_580663, "oauth_token", newJString(oauthToken))
  add(query_580663, "fieldSelector", newJString(fieldSelector))
  add(query_580663, "labelSelector", newJString(labelSelector))
  add(query_580663, "$.xgafv", newJString(Xgafv))
  add(query_580663, "limit", newJInt(limit))
  add(query_580663, "alt", newJString(alt))
  add(query_580663, "uploadType", newJString(uploadType))
  add(query_580663, "quotaUser", newJString(quotaUser))
  add(query_580663, "watch", newJBool(watch))
  add(query_580663, "callback", newJString(callback))
  add(path_580662, "parent", newJString(parent))
  add(query_580663, "resourceVersion", newJString(resourceVersion))
  add(query_580663, "fields", newJString(fields))
  add(query_580663, "access_token", newJString(accessToken))
  add(query_580663, "upload_protocol", newJString(uploadProtocol))
  add(query_580663, "continue", newJString(`continue`))
  result = call_580661.call(path_580662, query_580663, nil, nil, nil)

var runProjectsLocationsServicesList* = Call_RunProjectsLocationsServicesList_580638(
    name: "runProjectsLocationsServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesList_580639, base: "/",
    url: url_RunProjectsLocationsServicesList_580640, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesGetIamPolicy_580685 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsServicesGetIamPolicy_580687(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesGetIamPolicy_580686(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580688 = path.getOrDefault("resource")
  valid_580688 = validateParameter(valid_580688, JString, required = true,
                                 default = nil)
  if valid_580688 != nil:
    section.add "resource", valid_580688
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
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
  var valid_580689 = query.getOrDefault("key")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "key", valid_580689
  var valid_580690 = query.getOrDefault("prettyPrint")
  valid_580690 = validateParameter(valid_580690, JBool, required = false,
                                 default = newJBool(true))
  if valid_580690 != nil:
    section.add "prettyPrint", valid_580690
  var valid_580691 = query.getOrDefault("oauth_token")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "oauth_token", valid_580691
  var valid_580692 = query.getOrDefault("$.xgafv")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = newJString("1"))
  if valid_580692 != nil:
    section.add "$.xgafv", valid_580692
  var valid_580693 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580693 = validateParameter(valid_580693, JInt, required = false, default = nil)
  if valid_580693 != nil:
    section.add "options.requestedPolicyVersion", valid_580693
  var valid_580694 = query.getOrDefault("alt")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = newJString("json"))
  if valid_580694 != nil:
    section.add "alt", valid_580694
  var valid_580695 = query.getOrDefault("uploadType")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "uploadType", valid_580695
  var valid_580696 = query.getOrDefault("quotaUser")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "quotaUser", valid_580696
  var valid_580697 = query.getOrDefault("callback")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "callback", valid_580697
  var valid_580698 = query.getOrDefault("fields")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "fields", valid_580698
  var valid_580699 = query.getOrDefault("access_token")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "access_token", valid_580699
  var valid_580700 = query.getOrDefault("upload_protocol")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "upload_protocol", valid_580700
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580701: Call_RunProjectsLocationsServicesGetIamPolicy_580685;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  let valid = call_580701.validator(path, query, header, formData, body)
  let scheme = call_580701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580701.url(scheme.get, call_580701.host, call_580701.base,
                         call_580701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580701, url, valid)

proc call*(call_580702: Call_RunProjectsLocationsServicesGetIamPolicy_580685;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesGetIamPolicy
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580703 = newJObject()
  var query_580704 = newJObject()
  add(query_580704, "key", newJString(key))
  add(query_580704, "prettyPrint", newJBool(prettyPrint))
  add(query_580704, "oauth_token", newJString(oauthToken))
  add(query_580704, "$.xgafv", newJString(Xgafv))
  add(query_580704, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580704, "alt", newJString(alt))
  add(query_580704, "uploadType", newJString(uploadType))
  add(query_580704, "quotaUser", newJString(quotaUser))
  add(path_580703, "resource", newJString(resource))
  add(query_580704, "callback", newJString(callback))
  add(query_580704, "fields", newJString(fields))
  add(query_580704, "access_token", newJString(accessToken))
  add(query_580704, "upload_protocol", newJString(uploadProtocol))
  result = call_580702.call(path_580703, query_580704, nil, nil, nil)

var runProjectsLocationsServicesGetIamPolicy* = Call_RunProjectsLocationsServicesGetIamPolicy_580685(
    name: "runProjectsLocationsServicesGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_RunProjectsLocationsServicesGetIamPolicy_580686,
    base: "/", url: url_RunProjectsLocationsServicesGetIamPolicy_580687,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesSetIamPolicy_580705 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsServicesSetIamPolicy_580707(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesSetIamPolicy_580706(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580708 = path.getOrDefault("resource")
  valid_580708 = validateParameter(valid_580708, JString, required = true,
                                 default = nil)
  if valid_580708 != nil:
    section.add "resource", valid_580708
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
  var valid_580709 = query.getOrDefault("key")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = nil)
  if valid_580709 != nil:
    section.add "key", valid_580709
  var valid_580710 = query.getOrDefault("prettyPrint")
  valid_580710 = validateParameter(valid_580710, JBool, required = false,
                                 default = newJBool(true))
  if valid_580710 != nil:
    section.add "prettyPrint", valid_580710
  var valid_580711 = query.getOrDefault("oauth_token")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = nil)
  if valid_580711 != nil:
    section.add "oauth_token", valid_580711
  var valid_580712 = query.getOrDefault("$.xgafv")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = newJString("1"))
  if valid_580712 != nil:
    section.add "$.xgafv", valid_580712
  var valid_580713 = query.getOrDefault("alt")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = newJString("json"))
  if valid_580713 != nil:
    section.add "alt", valid_580713
  var valid_580714 = query.getOrDefault("uploadType")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "uploadType", valid_580714
  var valid_580715 = query.getOrDefault("quotaUser")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "quotaUser", valid_580715
  var valid_580716 = query.getOrDefault("callback")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "callback", valid_580716
  var valid_580717 = query.getOrDefault("fields")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = nil)
  if valid_580717 != nil:
    section.add "fields", valid_580717
  var valid_580718 = query.getOrDefault("access_token")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "access_token", valid_580718
  var valid_580719 = query.getOrDefault("upload_protocol")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "upload_protocol", valid_580719
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

proc call*(call_580721: Call_RunProjectsLocationsServicesSetIamPolicy_580705;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  let valid = call_580721.validator(path, query, header, formData, body)
  let scheme = call_580721.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580721.url(scheme.get, call_580721.host, call_580721.base,
                         call_580721.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580721, url, valid)

proc call*(call_580722: Call_RunProjectsLocationsServicesSetIamPolicy_580705;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesSetIamPolicy
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
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
  var path_580723 = newJObject()
  var query_580724 = newJObject()
  var body_580725 = newJObject()
  add(query_580724, "key", newJString(key))
  add(query_580724, "prettyPrint", newJBool(prettyPrint))
  add(query_580724, "oauth_token", newJString(oauthToken))
  add(query_580724, "$.xgafv", newJString(Xgafv))
  add(query_580724, "alt", newJString(alt))
  add(query_580724, "uploadType", newJString(uploadType))
  add(query_580724, "quotaUser", newJString(quotaUser))
  add(path_580723, "resource", newJString(resource))
  if body != nil:
    body_580725 = body
  add(query_580724, "callback", newJString(callback))
  add(query_580724, "fields", newJString(fields))
  add(query_580724, "access_token", newJString(accessToken))
  add(query_580724, "upload_protocol", newJString(uploadProtocol))
  result = call_580722.call(path_580723, query_580724, nil, nil, body_580725)

var runProjectsLocationsServicesSetIamPolicy* = Call_RunProjectsLocationsServicesSetIamPolicy_580705(
    name: "runProjectsLocationsServicesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_RunProjectsLocationsServicesSetIamPolicy_580706,
    base: "/", url: url_RunProjectsLocationsServicesSetIamPolicy_580707,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesTestIamPermissions_580726 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsServicesTestIamPermissions_580728(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesTestIamPermissions_580727(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580729 = path.getOrDefault("resource")
  valid_580729 = validateParameter(valid_580729, JString, required = true,
                                 default = nil)
  if valid_580729 != nil:
    section.add "resource", valid_580729
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
  var valid_580730 = query.getOrDefault("key")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "key", valid_580730
  var valid_580731 = query.getOrDefault("prettyPrint")
  valid_580731 = validateParameter(valid_580731, JBool, required = false,
                                 default = newJBool(true))
  if valid_580731 != nil:
    section.add "prettyPrint", valid_580731
  var valid_580732 = query.getOrDefault("oauth_token")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "oauth_token", valid_580732
  var valid_580733 = query.getOrDefault("$.xgafv")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = newJString("1"))
  if valid_580733 != nil:
    section.add "$.xgafv", valid_580733
  var valid_580734 = query.getOrDefault("alt")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = newJString("json"))
  if valid_580734 != nil:
    section.add "alt", valid_580734
  var valid_580735 = query.getOrDefault("uploadType")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "uploadType", valid_580735
  var valid_580736 = query.getOrDefault("quotaUser")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "quotaUser", valid_580736
  var valid_580737 = query.getOrDefault("callback")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "callback", valid_580737
  var valid_580738 = query.getOrDefault("fields")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "fields", valid_580738
  var valid_580739 = query.getOrDefault("access_token")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "access_token", valid_580739
  var valid_580740 = query.getOrDefault("upload_protocol")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = nil)
  if valid_580740 != nil:
    section.add "upload_protocol", valid_580740
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

proc call*(call_580742: Call_RunProjectsLocationsServicesTestIamPermissions_580726;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_580742.validator(path, query, header, formData, body)
  let scheme = call_580742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580742.url(scheme.get, call_580742.host, call_580742.base,
                         call_580742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580742, url, valid)

proc call*(call_580743: Call_RunProjectsLocationsServicesTestIamPermissions_580726;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesTestIamPermissions
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
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
  var path_580744 = newJObject()
  var query_580745 = newJObject()
  var body_580746 = newJObject()
  add(query_580745, "key", newJString(key))
  add(query_580745, "prettyPrint", newJBool(prettyPrint))
  add(query_580745, "oauth_token", newJString(oauthToken))
  add(query_580745, "$.xgafv", newJString(Xgafv))
  add(query_580745, "alt", newJString(alt))
  add(query_580745, "uploadType", newJString(uploadType))
  add(query_580745, "quotaUser", newJString(quotaUser))
  add(path_580744, "resource", newJString(resource))
  if body != nil:
    body_580746 = body
  add(query_580745, "callback", newJString(callback))
  add(query_580745, "fields", newJString(fields))
  add(query_580745, "access_token", newJString(accessToken))
  add(query_580745, "upload_protocol", newJString(uploadProtocol))
  result = call_580743.call(path_580744, query_580745, nil, nil, body_580746)

var runProjectsLocationsServicesTestIamPermissions* = Call_RunProjectsLocationsServicesTestIamPermissions_580726(
    name: "runProjectsLocationsServicesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_RunProjectsLocationsServicesTestIamPermissions_580727,
    base: "/", url: url_RunProjectsLocationsServicesTestIamPermissions_580728,
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
