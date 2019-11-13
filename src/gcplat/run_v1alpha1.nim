
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Run
## version: v1alpha1
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
  Call_RunNamespacesDomainmappingsGet_579644 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesDomainmappingsGet_579646(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/domains.cloudrun.com/v1alpha1/"),
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

proc validate_RunNamespacesDomainmappingsGet_579645(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to get information about a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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

proc call*(call_579819: Call_RunNamespacesDomainmappingsGet_579644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a domain mapping.
  ## 
  let valid = call_579819.validator(path, query, header, formData, body)
  let scheme = call_579819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579819.url(scheme.get, call_579819.host, call_579819.base,
                         call_579819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579819, url, valid)

proc call*(call_579890: Call_RunNamespacesDomainmappingsGet_579644; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesDomainmappingsGet
  ## Rpc to get information about a domain mapping.
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
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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

var runNamespacesDomainmappingsGet* = Call_RunNamespacesDomainmappingsGet_579644(
    name: "runNamespacesDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{name}",
    validator: validate_RunNamespacesDomainmappingsGet_579645, base: "/",
    url: url_RunNamespacesDomainmappingsGet_579646, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsDelete_579932 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesDomainmappingsDelete_579934(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/domains.cloudrun.com/v1alpha1/"),
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

proc validate_RunNamespacesDomainmappingsDelete_579933(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to delete a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: JString
  ##           : JSONP
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  ##   orphanDependents: JBool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
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
  var valid_579943 = query.getOrDefault("propagationPolicy")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "propagationPolicy", valid_579943
  var valid_579944 = query.getOrDefault("callback")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "callback", valid_579944
  var valid_579945 = query.getOrDefault("apiVersion")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "apiVersion", valid_579945
  var valid_579946 = query.getOrDefault("orphanDependents")
  valid_579946 = validateParameter(valid_579946, JBool, required = false, default = nil)
  if valid_579946 != nil:
    section.add "orphanDependents", valid_579946
  var valid_579947 = query.getOrDefault("kind")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "kind", valid_579947
  var valid_579948 = query.getOrDefault("fields")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "fields", valid_579948
  var valid_579949 = query.getOrDefault("access_token")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "access_token", valid_579949
  var valid_579950 = query.getOrDefault("upload_protocol")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "upload_protocol", valid_579950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579951: Call_RunNamespacesDomainmappingsDelete_579932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to delete a domain mapping.
  ## 
  let valid = call_579951.validator(path, query, header, formData, body)
  let scheme = call_579951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579951.url(scheme.get, call_579951.host, call_579951.base,
                         call_579951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579951, url, valid)

proc call*(call_579952: Call_RunNamespacesDomainmappingsDelete_579932;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          propagationPolicy: string = ""; callback: string = "";
          apiVersion: string = ""; orphanDependents: bool = false; kind: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesDomainmappingsDelete
  ## Rpc to delete a domain mapping.
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
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: string
  ##           : JSONP
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  ##   orphanDependents: bool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579953 = newJObject()
  var query_579954 = newJObject()
  add(query_579954, "key", newJString(key))
  add(query_579954, "prettyPrint", newJBool(prettyPrint))
  add(query_579954, "oauth_token", newJString(oauthToken))
  add(query_579954, "$.xgafv", newJString(Xgafv))
  add(query_579954, "alt", newJString(alt))
  add(query_579954, "uploadType", newJString(uploadType))
  add(query_579954, "quotaUser", newJString(quotaUser))
  add(path_579953, "name", newJString(name))
  add(query_579954, "propagationPolicy", newJString(propagationPolicy))
  add(query_579954, "callback", newJString(callback))
  add(query_579954, "apiVersion", newJString(apiVersion))
  add(query_579954, "orphanDependents", newJBool(orphanDependents))
  add(query_579954, "kind", newJString(kind))
  add(query_579954, "fields", newJString(fields))
  add(query_579954, "access_token", newJString(accessToken))
  add(query_579954, "upload_protocol", newJString(uploadProtocol))
  result = call_579952.call(path_579953, query_579954, nil, nil, nil)

var runNamespacesDomainmappingsDelete* = Call_RunNamespacesDomainmappingsDelete_579932(
    name: "runNamespacesDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{name}",
    validator: validate_RunNamespacesDomainmappingsDelete_579933, base: "/",
    url: url_RunNamespacesDomainmappingsDelete_579934, schemes: {Scheme.Https})
type
  Call_RunNamespacesAuthorizeddomainsList_579955 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesAuthorizeddomainsList_579957(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/domains.cloudrun.com/v1alpha1/"),
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

proc validate_RunNamespacesAuthorizeddomainsList_579956(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## RPC to list authorized domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579958 = path.getOrDefault("parent")
  valid_579958 = validateParameter(valid_579958, JString, required = true,
                                 default = nil)
  if valid_579958 != nil:
    section.add "parent", valid_579958
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
  var valid_579959 = query.getOrDefault("key")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "key", valid_579959
  var valid_579960 = query.getOrDefault("prettyPrint")
  valid_579960 = validateParameter(valid_579960, JBool, required = false,
                                 default = newJBool(true))
  if valid_579960 != nil:
    section.add "prettyPrint", valid_579960
  var valid_579961 = query.getOrDefault("oauth_token")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "oauth_token", valid_579961
  var valid_579962 = query.getOrDefault("$.xgafv")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = newJString("1"))
  if valid_579962 != nil:
    section.add "$.xgafv", valid_579962
  var valid_579963 = query.getOrDefault("pageSize")
  valid_579963 = validateParameter(valid_579963, JInt, required = false, default = nil)
  if valid_579963 != nil:
    section.add "pageSize", valid_579963
  var valid_579964 = query.getOrDefault("alt")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("json"))
  if valid_579964 != nil:
    section.add "alt", valid_579964
  var valid_579965 = query.getOrDefault("uploadType")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "uploadType", valid_579965
  var valid_579966 = query.getOrDefault("quotaUser")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "quotaUser", valid_579966
  var valid_579967 = query.getOrDefault("pageToken")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "pageToken", valid_579967
  var valid_579968 = query.getOrDefault("callback")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "callback", valid_579968
  var valid_579969 = query.getOrDefault("fields")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "fields", valid_579969
  var valid_579970 = query.getOrDefault("access_token")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "access_token", valid_579970
  var valid_579971 = query.getOrDefault("upload_protocol")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "upload_protocol", valid_579971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579972: Call_RunNamespacesAuthorizeddomainsList_579955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RPC to list authorized domains.
  ## 
  let valid = call_579972.validator(path, query, header, formData, body)
  let scheme = call_579972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579972.url(scheme.get, call_579972.host, call_579972.base,
                         call_579972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579972, url, valid)

proc call*(call_579973: Call_RunNamespacesAuthorizeddomainsList_579955;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesAuthorizeddomainsList
  ## RPC to list authorized domains.
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
  var path_579974 = newJObject()
  var query_579975 = newJObject()
  add(query_579975, "key", newJString(key))
  add(query_579975, "prettyPrint", newJBool(prettyPrint))
  add(query_579975, "oauth_token", newJString(oauthToken))
  add(query_579975, "$.xgafv", newJString(Xgafv))
  add(query_579975, "pageSize", newJInt(pageSize))
  add(query_579975, "alt", newJString(alt))
  add(query_579975, "uploadType", newJString(uploadType))
  add(query_579975, "quotaUser", newJString(quotaUser))
  add(query_579975, "pageToken", newJString(pageToken))
  add(query_579975, "callback", newJString(callback))
  add(path_579974, "parent", newJString(parent))
  add(query_579975, "fields", newJString(fields))
  add(query_579975, "access_token", newJString(accessToken))
  add(query_579975, "upload_protocol", newJString(uploadProtocol))
  result = call_579973.call(path_579974, query_579975, nil, nil, nil)

var runNamespacesAuthorizeddomainsList* = Call_RunNamespacesAuthorizeddomainsList_579955(
    name: "runNamespacesAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/authorizeddomains",
    validator: validate_RunNamespacesAuthorizeddomainsList_579956, base: "/",
    url: url_RunNamespacesAuthorizeddomainsList_579957, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsCreate_580002 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesDomainmappingsCreate_580004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/domains.cloudrun.com/v1alpha1/"),
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

proc validate_RunNamespacesDomainmappingsCreate_580003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580005 = path.getOrDefault("parent")
  valid_580005 = validateParameter(valid_580005, JString, required = true,
                                 default = nil)
  if valid_580005 != nil:
    section.add "parent", valid_580005
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
  var valid_580006 = query.getOrDefault("key")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "key", valid_580006
  var valid_580007 = query.getOrDefault("prettyPrint")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "prettyPrint", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("$.xgafv")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("1"))
  if valid_580009 != nil:
    section.add "$.xgafv", valid_580009
  var valid_580010 = query.getOrDefault("alt")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("json"))
  if valid_580010 != nil:
    section.add "alt", valid_580010
  var valid_580011 = query.getOrDefault("uploadType")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "uploadType", valid_580011
  var valid_580012 = query.getOrDefault("quotaUser")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "quotaUser", valid_580012
  var valid_580013 = query.getOrDefault("callback")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "callback", valid_580013
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

proc call*(call_580018: Call_RunNamespacesDomainmappingsCreate_580002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new domain mapping.
  ## 
  let valid = call_580018.validator(path, query, header, formData, body)
  let scheme = call_580018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580018.url(scheme.get, call_580018.host, call_580018.base,
                         call_580018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580018, url, valid)

proc call*(call_580019: Call_RunNamespacesDomainmappingsCreate_580002;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesDomainmappingsCreate
  ## Creates a new domain mapping.
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
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580020 = newJObject()
  var query_580021 = newJObject()
  var body_580022 = newJObject()
  add(query_580021, "key", newJString(key))
  add(query_580021, "prettyPrint", newJBool(prettyPrint))
  add(query_580021, "oauth_token", newJString(oauthToken))
  add(query_580021, "$.xgafv", newJString(Xgafv))
  add(query_580021, "alt", newJString(alt))
  add(query_580021, "uploadType", newJString(uploadType))
  add(query_580021, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580022 = body
  add(query_580021, "callback", newJString(callback))
  add(path_580020, "parent", newJString(parent))
  add(query_580021, "fields", newJString(fields))
  add(query_580021, "access_token", newJString(accessToken))
  add(query_580021, "upload_protocol", newJString(uploadProtocol))
  result = call_580019.call(path_580020, query_580021, nil, nil, body_580022)

var runNamespacesDomainmappingsCreate* = Call_RunNamespacesDomainmappingsCreate_580002(
    name: "runNamespacesDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsCreate_580003, base: "/",
    url: url_RunNamespacesDomainmappingsCreate_580004, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsList_579976 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesDomainmappingsList_579978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/domains.cloudrun.com/v1alpha1/"),
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

proc validate_RunNamespacesDomainmappingsList_579977(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579979 = path.getOrDefault("parent")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "parent", valid_579979
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
  var valid_579980 = query.getOrDefault("key")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "key", valid_579980
  var valid_579981 = query.getOrDefault("includeUninitialized")
  valid_579981 = validateParameter(valid_579981, JBool, required = false, default = nil)
  if valid_579981 != nil:
    section.add "includeUninitialized", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(true))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
  var valid_579983 = query.getOrDefault("oauth_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "oauth_token", valid_579983
  var valid_579984 = query.getOrDefault("fieldSelector")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "fieldSelector", valid_579984
  var valid_579985 = query.getOrDefault("labelSelector")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "labelSelector", valid_579985
  var valid_579986 = query.getOrDefault("$.xgafv")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = newJString("1"))
  if valid_579986 != nil:
    section.add "$.xgafv", valid_579986
  var valid_579987 = query.getOrDefault("limit")
  valid_579987 = validateParameter(valid_579987, JInt, required = false, default = nil)
  if valid_579987 != nil:
    section.add "limit", valid_579987
  var valid_579988 = query.getOrDefault("alt")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("json"))
  if valid_579988 != nil:
    section.add "alt", valid_579988
  var valid_579989 = query.getOrDefault("uploadType")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "uploadType", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("watch")
  valid_579991 = validateParameter(valid_579991, JBool, required = false, default = nil)
  if valid_579991 != nil:
    section.add "watch", valid_579991
  var valid_579992 = query.getOrDefault("callback")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "callback", valid_579992
  var valid_579993 = query.getOrDefault("resourceVersion")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "resourceVersion", valid_579993
  var valid_579994 = query.getOrDefault("fields")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "fields", valid_579994
  var valid_579995 = query.getOrDefault("access_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "access_token", valid_579995
  var valid_579996 = query.getOrDefault("upload_protocol")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "upload_protocol", valid_579996
  var valid_579997 = query.getOrDefault("continue")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "continue", valid_579997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579998: Call_RunNamespacesDomainmappingsList_579976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list domain mappings.
  ## 
  let valid = call_579998.validator(path, query, header, formData, body)
  let scheme = call_579998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579998.url(scheme.get, call_579998.host, call_579998.base,
                         call_579998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579998, url, valid)

proc call*(call_579999: Call_RunNamespacesDomainmappingsList_579976;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesDomainmappingsList
  ## Rpc to list domain mappings.
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
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
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
  var path_580000 = newJObject()
  var query_580001 = newJObject()
  add(query_580001, "key", newJString(key))
  add(query_580001, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580001, "prettyPrint", newJBool(prettyPrint))
  add(query_580001, "oauth_token", newJString(oauthToken))
  add(query_580001, "fieldSelector", newJString(fieldSelector))
  add(query_580001, "labelSelector", newJString(labelSelector))
  add(query_580001, "$.xgafv", newJString(Xgafv))
  add(query_580001, "limit", newJInt(limit))
  add(query_580001, "alt", newJString(alt))
  add(query_580001, "uploadType", newJString(uploadType))
  add(query_580001, "quotaUser", newJString(quotaUser))
  add(query_580001, "watch", newJBool(watch))
  add(query_580001, "callback", newJString(callback))
  add(path_580000, "parent", newJString(parent))
  add(query_580001, "resourceVersion", newJString(resourceVersion))
  add(query_580001, "fields", newJString(fields))
  add(query_580001, "access_token", newJString(accessToken))
  add(query_580001, "upload_protocol", newJString(uploadProtocol))
  add(query_580001, "continue", newJString(`continue`))
  result = call_579999.call(path_580000, query_580001, nil, nil, nil)

var runNamespacesDomainmappingsList* = Call_RunNamespacesDomainmappingsList_579976(
    name: "runNamespacesDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsList_579977, base: "/",
    url: url_RunNamespacesDomainmappingsList_579978, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersReplaceTrigger_580042 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesTriggersReplaceTrigger_580044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/eventing.knative.dev/v1alpha1/"),
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

proc validate_RunNamespacesTriggersReplaceTrigger_580043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to replace a trigger.
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
  ##       : The name of the trigger being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580045 = path.getOrDefault("name")
  valid_580045 = validateParameter(valid_580045, JString, required = true,
                                 default = nil)
  if valid_580045 != nil:
    section.add "name", valid_580045
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
  var valid_580046 = query.getOrDefault("key")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "key", valid_580046
  var valid_580047 = query.getOrDefault("prettyPrint")
  valid_580047 = validateParameter(valid_580047, JBool, required = false,
                                 default = newJBool(true))
  if valid_580047 != nil:
    section.add "prettyPrint", valid_580047
  var valid_580048 = query.getOrDefault("oauth_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "oauth_token", valid_580048
  var valid_580049 = query.getOrDefault("$.xgafv")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = newJString("1"))
  if valid_580049 != nil:
    section.add "$.xgafv", valid_580049
  var valid_580050 = query.getOrDefault("alt")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("json"))
  if valid_580050 != nil:
    section.add "alt", valid_580050
  var valid_580051 = query.getOrDefault("uploadType")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "uploadType", valid_580051
  var valid_580052 = query.getOrDefault("quotaUser")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "quotaUser", valid_580052
  var valid_580053 = query.getOrDefault("callback")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "callback", valid_580053
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  var valid_580055 = query.getOrDefault("access_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "access_token", valid_580055
  var valid_580056 = query.getOrDefault("upload_protocol")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "upload_protocol", valid_580056
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

proc call*(call_580058: Call_RunNamespacesTriggersReplaceTrigger_580042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to replace a trigger.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_580058.validator(path, query, header, formData, body)
  let scheme = call_580058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580058.url(scheme.get, call_580058.host, call_580058.base,
                         call_580058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580058, url, valid)

proc call*(call_580059: Call_RunNamespacesTriggersReplaceTrigger_580042;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesTriggersReplaceTrigger
  ## Rpc to replace a trigger.
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
  ##       : The name of the trigger being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580060 = newJObject()
  var query_580061 = newJObject()
  var body_580062 = newJObject()
  add(query_580061, "key", newJString(key))
  add(query_580061, "prettyPrint", newJBool(prettyPrint))
  add(query_580061, "oauth_token", newJString(oauthToken))
  add(query_580061, "$.xgafv", newJString(Xgafv))
  add(query_580061, "alt", newJString(alt))
  add(query_580061, "uploadType", newJString(uploadType))
  add(query_580061, "quotaUser", newJString(quotaUser))
  add(path_580060, "name", newJString(name))
  if body != nil:
    body_580062 = body
  add(query_580061, "callback", newJString(callback))
  add(query_580061, "fields", newJString(fields))
  add(query_580061, "access_token", newJString(accessToken))
  add(query_580061, "upload_protocol", newJString(uploadProtocol))
  result = call_580059.call(path_580060, query_580061, nil, nil, body_580062)

var runNamespacesTriggersReplaceTrigger* = Call_RunNamespacesTriggersReplaceTrigger_580042(
    name: "runNamespacesTriggersReplaceTrigger", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersReplaceTrigger_580043, base: "/",
    url: url_RunNamespacesTriggersReplaceTrigger_580044, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersGet_580023 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesTriggersGet_580025(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/eventing.knative.dev/v1alpha1/"),
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

proc validate_RunNamespacesTriggersGet_580024(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to get information about a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the trigger being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580026 = path.getOrDefault("name")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "name", valid_580026
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
  var valid_580027 = query.getOrDefault("key")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "key", valid_580027
  var valid_580028 = query.getOrDefault("prettyPrint")
  valid_580028 = validateParameter(valid_580028, JBool, required = false,
                                 default = newJBool(true))
  if valid_580028 != nil:
    section.add "prettyPrint", valid_580028
  var valid_580029 = query.getOrDefault("oauth_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "oauth_token", valid_580029
  var valid_580030 = query.getOrDefault("$.xgafv")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("1"))
  if valid_580030 != nil:
    section.add "$.xgafv", valid_580030
  var valid_580031 = query.getOrDefault("alt")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = newJString("json"))
  if valid_580031 != nil:
    section.add "alt", valid_580031
  var valid_580032 = query.getOrDefault("uploadType")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "uploadType", valid_580032
  var valid_580033 = query.getOrDefault("quotaUser")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "quotaUser", valid_580033
  var valid_580034 = query.getOrDefault("callback")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "callback", valid_580034
  var valid_580035 = query.getOrDefault("fields")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "fields", valid_580035
  var valid_580036 = query.getOrDefault("access_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "access_token", valid_580036
  var valid_580037 = query.getOrDefault("upload_protocol")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "upload_protocol", valid_580037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580038: Call_RunNamespacesTriggersGet_580023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a trigger.
  ## 
  let valid = call_580038.validator(path, query, header, formData, body)
  let scheme = call_580038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580038.url(scheme.get, call_580038.host, call_580038.base,
                         call_580038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580038, url, valid)

proc call*(call_580039: Call_RunNamespacesTriggersGet_580023; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesTriggersGet
  ## Rpc to get information about a trigger.
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
  ##       : The name of the trigger being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580040 = newJObject()
  var query_580041 = newJObject()
  add(query_580041, "key", newJString(key))
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  add(query_580041, "oauth_token", newJString(oauthToken))
  add(query_580041, "$.xgafv", newJString(Xgafv))
  add(query_580041, "alt", newJString(alt))
  add(query_580041, "uploadType", newJString(uploadType))
  add(query_580041, "quotaUser", newJString(quotaUser))
  add(path_580040, "name", newJString(name))
  add(query_580041, "callback", newJString(callback))
  add(query_580041, "fields", newJString(fields))
  add(query_580041, "access_token", newJString(accessToken))
  add(query_580041, "upload_protocol", newJString(uploadProtocol))
  result = call_580039.call(path_580040, query_580041, nil, nil, nil)

var runNamespacesTriggersGet* = Call_RunNamespacesTriggersGet_580023(
    name: "runNamespacesTriggersGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersGet_580024, base: "/",
    url: url_RunNamespacesTriggersGet_580025, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersDelete_580063 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesTriggersDelete_580065(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/eventing.knative.dev/v1alpha1/"),
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

proc validate_RunNamespacesTriggersDelete_580064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to delete a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the trigger being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580066 = path.getOrDefault("name")
  valid_580066 = validateParameter(valid_580066, JString, required = true,
                                 default = nil)
  if valid_580066 != nil:
    section.add "name", valid_580066
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
  var valid_580067 = query.getOrDefault("key")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "key", valid_580067
  var valid_580068 = query.getOrDefault("prettyPrint")
  valid_580068 = validateParameter(valid_580068, JBool, required = false,
                                 default = newJBool(true))
  if valid_580068 != nil:
    section.add "prettyPrint", valid_580068
  var valid_580069 = query.getOrDefault("oauth_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "oauth_token", valid_580069
  var valid_580070 = query.getOrDefault("$.xgafv")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = newJString("1"))
  if valid_580070 != nil:
    section.add "$.xgafv", valid_580070
  var valid_580071 = query.getOrDefault("alt")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("json"))
  if valid_580071 != nil:
    section.add "alt", valid_580071
  var valid_580072 = query.getOrDefault("uploadType")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "uploadType", valid_580072
  var valid_580073 = query.getOrDefault("quotaUser")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "quotaUser", valid_580073
  var valid_580074 = query.getOrDefault("propagationPolicy")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "propagationPolicy", valid_580074
  var valid_580075 = query.getOrDefault("callback")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "callback", valid_580075
  var valid_580076 = query.getOrDefault("apiVersion")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "apiVersion", valid_580076
  var valid_580077 = query.getOrDefault("kind")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "kind", valid_580077
  var valid_580078 = query.getOrDefault("fields")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "fields", valid_580078
  var valid_580079 = query.getOrDefault("access_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "access_token", valid_580079
  var valid_580080 = query.getOrDefault("upload_protocol")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "upload_protocol", valid_580080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580081: Call_RunNamespacesTriggersDelete_580063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to delete a trigger.
  ## 
  let valid = call_580081.validator(path, query, header, formData, body)
  let scheme = call_580081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580081.url(scheme.get, call_580081.host, call_580081.base,
                         call_580081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580081, url, valid)

proc call*(call_580082: Call_RunNamespacesTriggersDelete_580063; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; propagationPolicy: string = ""; callback: string = "";
          apiVersion: string = ""; kind: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesTriggersDelete
  ## Rpc to delete a trigger.
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
  ##       : The name of the trigger being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_580083 = newJObject()
  var query_580084 = newJObject()
  add(query_580084, "key", newJString(key))
  add(query_580084, "prettyPrint", newJBool(prettyPrint))
  add(query_580084, "oauth_token", newJString(oauthToken))
  add(query_580084, "$.xgafv", newJString(Xgafv))
  add(query_580084, "alt", newJString(alt))
  add(query_580084, "uploadType", newJString(uploadType))
  add(query_580084, "quotaUser", newJString(quotaUser))
  add(path_580083, "name", newJString(name))
  add(query_580084, "propagationPolicy", newJString(propagationPolicy))
  add(query_580084, "callback", newJString(callback))
  add(query_580084, "apiVersion", newJString(apiVersion))
  add(query_580084, "kind", newJString(kind))
  add(query_580084, "fields", newJString(fields))
  add(query_580084, "access_token", newJString(accessToken))
  add(query_580084, "upload_protocol", newJString(uploadProtocol))
  result = call_580082.call(path_580083, query_580084, nil, nil, nil)

var runNamespacesTriggersDelete* = Call_RunNamespacesTriggersDelete_580063(
    name: "runNamespacesTriggersDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersDelete_580064, base: "/",
    url: url_RunNamespacesTriggersDelete_580065, schemes: {Scheme.Https})
type
  Call_RunNamespacesEventtypesList_580085 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesEventtypesList_580087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/eventing.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/eventtypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesEventtypesList_580086(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list EventTypes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the EventTypes should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580088 = path.getOrDefault("parent")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "parent", valid_580088
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
  var valid_580089 = query.getOrDefault("key")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "key", valid_580089
  var valid_580090 = query.getOrDefault("includeUninitialized")
  valid_580090 = validateParameter(valid_580090, JBool, required = false, default = nil)
  if valid_580090 != nil:
    section.add "includeUninitialized", valid_580090
  var valid_580091 = query.getOrDefault("prettyPrint")
  valid_580091 = validateParameter(valid_580091, JBool, required = false,
                                 default = newJBool(true))
  if valid_580091 != nil:
    section.add "prettyPrint", valid_580091
  var valid_580092 = query.getOrDefault("oauth_token")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "oauth_token", valid_580092
  var valid_580093 = query.getOrDefault("fieldSelector")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "fieldSelector", valid_580093
  var valid_580094 = query.getOrDefault("labelSelector")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "labelSelector", valid_580094
  var valid_580095 = query.getOrDefault("$.xgafv")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("1"))
  if valid_580095 != nil:
    section.add "$.xgafv", valid_580095
  var valid_580096 = query.getOrDefault("limit")
  valid_580096 = validateParameter(valid_580096, JInt, required = false, default = nil)
  if valid_580096 != nil:
    section.add "limit", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("uploadType")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "uploadType", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("watch")
  valid_580100 = validateParameter(valid_580100, JBool, required = false, default = nil)
  if valid_580100 != nil:
    section.add "watch", valid_580100
  var valid_580101 = query.getOrDefault("callback")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "callback", valid_580101
  var valid_580102 = query.getOrDefault("resourceVersion")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "resourceVersion", valid_580102
  var valid_580103 = query.getOrDefault("fields")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "fields", valid_580103
  var valid_580104 = query.getOrDefault("access_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "access_token", valid_580104
  var valid_580105 = query.getOrDefault("upload_protocol")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "upload_protocol", valid_580105
  var valid_580106 = query.getOrDefault("continue")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "continue", valid_580106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580107: Call_RunNamespacesEventtypesList_580085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list EventTypes.
  ## 
  let valid = call_580107.validator(path, query, header, formData, body)
  let scheme = call_580107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580107.url(scheme.get, call_580107.host, call_580107.base,
                         call_580107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580107, url, valid)

proc call*(call_580108: Call_RunNamespacesEventtypesList_580085; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesEventtypesList
  ## Rpc to list EventTypes.
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
  ##         : The project ID or project number from which the EventTypes should be
  ## listed.
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
  var path_580109 = newJObject()
  var query_580110 = newJObject()
  add(query_580110, "key", newJString(key))
  add(query_580110, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580110, "prettyPrint", newJBool(prettyPrint))
  add(query_580110, "oauth_token", newJString(oauthToken))
  add(query_580110, "fieldSelector", newJString(fieldSelector))
  add(query_580110, "labelSelector", newJString(labelSelector))
  add(query_580110, "$.xgafv", newJString(Xgafv))
  add(query_580110, "limit", newJInt(limit))
  add(query_580110, "alt", newJString(alt))
  add(query_580110, "uploadType", newJString(uploadType))
  add(query_580110, "quotaUser", newJString(quotaUser))
  add(query_580110, "watch", newJBool(watch))
  add(query_580110, "callback", newJString(callback))
  add(path_580109, "parent", newJString(parent))
  add(query_580110, "resourceVersion", newJString(resourceVersion))
  add(query_580110, "fields", newJString(fields))
  add(query_580110, "access_token", newJString(accessToken))
  add(query_580110, "upload_protocol", newJString(uploadProtocol))
  add(query_580110, "continue", newJString(`continue`))
  result = call_580108.call(path_580109, query_580110, nil, nil, nil)

var runNamespacesEventtypesList* = Call_RunNamespacesEventtypesList_580085(
    name: "runNamespacesEventtypesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/eventtypes",
    validator: validate_RunNamespacesEventtypesList_580086, base: "/",
    url: url_RunNamespacesEventtypesList_580087, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersCreate_580137 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesTriggersCreate_580139(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/eventing.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesTriggersCreate_580138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this trigger should
  ## be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580140 = path.getOrDefault("parent")
  valid_580140 = validateParameter(valid_580140, JString, required = true,
                                 default = nil)
  if valid_580140 != nil:
    section.add "parent", valid_580140
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
  var valid_580141 = query.getOrDefault("key")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "key", valid_580141
  var valid_580142 = query.getOrDefault("prettyPrint")
  valid_580142 = validateParameter(valid_580142, JBool, required = false,
                                 default = newJBool(true))
  if valid_580142 != nil:
    section.add "prettyPrint", valid_580142
  var valid_580143 = query.getOrDefault("oauth_token")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "oauth_token", valid_580143
  var valid_580144 = query.getOrDefault("$.xgafv")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = newJString("1"))
  if valid_580144 != nil:
    section.add "$.xgafv", valid_580144
  var valid_580145 = query.getOrDefault("alt")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = newJString("json"))
  if valid_580145 != nil:
    section.add "alt", valid_580145
  var valid_580146 = query.getOrDefault("uploadType")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "uploadType", valid_580146
  var valid_580147 = query.getOrDefault("quotaUser")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "quotaUser", valid_580147
  var valid_580148 = query.getOrDefault("callback")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "callback", valid_580148
  var valid_580149 = query.getOrDefault("fields")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "fields", valid_580149
  var valid_580150 = query.getOrDefault("access_token")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "access_token", valid_580150
  var valid_580151 = query.getOrDefault("upload_protocol")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "upload_protocol", valid_580151
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

proc call*(call_580153: Call_RunNamespacesTriggersCreate_580137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new trigger.
  ## 
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_RunNamespacesTriggersCreate_580137; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesTriggersCreate
  ## Creates a new trigger.
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
  ##         : The project ID or project number in which this trigger should
  ## be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580155 = newJObject()
  var query_580156 = newJObject()
  var body_580157 = newJObject()
  add(query_580156, "key", newJString(key))
  add(query_580156, "prettyPrint", newJBool(prettyPrint))
  add(query_580156, "oauth_token", newJString(oauthToken))
  add(query_580156, "$.xgafv", newJString(Xgafv))
  add(query_580156, "alt", newJString(alt))
  add(query_580156, "uploadType", newJString(uploadType))
  add(query_580156, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580157 = body
  add(query_580156, "callback", newJString(callback))
  add(path_580155, "parent", newJString(parent))
  add(query_580156, "fields", newJString(fields))
  add(query_580156, "access_token", newJString(accessToken))
  add(query_580156, "upload_protocol", newJString(uploadProtocol))
  result = call_580154.call(path_580155, query_580156, nil, nil, body_580157)

var runNamespacesTriggersCreate* = Call_RunNamespacesTriggersCreate_580137(
    name: "runNamespacesTriggersCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/triggers",
    validator: validate_RunNamespacesTriggersCreate_580138, base: "/",
    url: url_RunNamespacesTriggersCreate_580139, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersList_580111 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesTriggersList_580113(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/eventing.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesTriggersList_580112(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list triggers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the triggers should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580114 = path.getOrDefault("parent")
  valid_580114 = validateParameter(valid_580114, JString, required = true,
                                 default = nil)
  if valid_580114 != nil:
    section.add "parent", valid_580114
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
  var valid_580115 = query.getOrDefault("key")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "key", valid_580115
  var valid_580116 = query.getOrDefault("includeUninitialized")
  valid_580116 = validateParameter(valid_580116, JBool, required = false, default = nil)
  if valid_580116 != nil:
    section.add "includeUninitialized", valid_580116
  var valid_580117 = query.getOrDefault("prettyPrint")
  valid_580117 = validateParameter(valid_580117, JBool, required = false,
                                 default = newJBool(true))
  if valid_580117 != nil:
    section.add "prettyPrint", valid_580117
  var valid_580118 = query.getOrDefault("oauth_token")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "oauth_token", valid_580118
  var valid_580119 = query.getOrDefault("fieldSelector")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "fieldSelector", valid_580119
  var valid_580120 = query.getOrDefault("labelSelector")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "labelSelector", valid_580120
  var valid_580121 = query.getOrDefault("$.xgafv")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("1"))
  if valid_580121 != nil:
    section.add "$.xgafv", valid_580121
  var valid_580122 = query.getOrDefault("limit")
  valid_580122 = validateParameter(valid_580122, JInt, required = false, default = nil)
  if valid_580122 != nil:
    section.add "limit", valid_580122
  var valid_580123 = query.getOrDefault("alt")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = newJString("json"))
  if valid_580123 != nil:
    section.add "alt", valid_580123
  var valid_580124 = query.getOrDefault("uploadType")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "uploadType", valid_580124
  var valid_580125 = query.getOrDefault("quotaUser")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "quotaUser", valid_580125
  var valid_580126 = query.getOrDefault("watch")
  valid_580126 = validateParameter(valid_580126, JBool, required = false, default = nil)
  if valid_580126 != nil:
    section.add "watch", valid_580126
  var valid_580127 = query.getOrDefault("callback")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "callback", valid_580127
  var valid_580128 = query.getOrDefault("resourceVersion")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "resourceVersion", valid_580128
  var valid_580129 = query.getOrDefault("fields")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "fields", valid_580129
  var valid_580130 = query.getOrDefault("access_token")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "access_token", valid_580130
  var valid_580131 = query.getOrDefault("upload_protocol")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "upload_protocol", valid_580131
  var valid_580132 = query.getOrDefault("continue")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "continue", valid_580132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580133: Call_RunNamespacesTriggersList_580111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list triggers.
  ## 
  let valid = call_580133.validator(path, query, header, formData, body)
  let scheme = call_580133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580133.url(scheme.get, call_580133.host, call_580133.base,
                         call_580133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580133, url, valid)

proc call*(call_580134: Call_RunNamespacesTriggersList_580111; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesTriggersList
  ## Rpc to list triggers.
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
  ##         : The project ID or project number from which the triggers should
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
  var path_580135 = newJObject()
  var query_580136 = newJObject()
  add(query_580136, "key", newJString(key))
  add(query_580136, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580136, "prettyPrint", newJBool(prettyPrint))
  add(query_580136, "oauth_token", newJString(oauthToken))
  add(query_580136, "fieldSelector", newJString(fieldSelector))
  add(query_580136, "labelSelector", newJString(labelSelector))
  add(query_580136, "$.xgafv", newJString(Xgafv))
  add(query_580136, "limit", newJInt(limit))
  add(query_580136, "alt", newJString(alt))
  add(query_580136, "uploadType", newJString(uploadType))
  add(query_580136, "quotaUser", newJString(quotaUser))
  add(query_580136, "watch", newJBool(watch))
  add(query_580136, "callback", newJString(callback))
  add(path_580135, "parent", newJString(parent))
  add(query_580136, "resourceVersion", newJString(resourceVersion))
  add(query_580136, "fields", newJString(fields))
  add(query_580136, "access_token", newJString(accessToken))
  add(query_580136, "upload_protocol", newJString(uploadProtocol))
  add(query_580136, "continue", newJString(`continue`))
  result = call_580134.call(path_580135, query_580136, nil, nil, nil)

var runNamespacesTriggersList* = Call_RunNamespacesTriggersList_580111(
    name: "runNamespacesTriggersList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/triggers",
    validator: validate_RunNamespacesTriggersList_580112, base: "/",
    url: url_RunNamespacesTriggersList_580113, schemes: {Scheme.Https})
type
  Call_RunNamespacesPubsubsReplacePubSub_580177 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesPubsubsReplacePubSub_580179(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/events.cloud.google.com/v1alpha1/"),
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

proc validate_RunNamespacesPubsubsReplacePubSub_580178(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to replace a pubsub.
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
  ##       : The name of the pubsub being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580180 = path.getOrDefault("name")
  valid_580180 = validateParameter(valid_580180, JString, required = true,
                                 default = nil)
  if valid_580180 != nil:
    section.add "name", valid_580180
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
  var valid_580181 = query.getOrDefault("key")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "key", valid_580181
  var valid_580182 = query.getOrDefault("prettyPrint")
  valid_580182 = validateParameter(valid_580182, JBool, required = false,
                                 default = newJBool(true))
  if valid_580182 != nil:
    section.add "prettyPrint", valid_580182
  var valid_580183 = query.getOrDefault("oauth_token")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "oauth_token", valid_580183
  var valid_580184 = query.getOrDefault("$.xgafv")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = newJString("1"))
  if valid_580184 != nil:
    section.add "$.xgafv", valid_580184
  var valid_580185 = query.getOrDefault("alt")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = newJString("json"))
  if valid_580185 != nil:
    section.add "alt", valid_580185
  var valid_580186 = query.getOrDefault("uploadType")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "uploadType", valid_580186
  var valid_580187 = query.getOrDefault("quotaUser")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "quotaUser", valid_580187
  var valid_580188 = query.getOrDefault("callback")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "callback", valid_580188
  var valid_580189 = query.getOrDefault("fields")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "fields", valid_580189
  var valid_580190 = query.getOrDefault("access_token")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "access_token", valid_580190
  var valid_580191 = query.getOrDefault("upload_protocol")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "upload_protocol", valid_580191
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

proc call*(call_580193: Call_RunNamespacesPubsubsReplacePubSub_580177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to replace a pubsub.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_580193.validator(path, query, header, formData, body)
  let scheme = call_580193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580193.url(scheme.get, call_580193.host, call_580193.base,
                         call_580193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580193, url, valid)

proc call*(call_580194: Call_RunNamespacesPubsubsReplacePubSub_580177;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesPubsubsReplacePubSub
  ## Rpc to replace a pubsub.
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
  ##       : The name of the pubsub being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580195 = newJObject()
  var query_580196 = newJObject()
  var body_580197 = newJObject()
  add(query_580196, "key", newJString(key))
  add(query_580196, "prettyPrint", newJBool(prettyPrint))
  add(query_580196, "oauth_token", newJString(oauthToken))
  add(query_580196, "$.xgafv", newJString(Xgafv))
  add(query_580196, "alt", newJString(alt))
  add(query_580196, "uploadType", newJString(uploadType))
  add(query_580196, "quotaUser", newJString(quotaUser))
  add(path_580195, "name", newJString(name))
  if body != nil:
    body_580197 = body
  add(query_580196, "callback", newJString(callback))
  add(query_580196, "fields", newJString(fields))
  add(query_580196, "access_token", newJString(accessToken))
  add(query_580196, "upload_protocol", newJString(uploadProtocol))
  result = call_580194.call(path_580195, query_580196, nil, nil, body_580197)

var runNamespacesPubsubsReplacePubSub* = Call_RunNamespacesPubsubsReplacePubSub_580177(
    name: "runNamespacesPubsubsReplacePubSub", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com",
    route: "/apis/events.cloud.google.com/v1alpha1/{name}",
    validator: validate_RunNamespacesPubsubsReplacePubSub_580178, base: "/",
    url: url_RunNamespacesPubsubsReplacePubSub_580179, schemes: {Scheme.Https})
type
  Call_RunNamespacesPubsubsGet_580158 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesPubsubsGet_580160(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/events.cloud.google.com/v1alpha1/"),
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

proc validate_RunNamespacesPubsubsGet_580159(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to get information about a pubsub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the pubsub being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580161 = path.getOrDefault("name")
  valid_580161 = validateParameter(valid_580161, JString, required = true,
                                 default = nil)
  if valid_580161 != nil:
    section.add "name", valid_580161
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
  var valid_580162 = query.getOrDefault("key")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "key", valid_580162
  var valid_580163 = query.getOrDefault("prettyPrint")
  valid_580163 = validateParameter(valid_580163, JBool, required = false,
                                 default = newJBool(true))
  if valid_580163 != nil:
    section.add "prettyPrint", valid_580163
  var valid_580164 = query.getOrDefault("oauth_token")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "oauth_token", valid_580164
  var valid_580165 = query.getOrDefault("$.xgafv")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = newJString("1"))
  if valid_580165 != nil:
    section.add "$.xgafv", valid_580165
  var valid_580166 = query.getOrDefault("alt")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = newJString("json"))
  if valid_580166 != nil:
    section.add "alt", valid_580166
  var valid_580167 = query.getOrDefault("uploadType")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "uploadType", valid_580167
  var valid_580168 = query.getOrDefault("quotaUser")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "quotaUser", valid_580168
  var valid_580169 = query.getOrDefault("callback")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "callback", valid_580169
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580173: Call_RunNamespacesPubsubsGet_580158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a pubsub.
  ## 
  let valid = call_580173.validator(path, query, header, formData, body)
  let scheme = call_580173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580173.url(scheme.get, call_580173.host, call_580173.base,
                         call_580173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580173, url, valid)

proc call*(call_580174: Call_RunNamespacesPubsubsGet_580158; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesPubsubsGet
  ## Rpc to get information about a pubsub.
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
  ##       : The name of the pubsub being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580175 = newJObject()
  var query_580176 = newJObject()
  add(query_580176, "key", newJString(key))
  add(query_580176, "prettyPrint", newJBool(prettyPrint))
  add(query_580176, "oauth_token", newJString(oauthToken))
  add(query_580176, "$.xgafv", newJString(Xgafv))
  add(query_580176, "alt", newJString(alt))
  add(query_580176, "uploadType", newJString(uploadType))
  add(query_580176, "quotaUser", newJString(quotaUser))
  add(path_580175, "name", newJString(name))
  add(query_580176, "callback", newJString(callback))
  add(query_580176, "fields", newJString(fields))
  add(query_580176, "access_token", newJString(accessToken))
  add(query_580176, "upload_protocol", newJString(uploadProtocol))
  result = call_580174.call(path_580175, query_580176, nil, nil, nil)

var runNamespacesPubsubsGet* = Call_RunNamespacesPubsubsGet_580158(
    name: "runNamespacesPubsubsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/events.cloud.google.com/v1alpha1/{name}",
    validator: validate_RunNamespacesPubsubsGet_580159, base: "/",
    url: url_RunNamespacesPubsubsGet_580160, schemes: {Scheme.Https})
type
  Call_RunNamespacesPubsubsDelete_580198 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesPubsubsDelete_580200(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/events.cloud.google.com/v1alpha1/"),
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

proc validate_RunNamespacesPubsubsDelete_580199(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to delete a pubsub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the pubsub being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580201 = path.getOrDefault("name")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "name", valid_580201
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
  var valid_580202 = query.getOrDefault("key")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "key", valid_580202
  var valid_580203 = query.getOrDefault("prettyPrint")
  valid_580203 = validateParameter(valid_580203, JBool, required = false,
                                 default = newJBool(true))
  if valid_580203 != nil:
    section.add "prettyPrint", valid_580203
  var valid_580204 = query.getOrDefault("oauth_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "oauth_token", valid_580204
  var valid_580205 = query.getOrDefault("$.xgafv")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = newJString("1"))
  if valid_580205 != nil:
    section.add "$.xgafv", valid_580205
  var valid_580206 = query.getOrDefault("alt")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("json"))
  if valid_580206 != nil:
    section.add "alt", valid_580206
  var valid_580207 = query.getOrDefault("uploadType")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "uploadType", valid_580207
  var valid_580208 = query.getOrDefault("quotaUser")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "quotaUser", valid_580208
  var valid_580209 = query.getOrDefault("propagationPolicy")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "propagationPolicy", valid_580209
  var valid_580210 = query.getOrDefault("callback")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "callback", valid_580210
  var valid_580211 = query.getOrDefault("apiVersion")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "apiVersion", valid_580211
  var valid_580212 = query.getOrDefault("kind")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "kind", valid_580212
  var valid_580213 = query.getOrDefault("fields")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "fields", valid_580213
  var valid_580214 = query.getOrDefault("access_token")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "access_token", valid_580214
  var valid_580215 = query.getOrDefault("upload_protocol")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "upload_protocol", valid_580215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580216: Call_RunNamespacesPubsubsDelete_580198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to delete a pubsub.
  ## 
  let valid = call_580216.validator(path, query, header, formData, body)
  let scheme = call_580216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580216.url(scheme.get, call_580216.host, call_580216.base,
                         call_580216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580216, url, valid)

proc call*(call_580217: Call_RunNamespacesPubsubsDelete_580198; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; propagationPolicy: string = ""; callback: string = "";
          apiVersion: string = ""; kind: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesPubsubsDelete
  ## Rpc to delete a pubsub.
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
  ##       : The name of the pubsub being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_580218 = newJObject()
  var query_580219 = newJObject()
  add(query_580219, "key", newJString(key))
  add(query_580219, "prettyPrint", newJBool(prettyPrint))
  add(query_580219, "oauth_token", newJString(oauthToken))
  add(query_580219, "$.xgafv", newJString(Xgafv))
  add(query_580219, "alt", newJString(alt))
  add(query_580219, "uploadType", newJString(uploadType))
  add(query_580219, "quotaUser", newJString(quotaUser))
  add(path_580218, "name", newJString(name))
  add(query_580219, "propagationPolicy", newJString(propagationPolicy))
  add(query_580219, "callback", newJString(callback))
  add(query_580219, "apiVersion", newJString(apiVersion))
  add(query_580219, "kind", newJString(kind))
  add(query_580219, "fields", newJString(fields))
  add(query_580219, "access_token", newJString(accessToken))
  add(query_580219, "upload_protocol", newJString(uploadProtocol))
  result = call_580217.call(path_580218, query_580219, nil, nil, nil)

var runNamespacesPubsubsDelete* = Call_RunNamespacesPubsubsDelete_580198(
    name: "runNamespacesPubsubsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/events.cloud.google.com/v1alpha1/{name}",
    validator: validate_RunNamespacesPubsubsDelete_580199, base: "/",
    url: url_RunNamespacesPubsubsDelete_580200, schemes: {Scheme.Https})
type
  Call_RunNamespacesPubsubsCreate_580246 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesPubsubsCreate_580248(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/events.cloud.google.com/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/pubsubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesPubsubsCreate_580247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new pubsub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this pubsub should
  ## be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580249 = path.getOrDefault("parent")
  valid_580249 = validateParameter(valid_580249, JString, required = true,
                                 default = nil)
  if valid_580249 != nil:
    section.add "parent", valid_580249
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
  var valid_580250 = query.getOrDefault("key")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "key", valid_580250
  var valid_580251 = query.getOrDefault("prettyPrint")
  valid_580251 = validateParameter(valid_580251, JBool, required = false,
                                 default = newJBool(true))
  if valid_580251 != nil:
    section.add "prettyPrint", valid_580251
  var valid_580252 = query.getOrDefault("oauth_token")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "oauth_token", valid_580252
  var valid_580253 = query.getOrDefault("$.xgafv")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = newJString("1"))
  if valid_580253 != nil:
    section.add "$.xgafv", valid_580253
  var valid_580254 = query.getOrDefault("alt")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = newJString("json"))
  if valid_580254 != nil:
    section.add "alt", valid_580254
  var valid_580255 = query.getOrDefault("uploadType")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "uploadType", valid_580255
  var valid_580256 = query.getOrDefault("quotaUser")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "quotaUser", valid_580256
  var valid_580257 = query.getOrDefault("callback")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "callback", valid_580257
  var valid_580258 = query.getOrDefault("fields")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "fields", valid_580258
  var valid_580259 = query.getOrDefault("access_token")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "access_token", valid_580259
  var valid_580260 = query.getOrDefault("upload_protocol")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "upload_protocol", valid_580260
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

proc call*(call_580262: Call_RunNamespacesPubsubsCreate_580246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new pubsub.
  ## 
  let valid = call_580262.validator(path, query, header, formData, body)
  let scheme = call_580262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580262.url(scheme.get, call_580262.host, call_580262.base,
                         call_580262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580262, url, valid)

proc call*(call_580263: Call_RunNamespacesPubsubsCreate_580246; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesPubsubsCreate
  ## Creates a new pubsub.
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
  ##         : The project ID or project number in which this pubsub should
  ## be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580264 = newJObject()
  var query_580265 = newJObject()
  var body_580266 = newJObject()
  add(query_580265, "key", newJString(key))
  add(query_580265, "prettyPrint", newJBool(prettyPrint))
  add(query_580265, "oauth_token", newJString(oauthToken))
  add(query_580265, "$.xgafv", newJString(Xgafv))
  add(query_580265, "alt", newJString(alt))
  add(query_580265, "uploadType", newJString(uploadType))
  add(query_580265, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580266 = body
  add(query_580265, "callback", newJString(callback))
  add(path_580264, "parent", newJString(parent))
  add(query_580265, "fields", newJString(fields))
  add(query_580265, "access_token", newJString(accessToken))
  add(query_580265, "upload_protocol", newJString(uploadProtocol))
  result = call_580263.call(path_580264, query_580265, nil, nil, body_580266)

var runNamespacesPubsubsCreate* = Call_RunNamespacesPubsubsCreate_580246(
    name: "runNamespacesPubsubsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/events.cloud.google.com/v1alpha1/{parent}/pubsubs",
    validator: validate_RunNamespacesPubsubsCreate_580247, base: "/",
    url: url_RunNamespacesPubsubsCreate_580248, schemes: {Scheme.Https})
type
  Call_RunNamespacesPubsubsList_580220 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesPubsubsList_580222(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/events.cloud.google.com/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/pubsubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunNamespacesPubsubsList_580221(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list pubsubs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the pubsubs should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580223 = path.getOrDefault("parent")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "parent", valid_580223
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
  var valid_580224 = query.getOrDefault("key")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "key", valid_580224
  var valid_580225 = query.getOrDefault("includeUninitialized")
  valid_580225 = validateParameter(valid_580225, JBool, required = false, default = nil)
  if valid_580225 != nil:
    section.add "includeUninitialized", valid_580225
  var valid_580226 = query.getOrDefault("prettyPrint")
  valid_580226 = validateParameter(valid_580226, JBool, required = false,
                                 default = newJBool(true))
  if valid_580226 != nil:
    section.add "prettyPrint", valid_580226
  var valid_580227 = query.getOrDefault("oauth_token")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "oauth_token", valid_580227
  var valid_580228 = query.getOrDefault("fieldSelector")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "fieldSelector", valid_580228
  var valid_580229 = query.getOrDefault("labelSelector")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "labelSelector", valid_580229
  var valid_580230 = query.getOrDefault("$.xgafv")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = newJString("1"))
  if valid_580230 != nil:
    section.add "$.xgafv", valid_580230
  var valid_580231 = query.getOrDefault("limit")
  valid_580231 = validateParameter(valid_580231, JInt, required = false, default = nil)
  if valid_580231 != nil:
    section.add "limit", valid_580231
  var valid_580232 = query.getOrDefault("alt")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = newJString("json"))
  if valid_580232 != nil:
    section.add "alt", valid_580232
  var valid_580233 = query.getOrDefault("uploadType")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "uploadType", valid_580233
  var valid_580234 = query.getOrDefault("quotaUser")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "quotaUser", valid_580234
  var valid_580235 = query.getOrDefault("watch")
  valid_580235 = validateParameter(valid_580235, JBool, required = false, default = nil)
  if valid_580235 != nil:
    section.add "watch", valid_580235
  var valid_580236 = query.getOrDefault("callback")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "callback", valid_580236
  var valid_580237 = query.getOrDefault("resourceVersion")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "resourceVersion", valid_580237
  var valid_580238 = query.getOrDefault("fields")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "fields", valid_580238
  var valid_580239 = query.getOrDefault("access_token")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "access_token", valid_580239
  var valid_580240 = query.getOrDefault("upload_protocol")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "upload_protocol", valid_580240
  var valid_580241 = query.getOrDefault("continue")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "continue", valid_580241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580242: Call_RunNamespacesPubsubsList_580220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list pubsubs.
  ## 
  let valid = call_580242.validator(path, query, header, formData, body)
  let scheme = call_580242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580242.url(scheme.get, call_580242.host, call_580242.base,
                         call_580242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580242, url, valid)

proc call*(call_580243: Call_RunNamespacesPubsubsList_580220; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesPubsubsList
  ## Rpc to list pubsubs.
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
  ##         : The project ID or project number from which the pubsubs should
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
  var path_580244 = newJObject()
  var query_580245 = newJObject()
  add(query_580245, "key", newJString(key))
  add(query_580245, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580245, "prettyPrint", newJBool(prettyPrint))
  add(query_580245, "oauth_token", newJString(oauthToken))
  add(query_580245, "fieldSelector", newJString(fieldSelector))
  add(query_580245, "labelSelector", newJString(labelSelector))
  add(query_580245, "$.xgafv", newJString(Xgafv))
  add(query_580245, "limit", newJInt(limit))
  add(query_580245, "alt", newJString(alt))
  add(query_580245, "uploadType", newJString(uploadType))
  add(query_580245, "quotaUser", newJString(quotaUser))
  add(query_580245, "watch", newJBool(watch))
  add(query_580245, "callback", newJString(callback))
  add(path_580244, "parent", newJString(parent))
  add(query_580245, "resourceVersion", newJString(resourceVersion))
  add(query_580245, "fields", newJString(fields))
  add(query_580245, "access_token", newJString(accessToken))
  add(query_580245, "upload_protocol", newJString(uploadProtocol))
  add(query_580245, "continue", newJString(`continue`))
  result = call_580243.call(path_580244, query_580245, nil, nil, nil)

var runNamespacesPubsubsList* = Call_RunNamespacesPubsubsList_580220(
    name: "runNamespacesPubsubsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/events.cloud.google.com/v1alpha1/{parent}/pubsubs",
    validator: validate_RunNamespacesPubsubsList_580221, base: "/",
    url: url_RunNamespacesPubsubsList_580222, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesReplaceService_580286 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesServicesReplaceService_580288(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
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

proc validate_RunNamespacesServicesReplaceService_580287(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to replace a service.
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
  ##       : The name of the service being replaced. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580289 = path.getOrDefault("name")
  valid_580289 = validateParameter(valid_580289, JString, required = true,
                                 default = nil)
  if valid_580289 != nil:
    section.add "name", valid_580289
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
  var valid_580290 = query.getOrDefault("key")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "key", valid_580290
  var valid_580291 = query.getOrDefault("prettyPrint")
  valid_580291 = validateParameter(valid_580291, JBool, required = false,
                                 default = newJBool(true))
  if valid_580291 != nil:
    section.add "prettyPrint", valid_580291
  var valid_580292 = query.getOrDefault("oauth_token")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "oauth_token", valid_580292
  var valid_580293 = query.getOrDefault("$.xgafv")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = newJString("1"))
  if valid_580293 != nil:
    section.add "$.xgafv", valid_580293
  var valid_580294 = query.getOrDefault("alt")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = newJString("json"))
  if valid_580294 != nil:
    section.add "alt", valid_580294
  var valid_580295 = query.getOrDefault("uploadType")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "uploadType", valid_580295
  var valid_580296 = query.getOrDefault("quotaUser")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "quotaUser", valid_580296
  var valid_580297 = query.getOrDefault("callback")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "callback", valid_580297
  var valid_580298 = query.getOrDefault("fields")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "fields", valid_580298
  var valid_580299 = query.getOrDefault("access_token")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "access_token", valid_580299
  var valid_580300 = query.getOrDefault("upload_protocol")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "upload_protocol", valid_580300
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

proc call*(call_580302: Call_RunNamespacesServicesReplaceService_580286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to replace a service.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_580302.validator(path, query, header, formData, body)
  let scheme = call_580302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580302.url(scheme.get, call_580302.host, call_580302.base,
                         call_580302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580302, url, valid)

proc call*(call_580303: Call_RunNamespacesServicesReplaceService_580286;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesServicesReplaceService
  ## Rpc to replace a service.
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
  ##       : The name of the service being replaced. If needed, replace
  ## {namespace_id} with the project ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580304 = newJObject()
  var query_580305 = newJObject()
  var body_580306 = newJObject()
  add(query_580305, "key", newJString(key))
  add(query_580305, "prettyPrint", newJBool(prettyPrint))
  add(query_580305, "oauth_token", newJString(oauthToken))
  add(query_580305, "$.xgafv", newJString(Xgafv))
  add(query_580305, "alt", newJString(alt))
  add(query_580305, "uploadType", newJString(uploadType))
  add(query_580305, "quotaUser", newJString(quotaUser))
  add(path_580304, "name", newJString(name))
  if body != nil:
    body_580306 = body
  add(query_580305, "callback", newJString(callback))
  add(query_580305, "fields", newJString(fields))
  add(query_580305, "access_token", newJString(accessToken))
  add(query_580305, "upload_protocol", newJString(uploadProtocol))
  result = call_580303.call(path_580304, query_580305, nil, nil, body_580306)

var runNamespacesServicesReplaceService* = Call_RunNamespacesServicesReplaceService_580286(
    name: "runNamespacesServicesReplaceService", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesServicesReplaceService_580287, base: "/",
    url: url_RunNamespacesServicesReplaceService_580288, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsGet_580267 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesConfigurationsGet_580269(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
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

proc validate_RunNamespacesConfigurationsGet_580268(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to get information about a configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580270 = path.getOrDefault("name")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "name", valid_580270
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
  var valid_580271 = query.getOrDefault("key")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "key", valid_580271
  var valid_580272 = query.getOrDefault("prettyPrint")
  valid_580272 = validateParameter(valid_580272, JBool, required = false,
                                 default = newJBool(true))
  if valid_580272 != nil:
    section.add "prettyPrint", valid_580272
  var valid_580273 = query.getOrDefault("oauth_token")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "oauth_token", valid_580273
  var valid_580274 = query.getOrDefault("$.xgafv")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = newJString("1"))
  if valid_580274 != nil:
    section.add "$.xgafv", valid_580274
  var valid_580275 = query.getOrDefault("alt")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = newJString("json"))
  if valid_580275 != nil:
    section.add "alt", valid_580275
  var valid_580276 = query.getOrDefault("uploadType")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "uploadType", valid_580276
  var valid_580277 = query.getOrDefault("quotaUser")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "quotaUser", valid_580277
  var valid_580278 = query.getOrDefault("callback")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "callback", valid_580278
  var valid_580279 = query.getOrDefault("fields")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "fields", valid_580279
  var valid_580280 = query.getOrDefault("access_token")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "access_token", valid_580280
  var valid_580281 = query.getOrDefault("upload_protocol")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "upload_protocol", valid_580281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580282: Call_RunNamespacesConfigurationsGet_580267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a configuration.
  ## 
  let valid = call_580282.validator(path, query, header, formData, body)
  let scheme = call_580282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580282.url(scheme.get, call_580282.host, call_580282.base,
                         call_580282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580282, url, valid)

proc call*(call_580283: Call_RunNamespacesConfigurationsGet_580267; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesConfigurationsGet
  ## Rpc to get information about a configuration.
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
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580284 = newJObject()
  var query_580285 = newJObject()
  add(query_580285, "key", newJString(key))
  add(query_580285, "prettyPrint", newJBool(prettyPrint))
  add(query_580285, "oauth_token", newJString(oauthToken))
  add(query_580285, "$.xgafv", newJString(Xgafv))
  add(query_580285, "alt", newJString(alt))
  add(query_580285, "uploadType", newJString(uploadType))
  add(query_580285, "quotaUser", newJString(quotaUser))
  add(path_580284, "name", newJString(name))
  add(query_580285, "callback", newJString(callback))
  add(query_580285, "fields", newJString(fields))
  add(query_580285, "access_token", newJString(accessToken))
  add(query_580285, "upload_protocol", newJString(uploadProtocol))
  result = call_580283.call(path_580284, query_580285, nil, nil, nil)

var runNamespacesConfigurationsGet* = Call_RunNamespacesConfigurationsGet_580267(
    name: "runNamespacesConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesConfigurationsGet_580268, base: "/",
    url: url_RunNamespacesConfigurationsGet_580269, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsDelete_580307 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesRevisionsDelete_580309(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
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

proc validate_RunNamespacesRevisionsDelete_580308(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to delete a revision.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the revision being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580310 = path.getOrDefault("name")
  valid_580310 = validateParameter(valid_580310, JString, required = true,
                                 default = nil)
  if valid_580310 != nil:
    section.add "name", valid_580310
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
  ##   orphanDependents: JBool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580311 = query.getOrDefault("key")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "key", valid_580311
  var valid_580312 = query.getOrDefault("prettyPrint")
  valid_580312 = validateParameter(valid_580312, JBool, required = false,
                                 default = newJBool(true))
  if valid_580312 != nil:
    section.add "prettyPrint", valid_580312
  var valid_580313 = query.getOrDefault("oauth_token")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "oauth_token", valid_580313
  var valid_580314 = query.getOrDefault("$.xgafv")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = newJString("1"))
  if valid_580314 != nil:
    section.add "$.xgafv", valid_580314
  var valid_580315 = query.getOrDefault("alt")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = newJString("json"))
  if valid_580315 != nil:
    section.add "alt", valid_580315
  var valid_580316 = query.getOrDefault("uploadType")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "uploadType", valid_580316
  var valid_580317 = query.getOrDefault("quotaUser")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "quotaUser", valid_580317
  var valid_580318 = query.getOrDefault("propagationPolicy")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "propagationPolicy", valid_580318
  var valid_580319 = query.getOrDefault("callback")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "callback", valid_580319
  var valid_580320 = query.getOrDefault("apiVersion")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "apiVersion", valid_580320
  var valid_580321 = query.getOrDefault("orphanDependents")
  valid_580321 = validateParameter(valid_580321, JBool, required = false, default = nil)
  if valid_580321 != nil:
    section.add "orphanDependents", valid_580321
  var valid_580322 = query.getOrDefault("kind")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "kind", valid_580322
  var valid_580323 = query.getOrDefault("fields")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "fields", valid_580323
  var valid_580324 = query.getOrDefault("access_token")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "access_token", valid_580324
  var valid_580325 = query.getOrDefault("upload_protocol")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "upload_protocol", valid_580325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580326: Call_RunNamespacesRevisionsDelete_580307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to delete a revision.
  ## 
  let valid = call_580326.validator(path, query, header, formData, body)
  let scheme = call_580326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580326.url(scheme.get, call_580326.host, call_580326.base,
                         call_580326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580326, url, valid)

proc call*(call_580327: Call_RunNamespacesRevisionsDelete_580307; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; propagationPolicy: string = ""; callback: string = "";
          apiVersion: string = ""; orphanDependents: bool = false; kind: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesRevisionsDelete
  ## Rpc to delete a revision.
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
  ##       : The name of the revision being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: string
  ##           : JSONP
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  ##   orphanDependents: bool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580328 = newJObject()
  var query_580329 = newJObject()
  add(query_580329, "key", newJString(key))
  add(query_580329, "prettyPrint", newJBool(prettyPrint))
  add(query_580329, "oauth_token", newJString(oauthToken))
  add(query_580329, "$.xgafv", newJString(Xgafv))
  add(query_580329, "alt", newJString(alt))
  add(query_580329, "uploadType", newJString(uploadType))
  add(query_580329, "quotaUser", newJString(quotaUser))
  add(path_580328, "name", newJString(name))
  add(query_580329, "propagationPolicy", newJString(propagationPolicy))
  add(query_580329, "callback", newJString(callback))
  add(query_580329, "apiVersion", newJString(apiVersion))
  add(query_580329, "orphanDependents", newJBool(orphanDependents))
  add(query_580329, "kind", newJString(kind))
  add(query_580329, "fields", newJString(fields))
  add(query_580329, "access_token", newJString(accessToken))
  add(query_580329, "upload_protocol", newJString(uploadProtocol))
  result = call_580327.call(path_580328, query_580329, nil, nil, nil)

var runNamespacesRevisionsDelete* = Call_RunNamespacesRevisionsDelete_580307(
    name: "runNamespacesRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesRevisionsDelete_580308, base: "/",
    url: url_RunNamespacesRevisionsDelete_580309, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsList_580330 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesConfigurationsList_580332(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
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

proc validate_RunNamespacesConfigurationsList_580331(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580333 = path.getOrDefault("parent")
  valid_580333 = validateParameter(valid_580333, JString, required = true,
                                 default = nil)
  if valid_580333 != nil:
    section.add "parent", valid_580333
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
  var valid_580334 = query.getOrDefault("key")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "key", valid_580334
  var valid_580335 = query.getOrDefault("includeUninitialized")
  valid_580335 = validateParameter(valid_580335, JBool, required = false, default = nil)
  if valid_580335 != nil:
    section.add "includeUninitialized", valid_580335
  var valid_580336 = query.getOrDefault("prettyPrint")
  valid_580336 = validateParameter(valid_580336, JBool, required = false,
                                 default = newJBool(true))
  if valid_580336 != nil:
    section.add "prettyPrint", valid_580336
  var valid_580337 = query.getOrDefault("oauth_token")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "oauth_token", valid_580337
  var valid_580338 = query.getOrDefault("fieldSelector")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "fieldSelector", valid_580338
  var valid_580339 = query.getOrDefault("labelSelector")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "labelSelector", valid_580339
  var valid_580340 = query.getOrDefault("$.xgafv")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = newJString("1"))
  if valid_580340 != nil:
    section.add "$.xgafv", valid_580340
  var valid_580341 = query.getOrDefault("limit")
  valid_580341 = validateParameter(valid_580341, JInt, required = false, default = nil)
  if valid_580341 != nil:
    section.add "limit", valid_580341
  var valid_580342 = query.getOrDefault("alt")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = newJString("json"))
  if valid_580342 != nil:
    section.add "alt", valid_580342
  var valid_580343 = query.getOrDefault("uploadType")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "uploadType", valid_580343
  var valid_580344 = query.getOrDefault("quotaUser")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "quotaUser", valid_580344
  var valid_580345 = query.getOrDefault("watch")
  valid_580345 = validateParameter(valid_580345, JBool, required = false, default = nil)
  if valid_580345 != nil:
    section.add "watch", valid_580345
  var valid_580346 = query.getOrDefault("callback")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "callback", valid_580346
  var valid_580347 = query.getOrDefault("resourceVersion")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "resourceVersion", valid_580347
  var valid_580348 = query.getOrDefault("fields")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "fields", valid_580348
  var valid_580349 = query.getOrDefault("access_token")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "access_token", valid_580349
  var valid_580350 = query.getOrDefault("upload_protocol")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "upload_protocol", valid_580350
  var valid_580351 = query.getOrDefault("continue")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "continue", valid_580351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580352: Call_RunNamespacesConfigurationsList_580330;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list configurations.
  ## 
  let valid = call_580352.validator(path, query, header, formData, body)
  let scheme = call_580352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580352.url(scheme.get, call_580352.host, call_580352.base,
                         call_580352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580352, url, valid)

proc call*(call_580353: Call_RunNamespacesConfigurationsList_580330;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesConfigurationsList
  ## Rpc to list configurations.
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
  ##         : The project ID or project number from which the configurations should be
  ## listed.
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
  var path_580354 = newJObject()
  var query_580355 = newJObject()
  add(query_580355, "key", newJString(key))
  add(query_580355, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580355, "prettyPrint", newJBool(prettyPrint))
  add(query_580355, "oauth_token", newJString(oauthToken))
  add(query_580355, "fieldSelector", newJString(fieldSelector))
  add(query_580355, "labelSelector", newJString(labelSelector))
  add(query_580355, "$.xgafv", newJString(Xgafv))
  add(query_580355, "limit", newJInt(limit))
  add(query_580355, "alt", newJString(alt))
  add(query_580355, "uploadType", newJString(uploadType))
  add(query_580355, "quotaUser", newJString(quotaUser))
  add(query_580355, "watch", newJBool(watch))
  add(query_580355, "callback", newJString(callback))
  add(path_580354, "parent", newJString(parent))
  add(query_580355, "resourceVersion", newJString(resourceVersion))
  add(query_580355, "fields", newJString(fields))
  add(query_580355, "access_token", newJString(accessToken))
  add(query_580355, "upload_protocol", newJString(uploadProtocol))
  add(query_580355, "continue", newJString(`continue`))
  result = call_580353.call(path_580354, query_580355, nil, nil, nil)

var runNamespacesConfigurationsList* = Call_RunNamespacesConfigurationsList_580330(
    name: "runNamespacesConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsList_580331, base: "/",
    url: url_RunNamespacesConfigurationsList_580332, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsList_580356 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesRevisionsList_580358(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
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

proc validate_RunNamespacesRevisionsList_580357(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the revisions should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580359 = path.getOrDefault("parent")
  valid_580359 = validateParameter(valid_580359, JString, required = true,
                                 default = nil)
  if valid_580359 != nil:
    section.add "parent", valid_580359
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
  var valid_580360 = query.getOrDefault("key")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "key", valid_580360
  var valid_580361 = query.getOrDefault("includeUninitialized")
  valid_580361 = validateParameter(valid_580361, JBool, required = false, default = nil)
  if valid_580361 != nil:
    section.add "includeUninitialized", valid_580361
  var valid_580362 = query.getOrDefault("prettyPrint")
  valid_580362 = validateParameter(valid_580362, JBool, required = false,
                                 default = newJBool(true))
  if valid_580362 != nil:
    section.add "prettyPrint", valid_580362
  var valid_580363 = query.getOrDefault("oauth_token")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "oauth_token", valid_580363
  var valid_580364 = query.getOrDefault("fieldSelector")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "fieldSelector", valid_580364
  var valid_580365 = query.getOrDefault("labelSelector")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "labelSelector", valid_580365
  var valid_580366 = query.getOrDefault("$.xgafv")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = newJString("1"))
  if valid_580366 != nil:
    section.add "$.xgafv", valid_580366
  var valid_580367 = query.getOrDefault("limit")
  valid_580367 = validateParameter(valid_580367, JInt, required = false, default = nil)
  if valid_580367 != nil:
    section.add "limit", valid_580367
  var valid_580368 = query.getOrDefault("alt")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = newJString("json"))
  if valid_580368 != nil:
    section.add "alt", valid_580368
  var valid_580369 = query.getOrDefault("uploadType")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "uploadType", valid_580369
  var valid_580370 = query.getOrDefault("quotaUser")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "quotaUser", valid_580370
  var valid_580371 = query.getOrDefault("watch")
  valid_580371 = validateParameter(valid_580371, JBool, required = false, default = nil)
  if valid_580371 != nil:
    section.add "watch", valid_580371
  var valid_580372 = query.getOrDefault("callback")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "callback", valid_580372
  var valid_580373 = query.getOrDefault("resourceVersion")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "resourceVersion", valid_580373
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
  var valid_580377 = query.getOrDefault("continue")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "continue", valid_580377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580378: Call_RunNamespacesRevisionsList_580356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list revisions.
  ## 
  let valid = call_580378.validator(path, query, header, formData, body)
  let scheme = call_580378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580378.url(scheme.get, call_580378.host, call_580378.base,
                         call_580378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580378, url, valid)

proc call*(call_580379: Call_RunNamespacesRevisionsList_580356; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesRevisionsList
  ## Rpc to list revisions.
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
  ##         : The project ID or project number from which the revisions should be listed.
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
  var path_580380 = newJObject()
  var query_580381 = newJObject()
  add(query_580381, "key", newJString(key))
  add(query_580381, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580381, "prettyPrint", newJBool(prettyPrint))
  add(query_580381, "oauth_token", newJString(oauthToken))
  add(query_580381, "fieldSelector", newJString(fieldSelector))
  add(query_580381, "labelSelector", newJString(labelSelector))
  add(query_580381, "$.xgafv", newJString(Xgafv))
  add(query_580381, "limit", newJInt(limit))
  add(query_580381, "alt", newJString(alt))
  add(query_580381, "uploadType", newJString(uploadType))
  add(query_580381, "quotaUser", newJString(quotaUser))
  add(query_580381, "watch", newJBool(watch))
  add(query_580381, "callback", newJString(callback))
  add(path_580380, "parent", newJString(parent))
  add(query_580381, "resourceVersion", newJString(resourceVersion))
  add(query_580381, "fields", newJString(fields))
  add(query_580381, "access_token", newJString(accessToken))
  add(query_580381, "upload_protocol", newJString(uploadProtocol))
  add(query_580381, "continue", newJString(`continue`))
  result = call_580379.call(path_580380, query_580381, nil, nil, nil)

var runNamespacesRevisionsList* = Call_RunNamespacesRevisionsList_580356(
    name: "runNamespacesRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/revisions",
    validator: validate_RunNamespacesRevisionsList_580357, base: "/",
    url: url_RunNamespacesRevisionsList_580358, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesList_580382 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesRoutesList_580384(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
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

proc validate_RunNamespacesRoutesList_580383(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list routes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the routes should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580385 = path.getOrDefault("parent")
  valid_580385 = validateParameter(valid_580385, JString, required = true,
                                 default = nil)
  if valid_580385 != nil:
    section.add "parent", valid_580385
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
  var valid_580386 = query.getOrDefault("key")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "key", valid_580386
  var valid_580387 = query.getOrDefault("includeUninitialized")
  valid_580387 = validateParameter(valid_580387, JBool, required = false, default = nil)
  if valid_580387 != nil:
    section.add "includeUninitialized", valid_580387
  var valid_580388 = query.getOrDefault("prettyPrint")
  valid_580388 = validateParameter(valid_580388, JBool, required = false,
                                 default = newJBool(true))
  if valid_580388 != nil:
    section.add "prettyPrint", valid_580388
  var valid_580389 = query.getOrDefault("oauth_token")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "oauth_token", valid_580389
  var valid_580390 = query.getOrDefault("fieldSelector")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "fieldSelector", valid_580390
  var valid_580391 = query.getOrDefault("labelSelector")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "labelSelector", valid_580391
  var valid_580392 = query.getOrDefault("$.xgafv")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = newJString("1"))
  if valid_580392 != nil:
    section.add "$.xgafv", valid_580392
  var valid_580393 = query.getOrDefault("limit")
  valid_580393 = validateParameter(valid_580393, JInt, required = false, default = nil)
  if valid_580393 != nil:
    section.add "limit", valid_580393
  var valid_580394 = query.getOrDefault("alt")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = newJString("json"))
  if valid_580394 != nil:
    section.add "alt", valid_580394
  var valid_580395 = query.getOrDefault("uploadType")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "uploadType", valid_580395
  var valid_580396 = query.getOrDefault("quotaUser")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "quotaUser", valid_580396
  var valid_580397 = query.getOrDefault("watch")
  valid_580397 = validateParameter(valid_580397, JBool, required = false, default = nil)
  if valid_580397 != nil:
    section.add "watch", valid_580397
  var valid_580398 = query.getOrDefault("callback")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "callback", valid_580398
  var valid_580399 = query.getOrDefault("resourceVersion")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "resourceVersion", valid_580399
  var valid_580400 = query.getOrDefault("fields")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "fields", valid_580400
  var valid_580401 = query.getOrDefault("access_token")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "access_token", valid_580401
  var valid_580402 = query.getOrDefault("upload_protocol")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "upload_protocol", valid_580402
  var valid_580403 = query.getOrDefault("continue")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "continue", valid_580403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580404: Call_RunNamespacesRoutesList_580382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list routes.
  ## 
  let valid = call_580404.validator(path, query, header, formData, body)
  let scheme = call_580404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580404.url(scheme.get, call_580404.host, call_580404.base,
                         call_580404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580404, url, valid)

proc call*(call_580405: Call_RunNamespacesRoutesList_580382; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesRoutesList
  ## Rpc to list routes.
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
  ##         : The project ID or project number from which the routes should be listed.
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
  var path_580406 = newJObject()
  var query_580407 = newJObject()
  add(query_580407, "key", newJString(key))
  add(query_580407, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580407, "prettyPrint", newJBool(prettyPrint))
  add(query_580407, "oauth_token", newJString(oauthToken))
  add(query_580407, "fieldSelector", newJString(fieldSelector))
  add(query_580407, "labelSelector", newJString(labelSelector))
  add(query_580407, "$.xgafv", newJString(Xgafv))
  add(query_580407, "limit", newJInt(limit))
  add(query_580407, "alt", newJString(alt))
  add(query_580407, "uploadType", newJString(uploadType))
  add(query_580407, "quotaUser", newJString(quotaUser))
  add(query_580407, "watch", newJBool(watch))
  add(query_580407, "callback", newJString(callback))
  add(path_580406, "parent", newJString(parent))
  add(query_580407, "resourceVersion", newJString(resourceVersion))
  add(query_580407, "fields", newJString(fields))
  add(query_580407, "access_token", newJString(accessToken))
  add(query_580407, "upload_protocol", newJString(uploadProtocol))
  add(query_580407, "continue", newJString(`continue`))
  result = call_580405.call(path_580406, query_580407, nil, nil, nil)

var runNamespacesRoutesList* = Call_RunNamespacesRoutesList_580382(
    name: "runNamespacesRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/routes",
    validator: validate_RunNamespacesRoutesList_580383, base: "/",
    url: url_RunNamespacesRoutesList_580384, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesCreate_580434 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesServicesCreate_580436(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
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

proc validate_RunNamespacesServicesCreate_580435(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to create a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this service should be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580437 = path.getOrDefault("parent")
  valid_580437 = validateParameter(valid_580437, JString, required = true,
                                 default = nil)
  if valid_580437 != nil:
    section.add "parent", valid_580437
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
  var valid_580438 = query.getOrDefault("key")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "key", valid_580438
  var valid_580439 = query.getOrDefault("prettyPrint")
  valid_580439 = validateParameter(valid_580439, JBool, required = false,
                                 default = newJBool(true))
  if valid_580439 != nil:
    section.add "prettyPrint", valid_580439
  var valid_580440 = query.getOrDefault("oauth_token")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "oauth_token", valid_580440
  var valid_580441 = query.getOrDefault("$.xgafv")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = newJString("1"))
  if valid_580441 != nil:
    section.add "$.xgafv", valid_580441
  var valid_580442 = query.getOrDefault("alt")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = newJString("json"))
  if valid_580442 != nil:
    section.add "alt", valid_580442
  var valid_580443 = query.getOrDefault("uploadType")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "uploadType", valid_580443
  var valid_580444 = query.getOrDefault("quotaUser")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "quotaUser", valid_580444
  var valid_580445 = query.getOrDefault("callback")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "callback", valid_580445
  var valid_580446 = query.getOrDefault("fields")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "fields", valid_580446
  var valid_580447 = query.getOrDefault("access_token")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "access_token", valid_580447
  var valid_580448 = query.getOrDefault("upload_protocol")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "upload_protocol", valid_580448
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

proc call*(call_580450: Call_RunNamespacesServicesCreate_580434; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to create a service.
  ## 
  let valid = call_580450.validator(path, query, header, formData, body)
  let scheme = call_580450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580450.url(scheme.get, call_580450.host, call_580450.base,
                         call_580450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580450, url, valid)

proc call*(call_580451: Call_RunNamespacesServicesCreate_580434; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesServicesCreate
  ## Rpc to create a service.
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
  ##         : The project ID or project number in which this service should be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580452 = newJObject()
  var query_580453 = newJObject()
  var body_580454 = newJObject()
  add(query_580453, "key", newJString(key))
  add(query_580453, "prettyPrint", newJBool(prettyPrint))
  add(query_580453, "oauth_token", newJString(oauthToken))
  add(query_580453, "$.xgafv", newJString(Xgafv))
  add(query_580453, "alt", newJString(alt))
  add(query_580453, "uploadType", newJString(uploadType))
  add(query_580453, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580454 = body
  add(query_580453, "callback", newJString(callback))
  add(path_580452, "parent", newJString(parent))
  add(query_580453, "fields", newJString(fields))
  add(query_580453, "access_token", newJString(accessToken))
  add(query_580453, "upload_protocol", newJString(uploadProtocol))
  result = call_580451.call(path_580452, query_580453, nil, nil, body_580454)

var runNamespacesServicesCreate* = Call_RunNamespacesServicesCreate_580434(
    name: "runNamespacesServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/services",
    validator: validate_RunNamespacesServicesCreate_580435, base: "/",
    url: url_RunNamespacesServicesCreate_580436, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesList_580408 = ref object of OpenApiRestCall_579373
proc url_RunNamespacesServicesList_580410(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
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

proc validate_RunNamespacesServicesList_580409(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the services should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580411 = path.getOrDefault("parent")
  valid_580411 = validateParameter(valid_580411, JString, required = true,
                                 default = nil)
  if valid_580411 != nil:
    section.add "parent", valid_580411
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
  var valid_580412 = query.getOrDefault("key")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "key", valid_580412
  var valid_580413 = query.getOrDefault("includeUninitialized")
  valid_580413 = validateParameter(valid_580413, JBool, required = false, default = nil)
  if valid_580413 != nil:
    section.add "includeUninitialized", valid_580413
  var valid_580414 = query.getOrDefault("prettyPrint")
  valid_580414 = validateParameter(valid_580414, JBool, required = false,
                                 default = newJBool(true))
  if valid_580414 != nil:
    section.add "prettyPrint", valid_580414
  var valid_580415 = query.getOrDefault("oauth_token")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "oauth_token", valid_580415
  var valid_580416 = query.getOrDefault("fieldSelector")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "fieldSelector", valid_580416
  var valid_580417 = query.getOrDefault("labelSelector")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "labelSelector", valid_580417
  var valid_580418 = query.getOrDefault("$.xgafv")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = newJString("1"))
  if valid_580418 != nil:
    section.add "$.xgafv", valid_580418
  var valid_580419 = query.getOrDefault("limit")
  valid_580419 = validateParameter(valid_580419, JInt, required = false, default = nil)
  if valid_580419 != nil:
    section.add "limit", valid_580419
  var valid_580420 = query.getOrDefault("alt")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = newJString("json"))
  if valid_580420 != nil:
    section.add "alt", valid_580420
  var valid_580421 = query.getOrDefault("uploadType")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "uploadType", valid_580421
  var valid_580422 = query.getOrDefault("quotaUser")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "quotaUser", valid_580422
  var valid_580423 = query.getOrDefault("watch")
  valid_580423 = validateParameter(valid_580423, JBool, required = false, default = nil)
  if valid_580423 != nil:
    section.add "watch", valid_580423
  var valid_580424 = query.getOrDefault("callback")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "callback", valid_580424
  var valid_580425 = query.getOrDefault("resourceVersion")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "resourceVersion", valid_580425
  var valid_580426 = query.getOrDefault("fields")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "fields", valid_580426
  var valid_580427 = query.getOrDefault("access_token")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "access_token", valid_580427
  var valid_580428 = query.getOrDefault("upload_protocol")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "upload_protocol", valid_580428
  var valid_580429 = query.getOrDefault("continue")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "continue", valid_580429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580430: Call_RunNamespacesServicesList_580408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list services.
  ## 
  let valid = call_580430.validator(path, query, header, formData, body)
  let scheme = call_580430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580430.url(scheme.get, call_580430.host, call_580430.base,
                         call_580430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580430, url, valid)

proc call*(call_580431: Call_RunNamespacesServicesList_580408; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesServicesList
  ## Rpc to list services.
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
  ##         : The project ID or project number from which the services should be listed.
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
  var path_580432 = newJObject()
  var query_580433 = newJObject()
  add(query_580433, "key", newJString(key))
  add(query_580433, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580433, "prettyPrint", newJBool(prettyPrint))
  add(query_580433, "oauth_token", newJString(oauthToken))
  add(query_580433, "fieldSelector", newJString(fieldSelector))
  add(query_580433, "labelSelector", newJString(labelSelector))
  add(query_580433, "$.xgafv", newJString(Xgafv))
  add(query_580433, "limit", newJInt(limit))
  add(query_580433, "alt", newJString(alt))
  add(query_580433, "uploadType", newJString(uploadType))
  add(query_580433, "quotaUser", newJString(quotaUser))
  add(query_580433, "watch", newJBool(watch))
  add(query_580433, "callback", newJString(callback))
  add(path_580432, "parent", newJString(parent))
  add(query_580433, "resourceVersion", newJString(resourceVersion))
  add(query_580433, "fields", newJString(fields))
  add(query_580433, "access_token", newJString(accessToken))
  add(query_580433, "upload_protocol", newJString(uploadProtocol))
  add(query_580433, "continue", newJString(`continue`))
  result = call_580431.call(path_580432, query_580433, nil, nil, nil)

var runNamespacesServicesList* = Call_RunNamespacesServicesList_580408(
    name: "runNamespacesServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/services",
    validator: validate_RunNamespacesServicesList_580409, base: "/",
    url: url_RunNamespacesServicesList_580410, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsPubsubsReplacePubSub_580474 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsPubsubsReplacePubSub_580476(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsPubsubsReplacePubSub_580475(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to replace a pubsub.
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
  ##       : The name of the pubsub being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580477 = path.getOrDefault("name")
  valid_580477 = validateParameter(valid_580477, JString, required = true,
                                 default = nil)
  if valid_580477 != nil:
    section.add "name", valid_580477
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
  var valid_580478 = query.getOrDefault("key")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "key", valid_580478
  var valid_580479 = query.getOrDefault("prettyPrint")
  valid_580479 = validateParameter(valid_580479, JBool, required = false,
                                 default = newJBool(true))
  if valid_580479 != nil:
    section.add "prettyPrint", valid_580479
  var valid_580480 = query.getOrDefault("oauth_token")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "oauth_token", valid_580480
  var valid_580481 = query.getOrDefault("$.xgafv")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = newJString("1"))
  if valid_580481 != nil:
    section.add "$.xgafv", valid_580481
  var valid_580482 = query.getOrDefault("alt")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = newJString("json"))
  if valid_580482 != nil:
    section.add "alt", valid_580482
  var valid_580483 = query.getOrDefault("uploadType")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "uploadType", valid_580483
  var valid_580484 = query.getOrDefault("quotaUser")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "quotaUser", valid_580484
  var valid_580485 = query.getOrDefault("callback")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "callback", valid_580485
  var valid_580486 = query.getOrDefault("fields")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "fields", valid_580486
  var valid_580487 = query.getOrDefault("access_token")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "access_token", valid_580487
  var valid_580488 = query.getOrDefault("upload_protocol")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "upload_protocol", valid_580488
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

proc call*(call_580490: Call_RunProjectsLocationsPubsubsReplacePubSub_580474;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to replace a pubsub.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_580490.validator(path, query, header, formData, body)
  let scheme = call_580490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580490.url(scheme.get, call_580490.host, call_580490.base,
                         call_580490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580490, url, valid)

proc call*(call_580491: Call_RunProjectsLocationsPubsubsReplacePubSub_580474;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsPubsubsReplacePubSub
  ## Rpc to replace a pubsub.
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
  ##       : The name of the pubsub being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580492 = newJObject()
  var query_580493 = newJObject()
  var body_580494 = newJObject()
  add(query_580493, "key", newJString(key))
  add(query_580493, "prettyPrint", newJBool(prettyPrint))
  add(query_580493, "oauth_token", newJString(oauthToken))
  add(query_580493, "$.xgafv", newJString(Xgafv))
  add(query_580493, "alt", newJString(alt))
  add(query_580493, "uploadType", newJString(uploadType))
  add(query_580493, "quotaUser", newJString(quotaUser))
  add(path_580492, "name", newJString(name))
  if body != nil:
    body_580494 = body
  add(query_580493, "callback", newJString(callback))
  add(query_580493, "fields", newJString(fields))
  add(query_580493, "access_token", newJString(accessToken))
  add(query_580493, "upload_protocol", newJString(uploadProtocol))
  result = call_580491.call(path_580492, query_580493, nil, nil, body_580494)

var runProjectsLocationsPubsubsReplacePubSub* = Call_RunProjectsLocationsPubsubsReplacePubSub_580474(
    name: "runProjectsLocationsPubsubsReplacePubSub", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsPubsubsReplacePubSub_580475,
    base: "/", url: url_RunProjectsLocationsPubsubsReplacePubSub_580476,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsGet_580455 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsConfigurationsGet_580457(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsConfigurationsGet_580456(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to get information about a configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580458 = path.getOrDefault("name")
  valid_580458 = validateParameter(valid_580458, JString, required = true,
                                 default = nil)
  if valid_580458 != nil:
    section.add "name", valid_580458
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
  var valid_580459 = query.getOrDefault("key")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "key", valid_580459
  var valid_580460 = query.getOrDefault("prettyPrint")
  valid_580460 = validateParameter(valid_580460, JBool, required = false,
                                 default = newJBool(true))
  if valid_580460 != nil:
    section.add "prettyPrint", valid_580460
  var valid_580461 = query.getOrDefault("oauth_token")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "oauth_token", valid_580461
  var valid_580462 = query.getOrDefault("$.xgafv")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = newJString("1"))
  if valid_580462 != nil:
    section.add "$.xgafv", valid_580462
  var valid_580463 = query.getOrDefault("alt")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = newJString("json"))
  if valid_580463 != nil:
    section.add "alt", valid_580463
  var valid_580464 = query.getOrDefault("uploadType")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "uploadType", valid_580464
  var valid_580465 = query.getOrDefault("quotaUser")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "quotaUser", valid_580465
  var valid_580466 = query.getOrDefault("callback")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "callback", valid_580466
  var valid_580467 = query.getOrDefault("fields")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "fields", valid_580467
  var valid_580468 = query.getOrDefault("access_token")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "access_token", valid_580468
  var valid_580469 = query.getOrDefault("upload_protocol")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "upload_protocol", valid_580469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580470: Call_RunProjectsLocationsConfigurationsGet_580455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to get information about a configuration.
  ## 
  let valid = call_580470.validator(path, query, header, formData, body)
  let scheme = call_580470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580470.url(scheme.get, call_580470.host, call_580470.base,
                         call_580470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580470, url, valid)

proc call*(call_580471: Call_RunProjectsLocationsConfigurationsGet_580455;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsConfigurationsGet
  ## Rpc to get information about a configuration.
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
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580472 = newJObject()
  var query_580473 = newJObject()
  add(query_580473, "key", newJString(key))
  add(query_580473, "prettyPrint", newJBool(prettyPrint))
  add(query_580473, "oauth_token", newJString(oauthToken))
  add(query_580473, "$.xgafv", newJString(Xgafv))
  add(query_580473, "alt", newJString(alt))
  add(query_580473, "uploadType", newJString(uploadType))
  add(query_580473, "quotaUser", newJString(quotaUser))
  add(path_580472, "name", newJString(name))
  add(query_580473, "callback", newJString(callback))
  add(query_580473, "fields", newJString(fields))
  add(query_580473, "access_token", newJString(accessToken))
  add(query_580473, "upload_protocol", newJString(uploadProtocol))
  result = call_580471.call(path_580472, query_580473, nil, nil, nil)

var runProjectsLocationsConfigurationsGet* = Call_RunProjectsLocationsConfigurationsGet_580455(
    name: "runProjectsLocationsConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsConfigurationsGet_580456, base: "/",
    url: url_RunProjectsLocationsConfigurationsGet_580457, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsDelete_580495 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsDomainmappingsDelete_580497(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsDelete_580496(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to delete a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580498 = path.getOrDefault("name")
  valid_580498 = validateParameter(valid_580498, JString, required = true,
                                 default = nil)
  if valid_580498 != nil:
    section.add "name", valid_580498
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
  ##   orphanDependents: JBool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580499 = query.getOrDefault("key")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "key", valid_580499
  var valid_580500 = query.getOrDefault("prettyPrint")
  valid_580500 = validateParameter(valid_580500, JBool, required = false,
                                 default = newJBool(true))
  if valid_580500 != nil:
    section.add "prettyPrint", valid_580500
  var valid_580501 = query.getOrDefault("oauth_token")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "oauth_token", valid_580501
  var valid_580502 = query.getOrDefault("$.xgafv")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = newJString("1"))
  if valid_580502 != nil:
    section.add "$.xgafv", valid_580502
  var valid_580503 = query.getOrDefault("alt")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = newJString("json"))
  if valid_580503 != nil:
    section.add "alt", valid_580503
  var valid_580504 = query.getOrDefault("uploadType")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "uploadType", valid_580504
  var valid_580505 = query.getOrDefault("quotaUser")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "quotaUser", valid_580505
  var valid_580506 = query.getOrDefault("propagationPolicy")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "propagationPolicy", valid_580506
  var valid_580507 = query.getOrDefault("callback")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "callback", valid_580507
  var valid_580508 = query.getOrDefault("apiVersion")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "apiVersion", valid_580508
  var valid_580509 = query.getOrDefault("orphanDependents")
  valid_580509 = validateParameter(valid_580509, JBool, required = false, default = nil)
  if valid_580509 != nil:
    section.add "orphanDependents", valid_580509
  var valid_580510 = query.getOrDefault("kind")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "kind", valid_580510
  var valid_580511 = query.getOrDefault("fields")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "fields", valid_580511
  var valid_580512 = query.getOrDefault("access_token")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "access_token", valid_580512
  var valid_580513 = query.getOrDefault("upload_protocol")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "upload_protocol", valid_580513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580514: Call_RunProjectsLocationsDomainmappingsDelete_580495;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to delete a domain mapping.
  ## 
  let valid = call_580514.validator(path, query, header, formData, body)
  let scheme = call_580514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580514.url(scheme.get, call_580514.host, call_580514.base,
                         call_580514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580514, url, valid)

proc call*(call_580515: Call_RunProjectsLocationsDomainmappingsDelete_580495;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          propagationPolicy: string = ""; callback: string = "";
          apiVersion: string = ""; orphanDependents: bool = false; kind: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsDelete
  ## Rpc to delete a domain mapping.
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
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: string
  ##           : JSONP
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  ##   orphanDependents: bool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580516 = newJObject()
  var query_580517 = newJObject()
  add(query_580517, "key", newJString(key))
  add(query_580517, "prettyPrint", newJBool(prettyPrint))
  add(query_580517, "oauth_token", newJString(oauthToken))
  add(query_580517, "$.xgafv", newJString(Xgafv))
  add(query_580517, "alt", newJString(alt))
  add(query_580517, "uploadType", newJString(uploadType))
  add(query_580517, "quotaUser", newJString(quotaUser))
  add(path_580516, "name", newJString(name))
  add(query_580517, "propagationPolicy", newJString(propagationPolicy))
  add(query_580517, "callback", newJString(callback))
  add(query_580517, "apiVersion", newJString(apiVersion))
  add(query_580517, "orphanDependents", newJBool(orphanDependents))
  add(query_580517, "kind", newJString(kind))
  add(query_580517, "fields", newJString(fields))
  add(query_580517, "access_token", newJString(accessToken))
  add(query_580517, "upload_protocol", newJString(uploadProtocol))
  result = call_580515.call(path_580516, query_580517, nil, nil, nil)

var runProjectsLocationsDomainmappingsDelete* = Call_RunProjectsLocationsDomainmappingsDelete_580495(
    name: "runProjectsLocationsDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsDelete_580496,
    base: "/", url: url_RunProjectsLocationsDomainmappingsDelete_580497,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsList_580518 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsList_580520(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
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

proc validate_RunProjectsLocationsList_580519(path: JsonNode; query: JsonNode;
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
  var valid_580521 = path.getOrDefault("name")
  valid_580521 = validateParameter(valid_580521, JString, required = true,
                                 default = nil)
  if valid_580521 != nil:
    section.add "name", valid_580521
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
  var valid_580522 = query.getOrDefault("key")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "key", valid_580522
  var valid_580523 = query.getOrDefault("prettyPrint")
  valid_580523 = validateParameter(valid_580523, JBool, required = false,
                                 default = newJBool(true))
  if valid_580523 != nil:
    section.add "prettyPrint", valid_580523
  var valid_580524 = query.getOrDefault("oauth_token")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "oauth_token", valid_580524
  var valid_580525 = query.getOrDefault("$.xgafv")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = newJString("1"))
  if valid_580525 != nil:
    section.add "$.xgafv", valid_580525
  var valid_580526 = query.getOrDefault("pageSize")
  valid_580526 = validateParameter(valid_580526, JInt, required = false, default = nil)
  if valid_580526 != nil:
    section.add "pageSize", valid_580526
  var valid_580527 = query.getOrDefault("alt")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = newJString("json"))
  if valid_580527 != nil:
    section.add "alt", valid_580527
  var valid_580528 = query.getOrDefault("uploadType")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "uploadType", valid_580528
  var valid_580529 = query.getOrDefault("quotaUser")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "quotaUser", valid_580529
  var valid_580530 = query.getOrDefault("filter")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "filter", valid_580530
  var valid_580531 = query.getOrDefault("pageToken")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "pageToken", valid_580531
  var valid_580532 = query.getOrDefault("callback")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "callback", valid_580532
  var valid_580533 = query.getOrDefault("fields")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "fields", valid_580533
  var valid_580534 = query.getOrDefault("access_token")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "access_token", valid_580534
  var valid_580535 = query.getOrDefault("upload_protocol")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "upload_protocol", valid_580535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580536: Call_RunProjectsLocationsList_580518; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580536.validator(path, query, header, formData, body)
  let scheme = call_580536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580536.url(scheme.get, call_580536.host, call_580536.base,
                         call_580536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580536, url, valid)

proc call*(call_580537: Call_RunProjectsLocationsList_580518; name: string;
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
  var path_580538 = newJObject()
  var query_580539 = newJObject()
  add(query_580539, "key", newJString(key))
  add(query_580539, "prettyPrint", newJBool(prettyPrint))
  add(query_580539, "oauth_token", newJString(oauthToken))
  add(query_580539, "$.xgafv", newJString(Xgafv))
  add(query_580539, "pageSize", newJInt(pageSize))
  add(query_580539, "alt", newJString(alt))
  add(query_580539, "uploadType", newJString(uploadType))
  add(query_580539, "quotaUser", newJString(quotaUser))
  add(path_580538, "name", newJString(name))
  add(query_580539, "filter", newJString(filter))
  add(query_580539, "pageToken", newJString(pageToken))
  add(query_580539, "callback", newJString(callback))
  add(query_580539, "fields", newJString(fields))
  add(query_580539, "access_token", newJString(accessToken))
  add(query_580539, "upload_protocol", newJString(uploadProtocol))
  result = call_580537.call(path_580538, query_580539, nil, nil, nil)

var runProjectsLocationsList* = Call_RunProjectsLocationsList_580518(
    name: "runProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{name}/locations",
    validator: validate_RunProjectsLocationsList_580519, base: "/",
    url: url_RunProjectsLocationsList_580520, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAuthorizeddomainsList_580540 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsAuthorizeddomainsList_580542(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
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

proc validate_RunProjectsLocationsAuthorizeddomainsList_580541(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## RPC to list authorized domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580543 = path.getOrDefault("parent")
  valid_580543 = validateParameter(valid_580543, JString, required = true,
                                 default = nil)
  if valid_580543 != nil:
    section.add "parent", valid_580543
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
  var valid_580544 = query.getOrDefault("key")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "key", valid_580544
  var valid_580545 = query.getOrDefault("prettyPrint")
  valid_580545 = validateParameter(valid_580545, JBool, required = false,
                                 default = newJBool(true))
  if valid_580545 != nil:
    section.add "prettyPrint", valid_580545
  var valid_580546 = query.getOrDefault("oauth_token")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "oauth_token", valid_580546
  var valid_580547 = query.getOrDefault("$.xgafv")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = newJString("1"))
  if valid_580547 != nil:
    section.add "$.xgafv", valid_580547
  var valid_580548 = query.getOrDefault("pageSize")
  valid_580548 = validateParameter(valid_580548, JInt, required = false, default = nil)
  if valid_580548 != nil:
    section.add "pageSize", valid_580548
  var valid_580549 = query.getOrDefault("alt")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = newJString("json"))
  if valid_580549 != nil:
    section.add "alt", valid_580549
  var valid_580550 = query.getOrDefault("uploadType")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "uploadType", valid_580550
  var valid_580551 = query.getOrDefault("quotaUser")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "quotaUser", valid_580551
  var valid_580552 = query.getOrDefault("pageToken")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "pageToken", valid_580552
  var valid_580553 = query.getOrDefault("callback")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "callback", valid_580553
  var valid_580554 = query.getOrDefault("fields")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "fields", valid_580554
  var valid_580555 = query.getOrDefault("access_token")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "access_token", valid_580555
  var valid_580556 = query.getOrDefault("upload_protocol")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "upload_protocol", valid_580556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580557: Call_RunProjectsLocationsAuthorizeddomainsList_580540;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RPC to list authorized domains.
  ## 
  let valid = call_580557.validator(path, query, header, formData, body)
  let scheme = call_580557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580557.url(scheme.get, call_580557.host, call_580557.base,
                         call_580557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580557, url, valid)

proc call*(call_580558: Call_RunProjectsLocationsAuthorizeddomainsList_580540;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsAuthorizeddomainsList
  ## RPC to list authorized domains.
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
  var path_580559 = newJObject()
  var query_580560 = newJObject()
  add(query_580560, "key", newJString(key))
  add(query_580560, "prettyPrint", newJBool(prettyPrint))
  add(query_580560, "oauth_token", newJString(oauthToken))
  add(query_580560, "$.xgafv", newJString(Xgafv))
  add(query_580560, "pageSize", newJInt(pageSize))
  add(query_580560, "alt", newJString(alt))
  add(query_580560, "uploadType", newJString(uploadType))
  add(query_580560, "quotaUser", newJString(quotaUser))
  add(query_580560, "pageToken", newJString(pageToken))
  add(query_580560, "callback", newJString(callback))
  add(path_580559, "parent", newJString(parent))
  add(query_580560, "fields", newJString(fields))
  add(query_580560, "access_token", newJString(accessToken))
  add(query_580560, "upload_protocol", newJString(uploadProtocol))
  result = call_580558.call(path_580559, query_580560, nil, nil, nil)

var runProjectsLocationsAuthorizeddomainsList* = Call_RunProjectsLocationsAuthorizeddomainsList_580540(
    name: "runProjectsLocationsAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/authorizeddomains",
    validator: validate_RunProjectsLocationsAuthorizeddomainsList_580541,
    base: "/", url: url_RunProjectsLocationsAuthorizeddomainsList_580542,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsList_580561 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsConfigurationsList_580563(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
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

proc validate_RunProjectsLocationsConfigurationsList_580562(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580564 = path.getOrDefault("parent")
  valid_580564 = validateParameter(valid_580564, JString, required = true,
                                 default = nil)
  if valid_580564 != nil:
    section.add "parent", valid_580564
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
  var valid_580565 = query.getOrDefault("key")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "key", valid_580565
  var valid_580566 = query.getOrDefault("includeUninitialized")
  valid_580566 = validateParameter(valid_580566, JBool, required = false, default = nil)
  if valid_580566 != nil:
    section.add "includeUninitialized", valid_580566
  var valid_580567 = query.getOrDefault("prettyPrint")
  valid_580567 = validateParameter(valid_580567, JBool, required = false,
                                 default = newJBool(true))
  if valid_580567 != nil:
    section.add "prettyPrint", valid_580567
  var valid_580568 = query.getOrDefault("oauth_token")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "oauth_token", valid_580568
  var valid_580569 = query.getOrDefault("fieldSelector")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "fieldSelector", valid_580569
  var valid_580570 = query.getOrDefault("labelSelector")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "labelSelector", valid_580570
  var valid_580571 = query.getOrDefault("$.xgafv")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = newJString("1"))
  if valid_580571 != nil:
    section.add "$.xgafv", valid_580571
  var valid_580572 = query.getOrDefault("limit")
  valid_580572 = validateParameter(valid_580572, JInt, required = false, default = nil)
  if valid_580572 != nil:
    section.add "limit", valid_580572
  var valid_580573 = query.getOrDefault("alt")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = newJString("json"))
  if valid_580573 != nil:
    section.add "alt", valid_580573
  var valid_580574 = query.getOrDefault("uploadType")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "uploadType", valid_580574
  var valid_580575 = query.getOrDefault("quotaUser")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = nil)
  if valid_580575 != nil:
    section.add "quotaUser", valid_580575
  var valid_580576 = query.getOrDefault("watch")
  valid_580576 = validateParameter(valid_580576, JBool, required = false, default = nil)
  if valid_580576 != nil:
    section.add "watch", valid_580576
  var valid_580577 = query.getOrDefault("callback")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "callback", valid_580577
  var valid_580578 = query.getOrDefault("resourceVersion")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "resourceVersion", valid_580578
  var valid_580579 = query.getOrDefault("fields")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "fields", valid_580579
  var valid_580580 = query.getOrDefault("access_token")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "access_token", valid_580580
  var valid_580581 = query.getOrDefault("upload_protocol")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "upload_protocol", valid_580581
  var valid_580582 = query.getOrDefault("continue")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "continue", valid_580582
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580583: Call_RunProjectsLocationsConfigurationsList_580561;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list configurations.
  ## 
  let valid = call_580583.validator(path, query, header, formData, body)
  let scheme = call_580583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580583.url(scheme.get, call_580583.host, call_580583.base,
                         call_580583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580583, url, valid)

proc call*(call_580584: Call_RunProjectsLocationsConfigurationsList_580561;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsConfigurationsList
  ## Rpc to list configurations.
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
  ##         : The project ID or project number from which the configurations should be
  ## listed.
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
  var path_580585 = newJObject()
  var query_580586 = newJObject()
  add(query_580586, "key", newJString(key))
  add(query_580586, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580586, "prettyPrint", newJBool(prettyPrint))
  add(query_580586, "oauth_token", newJString(oauthToken))
  add(query_580586, "fieldSelector", newJString(fieldSelector))
  add(query_580586, "labelSelector", newJString(labelSelector))
  add(query_580586, "$.xgafv", newJString(Xgafv))
  add(query_580586, "limit", newJInt(limit))
  add(query_580586, "alt", newJString(alt))
  add(query_580586, "uploadType", newJString(uploadType))
  add(query_580586, "quotaUser", newJString(quotaUser))
  add(query_580586, "watch", newJBool(watch))
  add(query_580586, "callback", newJString(callback))
  add(path_580585, "parent", newJString(parent))
  add(query_580586, "resourceVersion", newJString(resourceVersion))
  add(query_580586, "fields", newJString(fields))
  add(query_580586, "access_token", newJString(accessToken))
  add(query_580586, "upload_protocol", newJString(uploadProtocol))
  add(query_580586, "continue", newJString(`continue`))
  result = call_580584.call(path_580585, query_580586, nil, nil, nil)

var runProjectsLocationsConfigurationsList* = Call_RunProjectsLocationsConfigurationsList_580561(
    name: "runProjectsLocationsConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsList_580562, base: "/",
    url: url_RunProjectsLocationsConfigurationsList_580563,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsCreate_580613 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsDomainmappingsCreate_580615(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
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

proc validate_RunProjectsLocationsDomainmappingsCreate_580614(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580616 = path.getOrDefault("parent")
  valid_580616 = validateParameter(valid_580616, JString, required = true,
                                 default = nil)
  if valid_580616 != nil:
    section.add "parent", valid_580616
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
  var valid_580617 = query.getOrDefault("key")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "key", valid_580617
  var valid_580618 = query.getOrDefault("prettyPrint")
  valid_580618 = validateParameter(valid_580618, JBool, required = false,
                                 default = newJBool(true))
  if valid_580618 != nil:
    section.add "prettyPrint", valid_580618
  var valid_580619 = query.getOrDefault("oauth_token")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = nil)
  if valid_580619 != nil:
    section.add "oauth_token", valid_580619
  var valid_580620 = query.getOrDefault("$.xgafv")
  valid_580620 = validateParameter(valid_580620, JString, required = false,
                                 default = newJString("1"))
  if valid_580620 != nil:
    section.add "$.xgafv", valid_580620
  var valid_580621 = query.getOrDefault("alt")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = newJString("json"))
  if valid_580621 != nil:
    section.add "alt", valid_580621
  var valid_580622 = query.getOrDefault("uploadType")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "uploadType", valid_580622
  var valid_580623 = query.getOrDefault("quotaUser")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = nil)
  if valid_580623 != nil:
    section.add "quotaUser", valid_580623
  var valid_580624 = query.getOrDefault("callback")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "callback", valid_580624
  var valid_580625 = query.getOrDefault("fields")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = nil)
  if valid_580625 != nil:
    section.add "fields", valid_580625
  var valid_580626 = query.getOrDefault("access_token")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "access_token", valid_580626
  var valid_580627 = query.getOrDefault("upload_protocol")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "upload_protocol", valid_580627
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

proc call*(call_580629: Call_RunProjectsLocationsDomainmappingsCreate_580613;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new domain mapping.
  ## 
  let valid = call_580629.validator(path, query, header, formData, body)
  let scheme = call_580629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580629.url(scheme.get, call_580629.host, call_580629.base,
                         call_580629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580629, url, valid)

proc call*(call_580630: Call_RunProjectsLocationsDomainmappingsCreate_580613;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsCreate
  ## Creates a new domain mapping.
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
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580631 = newJObject()
  var query_580632 = newJObject()
  var body_580633 = newJObject()
  add(query_580632, "key", newJString(key))
  add(query_580632, "prettyPrint", newJBool(prettyPrint))
  add(query_580632, "oauth_token", newJString(oauthToken))
  add(query_580632, "$.xgafv", newJString(Xgafv))
  add(query_580632, "alt", newJString(alt))
  add(query_580632, "uploadType", newJString(uploadType))
  add(query_580632, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580633 = body
  add(query_580632, "callback", newJString(callback))
  add(path_580631, "parent", newJString(parent))
  add(query_580632, "fields", newJString(fields))
  add(query_580632, "access_token", newJString(accessToken))
  add(query_580632, "upload_protocol", newJString(uploadProtocol))
  result = call_580630.call(path_580631, query_580632, nil, nil, body_580633)

var runProjectsLocationsDomainmappingsCreate* = Call_RunProjectsLocationsDomainmappingsCreate_580613(
    name: "runProjectsLocationsDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsCreate_580614,
    base: "/", url: url_RunProjectsLocationsDomainmappingsCreate_580615,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsList_580587 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsDomainmappingsList_580589(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
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

proc validate_RunProjectsLocationsDomainmappingsList_580588(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580590 = path.getOrDefault("parent")
  valid_580590 = validateParameter(valid_580590, JString, required = true,
                                 default = nil)
  if valid_580590 != nil:
    section.add "parent", valid_580590
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
  var valid_580591 = query.getOrDefault("key")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "key", valid_580591
  var valid_580592 = query.getOrDefault("includeUninitialized")
  valid_580592 = validateParameter(valid_580592, JBool, required = false, default = nil)
  if valid_580592 != nil:
    section.add "includeUninitialized", valid_580592
  var valid_580593 = query.getOrDefault("prettyPrint")
  valid_580593 = validateParameter(valid_580593, JBool, required = false,
                                 default = newJBool(true))
  if valid_580593 != nil:
    section.add "prettyPrint", valid_580593
  var valid_580594 = query.getOrDefault("oauth_token")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "oauth_token", valid_580594
  var valid_580595 = query.getOrDefault("fieldSelector")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "fieldSelector", valid_580595
  var valid_580596 = query.getOrDefault("labelSelector")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "labelSelector", valid_580596
  var valid_580597 = query.getOrDefault("$.xgafv")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = newJString("1"))
  if valid_580597 != nil:
    section.add "$.xgafv", valid_580597
  var valid_580598 = query.getOrDefault("limit")
  valid_580598 = validateParameter(valid_580598, JInt, required = false, default = nil)
  if valid_580598 != nil:
    section.add "limit", valid_580598
  var valid_580599 = query.getOrDefault("alt")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = newJString("json"))
  if valid_580599 != nil:
    section.add "alt", valid_580599
  var valid_580600 = query.getOrDefault("uploadType")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "uploadType", valid_580600
  var valid_580601 = query.getOrDefault("quotaUser")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "quotaUser", valid_580601
  var valid_580602 = query.getOrDefault("watch")
  valid_580602 = validateParameter(valid_580602, JBool, required = false, default = nil)
  if valid_580602 != nil:
    section.add "watch", valid_580602
  var valid_580603 = query.getOrDefault("callback")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "callback", valid_580603
  var valid_580604 = query.getOrDefault("resourceVersion")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "resourceVersion", valid_580604
  var valid_580605 = query.getOrDefault("fields")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "fields", valid_580605
  var valid_580606 = query.getOrDefault("access_token")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "access_token", valid_580606
  var valid_580607 = query.getOrDefault("upload_protocol")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "upload_protocol", valid_580607
  var valid_580608 = query.getOrDefault("continue")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "continue", valid_580608
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580609: Call_RunProjectsLocationsDomainmappingsList_580587;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list domain mappings.
  ## 
  let valid = call_580609.validator(path, query, header, formData, body)
  let scheme = call_580609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580609.url(scheme.get, call_580609.host, call_580609.base,
                         call_580609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580609, url, valid)

proc call*(call_580610: Call_RunProjectsLocationsDomainmappingsList_580587;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsList
  ## Rpc to list domain mappings.
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
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
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
  var path_580611 = newJObject()
  var query_580612 = newJObject()
  add(query_580612, "key", newJString(key))
  add(query_580612, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580612, "prettyPrint", newJBool(prettyPrint))
  add(query_580612, "oauth_token", newJString(oauthToken))
  add(query_580612, "fieldSelector", newJString(fieldSelector))
  add(query_580612, "labelSelector", newJString(labelSelector))
  add(query_580612, "$.xgafv", newJString(Xgafv))
  add(query_580612, "limit", newJInt(limit))
  add(query_580612, "alt", newJString(alt))
  add(query_580612, "uploadType", newJString(uploadType))
  add(query_580612, "quotaUser", newJString(quotaUser))
  add(query_580612, "watch", newJBool(watch))
  add(query_580612, "callback", newJString(callback))
  add(path_580611, "parent", newJString(parent))
  add(query_580612, "resourceVersion", newJString(resourceVersion))
  add(query_580612, "fields", newJString(fields))
  add(query_580612, "access_token", newJString(accessToken))
  add(query_580612, "upload_protocol", newJString(uploadProtocol))
  add(query_580612, "continue", newJString(`continue`))
  result = call_580610.call(path_580611, query_580612, nil, nil, nil)

var runProjectsLocationsDomainmappingsList* = Call_RunProjectsLocationsDomainmappingsList_580587(
    name: "runProjectsLocationsDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsList_580588, base: "/",
    url: url_RunProjectsLocationsDomainmappingsList_580589,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsEventtypesList_580634 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsEventtypesList_580636(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/eventtypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsEventtypesList_580635(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list EventTypes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the EventTypes should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580637 = path.getOrDefault("parent")
  valid_580637 = validateParameter(valid_580637, JString, required = true,
                                 default = nil)
  if valid_580637 != nil:
    section.add "parent", valid_580637
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
  var valid_580638 = query.getOrDefault("key")
  valid_580638 = validateParameter(valid_580638, JString, required = false,
                                 default = nil)
  if valid_580638 != nil:
    section.add "key", valid_580638
  var valid_580639 = query.getOrDefault("includeUninitialized")
  valid_580639 = validateParameter(valid_580639, JBool, required = false, default = nil)
  if valid_580639 != nil:
    section.add "includeUninitialized", valid_580639
  var valid_580640 = query.getOrDefault("prettyPrint")
  valid_580640 = validateParameter(valid_580640, JBool, required = false,
                                 default = newJBool(true))
  if valid_580640 != nil:
    section.add "prettyPrint", valid_580640
  var valid_580641 = query.getOrDefault("oauth_token")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "oauth_token", valid_580641
  var valid_580642 = query.getOrDefault("fieldSelector")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "fieldSelector", valid_580642
  var valid_580643 = query.getOrDefault("labelSelector")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "labelSelector", valid_580643
  var valid_580644 = query.getOrDefault("$.xgafv")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = newJString("1"))
  if valid_580644 != nil:
    section.add "$.xgafv", valid_580644
  var valid_580645 = query.getOrDefault("limit")
  valid_580645 = validateParameter(valid_580645, JInt, required = false, default = nil)
  if valid_580645 != nil:
    section.add "limit", valid_580645
  var valid_580646 = query.getOrDefault("alt")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = newJString("json"))
  if valid_580646 != nil:
    section.add "alt", valid_580646
  var valid_580647 = query.getOrDefault("uploadType")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "uploadType", valid_580647
  var valid_580648 = query.getOrDefault("quotaUser")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "quotaUser", valid_580648
  var valid_580649 = query.getOrDefault("watch")
  valid_580649 = validateParameter(valid_580649, JBool, required = false, default = nil)
  if valid_580649 != nil:
    section.add "watch", valid_580649
  var valid_580650 = query.getOrDefault("callback")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = nil)
  if valid_580650 != nil:
    section.add "callback", valid_580650
  var valid_580651 = query.getOrDefault("resourceVersion")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "resourceVersion", valid_580651
  var valid_580652 = query.getOrDefault("fields")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "fields", valid_580652
  var valid_580653 = query.getOrDefault("access_token")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "access_token", valid_580653
  var valid_580654 = query.getOrDefault("upload_protocol")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "upload_protocol", valid_580654
  var valid_580655 = query.getOrDefault("continue")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "continue", valid_580655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580656: Call_RunProjectsLocationsEventtypesList_580634;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list EventTypes.
  ## 
  let valid = call_580656.validator(path, query, header, formData, body)
  let scheme = call_580656.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580656.url(scheme.get, call_580656.host, call_580656.base,
                         call_580656.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580656, url, valid)

proc call*(call_580657: Call_RunProjectsLocationsEventtypesList_580634;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsEventtypesList
  ## Rpc to list EventTypes.
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
  ##         : The project ID or project number from which the EventTypes should be
  ## listed.
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
  var path_580658 = newJObject()
  var query_580659 = newJObject()
  add(query_580659, "key", newJString(key))
  add(query_580659, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580659, "prettyPrint", newJBool(prettyPrint))
  add(query_580659, "oauth_token", newJString(oauthToken))
  add(query_580659, "fieldSelector", newJString(fieldSelector))
  add(query_580659, "labelSelector", newJString(labelSelector))
  add(query_580659, "$.xgafv", newJString(Xgafv))
  add(query_580659, "limit", newJInt(limit))
  add(query_580659, "alt", newJString(alt))
  add(query_580659, "uploadType", newJString(uploadType))
  add(query_580659, "quotaUser", newJString(quotaUser))
  add(query_580659, "watch", newJBool(watch))
  add(query_580659, "callback", newJString(callback))
  add(path_580658, "parent", newJString(parent))
  add(query_580659, "resourceVersion", newJString(resourceVersion))
  add(query_580659, "fields", newJString(fields))
  add(query_580659, "access_token", newJString(accessToken))
  add(query_580659, "upload_protocol", newJString(uploadProtocol))
  add(query_580659, "continue", newJString(`continue`))
  result = call_580657.call(path_580658, query_580659, nil, nil, nil)

var runProjectsLocationsEventtypesList* = Call_RunProjectsLocationsEventtypesList_580634(
    name: "runProjectsLocationsEventtypesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/eventtypes",
    validator: validate_RunProjectsLocationsEventtypesList_580635, base: "/",
    url: url_RunProjectsLocationsEventtypesList_580636, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsPubsubsCreate_580686 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsPubsubsCreate_580688(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/pubsubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsPubsubsCreate_580687(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new pubsub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this pubsub should
  ## be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580689 = path.getOrDefault("parent")
  valid_580689 = validateParameter(valid_580689, JString, required = true,
                                 default = nil)
  if valid_580689 != nil:
    section.add "parent", valid_580689
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
  var valid_580690 = query.getOrDefault("key")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = nil)
  if valid_580690 != nil:
    section.add "key", valid_580690
  var valid_580691 = query.getOrDefault("prettyPrint")
  valid_580691 = validateParameter(valid_580691, JBool, required = false,
                                 default = newJBool(true))
  if valid_580691 != nil:
    section.add "prettyPrint", valid_580691
  var valid_580692 = query.getOrDefault("oauth_token")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "oauth_token", valid_580692
  var valid_580693 = query.getOrDefault("$.xgafv")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = newJString("1"))
  if valid_580693 != nil:
    section.add "$.xgafv", valid_580693
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580702: Call_RunProjectsLocationsPubsubsCreate_580686;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new pubsub.
  ## 
  let valid = call_580702.validator(path, query, header, formData, body)
  let scheme = call_580702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580702.url(scheme.get, call_580702.host, call_580702.base,
                         call_580702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580702, url, valid)

proc call*(call_580703: Call_RunProjectsLocationsPubsubsCreate_580686;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsPubsubsCreate
  ## Creates a new pubsub.
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
  ##         : The project ID or project number in which this pubsub should
  ## be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580704 = newJObject()
  var query_580705 = newJObject()
  var body_580706 = newJObject()
  add(query_580705, "key", newJString(key))
  add(query_580705, "prettyPrint", newJBool(prettyPrint))
  add(query_580705, "oauth_token", newJString(oauthToken))
  add(query_580705, "$.xgafv", newJString(Xgafv))
  add(query_580705, "alt", newJString(alt))
  add(query_580705, "uploadType", newJString(uploadType))
  add(query_580705, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580706 = body
  add(query_580705, "callback", newJString(callback))
  add(path_580704, "parent", newJString(parent))
  add(query_580705, "fields", newJString(fields))
  add(query_580705, "access_token", newJString(accessToken))
  add(query_580705, "upload_protocol", newJString(uploadProtocol))
  result = call_580703.call(path_580704, query_580705, nil, nil, body_580706)

var runProjectsLocationsPubsubsCreate* = Call_RunProjectsLocationsPubsubsCreate_580686(
    name: "runProjectsLocationsPubsubsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/pubsubs",
    validator: validate_RunProjectsLocationsPubsubsCreate_580687, base: "/",
    url: url_RunProjectsLocationsPubsubsCreate_580688, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsPubsubsList_580660 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsPubsubsList_580662(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/pubsubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsPubsubsList_580661(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list pubsubs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the pubsubs should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580663 = path.getOrDefault("parent")
  valid_580663 = validateParameter(valid_580663, JString, required = true,
                                 default = nil)
  if valid_580663 != nil:
    section.add "parent", valid_580663
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
  var valid_580664 = query.getOrDefault("key")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "key", valid_580664
  var valid_580665 = query.getOrDefault("includeUninitialized")
  valid_580665 = validateParameter(valid_580665, JBool, required = false, default = nil)
  if valid_580665 != nil:
    section.add "includeUninitialized", valid_580665
  var valid_580666 = query.getOrDefault("prettyPrint")
  valid_580666 = validateParameter(valid_580666, JBool, required = false,
                                 default = newJBool(true))
  if valid_580666 != nil:
    section.add "prettyPrint", valid_580666
  var valid_580667 = query.getOrDefault("oauth_token")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "oauth_token", valid_580667
  var valid_580668 = query.getOrDefault("fieldSelector")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "fieldSelector", valid_580668
  var valid_580669 = query.getOrDefault("labelSelector")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "labelSelector", valid_580669
  var valid_580670 = query.getOrDefault("$.xgafv")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = newJString("1"))
  if valid_580670 != nil:
    section.add "$.xgafv", valid_580670
  var valid_580671 = query.getOrDefault("limit")
  valid_580671 = validateParameter(valid_580671, JInt, required = false, default = nil)
  if valid_580671 != nil:
    section.add "limit", valid_580671
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
  var valid_580675 = query.getOrDefault("watch")
  valid_580675 = validateParameter(valid_580675, JBool, required = false, default = nil)
  if valid_580675 != nil:
    section.add "watch", valid_580675
  var valid_580676 = query.getOrDefault("callback")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = nil)
  if valid_580676 != nil:
    section.add "callback", valid_580676
  var valid_580677 = query.getOrDefault("resourceVersion")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "resourceVersion", valid_580677
  var valid_580678 = query.getOrDefault("fields")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "fields", valid_580678
  var valid_580679 = query.getOrDefault("access_token")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = nil)
  if valid_580679 != nil:
    section.add "access_token", valid_580679
  var valid_580680 = query.getOrDefault("upload_protocol")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "upload_protocol", valid_580680
  var valid_580681 = query.getOrDefault("continue")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = nil)
  if valid_580681 != nil:
    section.add "continue", valid_580681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580682: Call_RunProjectsLocationsPubsubsList_580660;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list pubsubs.
  ## 
  let valid = call_580682.validator(path, query, header, formData, body)
  let scheme = call_580682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580682.url(scheme.get, call_580682.host, call_580682.base,
                         call_580682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580682, url, valid)

proc call*(call_580683: Call_RunProjectsLocationsPubsubsList_580660;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsPubsubsList
  ## Rpc to list pubsubs.
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
  ##         : The project ID or project number from which the pubsubs should
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
  var path_580684 = newJObject()
  var query_580685 = newJObject()
  add(query_580685, "key", newJString(key))
  add(query_580685, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580685, "prettyPrint", newJBool(prettyPrint))
  add(query_580685, "oauth_token", newJString(oauthToken))
  add(query_580685, "fieldSelector", newJString(fieldSelector))
  add(query_580685, "labelSelector", newJString(labelSelector))
  add(query_580685, "$.xgafv", newJString(Xgafv))
  add(query_580685, "limit", newJInt(limit))
  add(query_580685, "alt", newJString(alt))
  add(query_580685, "uploadType", newJString(uploadType))
  add(query_580685, "quotaUser", newJString(quotaUser))
  add(query_580685, "watch", newJBool(watch))
  add(query_580685, "callback", newJString(callback))
  add(path_580684, "parent", newJString(parent))
  add(query_580685, "resourceVersion", newJString(resourceVersion))
  add(query_580685, "fields", newJString(fields))
  add(query_580685, "access_token", newJString(accessToken))
  add(query_580685, "upload_protocol", newJString(uploadProtocol))
  add(query_580685, "continue", newJString(`continue`))
  result = call_580683.call(path_580684, query_580685, nil, nil, nil)

var runProjectsLocationsPubsubsList* = Call_RunProjectsLocationsPubsubsList_580660(
    name: "runProjectsLocationsPubsubsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/pubsubs",
    validator: validate_RunProjectsLocationsPubsubsList_580661, base: "/",
    url: url_RunProjectsLocationsPubsubsList_580662, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRevisionsList_580707 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsRevisionsList_580709(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
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

proc validate_RunProjectsLocationsRevisionsList_580708(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the revisions should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580710 = path.getOrDefault("parent")
  valid_580710 = validateParameter(valid_580710, JString, required = true,
                                 default = nil)
  if valid_580710 != nil:
    section.add "parent", valid_580710
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
  var valid_580711 = query.getOrDefault("key")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = nil)
  if valid_580711 != nil:
    section.add "key", valid_580711
  var valid_580712 = query.getOrDefault("includeUninitialized")
  valid_580712 = validateParameter(valid_580712, JBool, required = false, default = nil)
  if valid_580712 != nil:
    section.add "includeUninitialized", valid_580712
  var valid_580713 = query.getOrDefault("prettyPrint")
  valid_580713 = validateParameter(valid_580713, JBool, required = false,
                                 default = newJBool(true))
  if valid_580713 != nil:
    section.add "prettyPrint", valid_580713
  var valid_580714 = query.getOrDefault("oauth_token")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "oauth_token", valid_580714
  var valid_580715 = query.getOrDefault("fieldSelector")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "fieldSelector", valid_580715
  var valid_580716 = query.getOrDefault("labelSelector")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "labelSelector", valid_580716
  var valid_580717 = query.getOrDefault("$.xgafv")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = newJString("1"))
  if valid_580717 != nil:
    section.add "$.xgafv", valid_580717
  var valid_580718 = query.getOrDefault("limit")
  valid_580718 = validateParameter(valid_580718, JInt, required = false, default = nil)
  if valid_580718 != nil:
    section.add "limit", valid_580718
  var valid_580719 = query.getOrDefault("alt")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = newJString("json"))
  if valid_580719 != nil:
    section.add "alt", valid_580719
  var valid_580720 = query.getOrDefault("uploadType")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "uploadType", valid_580720
  var valid_580721 = query.getOrDefault("quotaUser")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "quotaUser", valid_580721
  var valid_580722 = query.getOrDefault("watch")
  valid_580722 = validateParameter(valid_580722, JBool, required = false, default = nil)
  if valid_580722 != nil:
    section.add "watch", valid_580722
  var valid_580723 = query.getOrDefault("callback")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = nil)
  if valid_580723 != nil:
    section.add "callback", valid_580723
  var valid_580724 = query.getOrDefault("resourceVersion")
  valid_580724 = validateParameter(valid_580724, JString, required = false,
                                 default = nil)
  if valid_580724 != nil:
    section.add "resourceVersion", valid_580724
  var valid_580725 = query.getOrDefault("fields")
  valid_580725 = validateParameter(valid_580725, JString, required = false,
                                 default = nil)
  if valid_580725 != nil:
    section.add "fields", valid_580725
  var valid_580726 = query.getOrDefault("access_token")
  valid_580726 = validateParameter(valid_580726, JString, required = false,
                                 default = nil)
  if valid_580726 != nil:
    section.add "access_token", valid_580726
  var valid_580727 = query.getOrDefault("upload_protocol")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = nil)
  if valid_580727 != nil:
    section.add "upload_protocol", valid_580727
  var valid_580728 = query.getOrDefault("continue")
  valid_580728 = validateParameter(valid_580728, JString, required = false,
                                 default = nil)
  if valid_580728 != nil:
    section.add "continue", valid_580728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580729: Call_RunProjectsLocationsRevisionsList_580707;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list revisions.
  ## 
  let valid = call_580729.validator(path, query, header, formData, body)
  let scheme = call_580729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580729.url(scheme.get, call_580729.host, call_580729.base,
                         call_580729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580729, url, valid)

proc call*(call_580730: Call_RunProjectsLocationsRevisionsList_580707;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsRevisionsList
  ## Rpc to list revisions.
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
  ##         : The project ID or project number from which the revisions should be listed.
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
  var path_580731 = newJObject()
  var query_580732 = newJObject()
  add(query_580732, "key", newJString(key))
  add(query_580732, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580732, "prettyPrint", newJBool(prettyPrint))
  add(query_580732, "oauth_token", newJString(oauthToken))
  add(query_580732, "fieldSelector", newJString(fieldSelector))
  add(query_580732, "labelSelector", newJString(labelSelector))
  add(query_580732, "$.xgafv", newJString(Xgafv))
  add(query_580732, "limit", newJInt(limit))
  add(query_580732, "alt", newJString(alt))
  add(query_580732, "uploadType", newJString(uploadType))
  add(query_580732, "quotaUser", newJString(quotaUser))
  add(query_580732, "watch", newJBool(watch))
  add(query_580732, "callback", newJString(callback))
  add(path_580731, "parent", newJString(parent))
  add(query_580732, "resourceVersion", newJString(resourceVersion))
  add(query_580732, "fields", newJString(fields))
  add(query_580732, "access_token", newJString(accessToken))
  add(query_580732, "upload_protocol", newJString(uploadProtocol))
  add(query_580732, "continue", newJString(`continue`))
  result = call_580730.call(path_580731, query_580732, nil, nil, nil)

var runProjectsLocationsRevisionsList* = Call_RunProjectsLocationsRevisionsList_580707(
    name: "runProjectsLocationsRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/revisions",
    validator: validate_RunProjectsLocationsRevisionsList_580708, base: "/",
    url: url_RunProjectsLocationsRevisionsList_580709, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesList_580733 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsRoutesList_580735(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
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

proc validate_RunProjectsLocationsRoutesList_580734(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list routes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the routes should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580736 = path.getOrDefault("parent")
  valid_580736 = validateParameter(valid_580736, JString, required = true,
                                 default = nil)
  if valid_580736 != nil:
    section.add "parent", valid_580736
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
  var valid_580737 = query.getOrDefault("key")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "key", valid_580737
  var valid_580738 = query.getOrDefault("includeUninitialized")
  valid_580738 = validateParameter(valid_580738, JBool, required = false, default = nil)
  if valid_580738 != nil:
    section.add "includeUninitialized", valid_580738
  var valid_580739 = query.getOrDefault("prettyPrint")
  valid_580739 = validateParameter(valid_580739, JBool, required = false,
                                 default = newJBool(true))
  if valid_580739 != nil:
    section.add "prettyPrint", valid_580739
  var valid_580740 = query.getOrDefault("oauth_token")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = nil)
  if valid_580740 != nil:
    section.add "oauth_token", valid_580740
  var valid_580741 = query.getOrDefault("fieldSelector")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "fieldSelector", valid_580741
  var valid_580742 = query.getOrDefault("labelSelector")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "labelSelector", valid_580742
  var valid_580743 = query.getOrDefault("$.xgafv")
  valid_580743 = validateParameter(valid_580743, JString, required = false,
                                 default = newJString("1"))
  if valid_580743 != nil:
    section.add "$.xgafv", valid_580743
  var valid_580744 = query.getOrDefault("limit")
  valid_580744 = validateParameter(valid_580744, JInt, required = false, default = nil)
  if valid_580744 != nil:
    section.add "limit", valid_580744
  var valid_580745 = query.getOrDefault("alt")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = newJString("json"))
  if valid_580745 != nil:
    section.add "alt", valid_580745
  var valid_580746 = query.getOrDefault("uploadType")
  valid_580746 = validateParameter(valid_580746, JString, required = false,
                                 default = nil)
  if valid_580746 != nil:
    section.add "uploadType", valid_580746
  var valid_580747 = query.getOrDefault("quotaUser")
  valid_580747 = validateParameter(valid_580747, JString, required = false,
                                 default = nil)
  if valid_580747 != nil:
    section.add "quotaUser", valid_580747
  var valid_580748 = query.getOrDefault("watch")
  valid_580748 = validateParameter(valid_580748, JBool, required = false, default = nil)
  if valid_580748 != nil:
    section.add "watch", valid_580748
  var valid_580749 = query.getOrDefault("callback")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "callback", valid_580749
  var valid_580750 = query.getOrDefault("resourceVersion")
  valid_580750 = validateParameter(valid_580750, JString, required = false,
                                 default = nil)
  if valid_580750 != nil:
    section.add "resourceVersion", valid_580750
  var valid_580751 = query.getOrDefault("fields")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "fields", valid_580751
  var valid_580752 = query.getOrDefault("access_token")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "access_token", valid_580752
  var valid_580753 = query.getOrDefault("upload_protocol")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "upload_protocol", valid_580753
  var valid_580754 = query.getOrDefault("continue")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "continue", valid_580754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580755: Call_RunProjectsLocationsRoutesList_580733; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list routes.
  ## 
  let valid = call_580755.validator(path, query, header, formData, body)
  let scheme = call_580755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580755.url(scheme.get, call_580755.host, call_580755.base,
                         call_580755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580755, url, valid)

proc call*(call_580756: Call_RunProjectsLocationsRoutesList_580733; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsRoutesList
  ## Rpc to list routes.
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
  ##         : The project ID or project number from which the routes should be listed.
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
  var path_580757 = newJObject()
  var query_580758 = newJObject()
  add(query_580758, "key", newJString(key))
  add(query_580758, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580758, "prettyPrint", newJBool(prettyPrint))
  add(query_580758, "oauth_token", newJString(oauthToken))
  add(query_580758, "fieldSelector", newJString(fieldSelector))
  add(query_580758, "labelSelector", newJString(labelSelector))
  add(query_580758, "$.xgafv", newJString(Xgafv))
  add(query_580758, "limit", newJInt(limit))
  add(query_580758, "alt", newJString(alt))
  add(query_580758, "uploadType", newJString(uploadType))
  add(query_580758, "quotaUser", newJString(quotaUser))
  add(query_580758, "watch", newJBool(watch))
  add(query_580758, "callback", newJString(callback))
  add(path_580757, "parent", newJString(parent))
  add(query_580758, "resourceVersion", newJString(resourceVersion))
  add(query_580758, "fields", newJString(fields))
  add(query_580758, "access_token", newJString(accessToken))
  add(query_580758, "upload_protocol", newJString(uploadProtocol))
  add(query_580758, "continue", newJString(`continue`))
  result = call_580756.call(path_580757, query_580758, nil, nil, nil)

var runProjectsLocationsRoutesList* = Call_RunProjectsLocationsRoutesList_580733(
    name: "runProjectsLocationsRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesList_580734, base: "/",
    url: url_RunProjectsLocationsRoutesList_580735, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesCreate_580785 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsServicesCreate_580787(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
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

proc validate_RunProjectsLocationsServicesCreate_580786(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to create a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this service should be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580788 = path.getOrDefault("parent")
  valid_580788 = validateParameter(valid_580788, JString, required = true,
                                 default = nil)
  if valid_580788 != nil:
    section.add "parent", valid_580788
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
  var valid_580789 = query.getOrDefault("key")
  valid_580789 = validateParameter(valid_580789, JString, required = false,
                                 default = nil)
  if valid_580789 != nil:
    section.add "key", valid_580789
  var valid_580790 = query.getOrDefault("prettyPrint")
  valid_580790 = validateParameter(valid_580790, JBool, required = false,
                                 default = newJBool(true))
  if valid_580790 != nil:
    section.add "prettyPrint", valid_580790
  var valid_580791 = query.getOrDefault("oauth_token")
  valid_580791 = validateParameter(valid_580791, JString, required = false,
                                 default = nil)
  if valid_580791 != nil:
    section.add "oauth_token", valid_580791
  var valid_580792 = query.getOrDefault("$.xgafv")
  valid_580792 = validateParameter(valid_580792, JString, required = false,
                                 default = newJString("1"))
  if valid_580792 != nil:
    section.add "$.xgafv", valid_580792
  var valid_580793 = query.getOrDefault("alt")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = newJString("json"))
  if valid_580793 != nil:
    section.add "alt", valid_580793
  var valid_580794 = query.getOrDefault("uploadType")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = nil)
  if valid_580794 != nil:
    section.add "uploadType", valid_580794
  var valid_580795 = query.getOrDefault("quotaUser")
  valid_580795 = validateParameter(valid_580795, JString, required = false,
                                 default = nil)
  if valid_580795 != nil:
    section.add "quotaUser", valid_580795
  var valid_580796 = query.getOrDefault("callback")
  valid_580796 = validateParameter(valid_580796, JString, required = false,
                                 default = nil)
  if valid_580796 != nil:
    section.add "callback", valid_580796
  var valid_580797 = query.getOrDefault("fields")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = nil)
  if valid_580797 != nil:
    section.add "fields", valid_580797
  var valid_580798 = query.getOrDefault("access_token")
  valid_580798 = validateParameter(valid_580798, JString, required = false,
                                 default = nil)
  if valid_580798 != nil:
    section.add "access_token", valid_580798
  var valid_580799 = query.getOrDefault("upload_protocol")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "upload_protocol", valid_580799
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

proc call*(call_580801: Call_RunProjectsLocationsServicesCreate_580785;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to create a service.
  ## 
  let valid = call_580801.validator(path, query, header, formData, body)
  let scheme = call_580801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580801.url(scheme.get, call_580801.host, call_580801.base,
                         call_580801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580801, url, valid)

proc call*(call_580802: Call_RunProjectsLocationsServicesCreate_580785;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesCreate
  ## Rpc to create a service.
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
  ##         : The project ID or project number in which this service should be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580803 = newJObject()
  var query_580804 = newJObject()
  var body_580805 = newJObject()
  add(query_580804, "key", newJString(key))
  add(query_580804, "prettyPrint", newJBool(prettyPrint))
  add(query_580804, "oauth_token", newJString(oauthToken))
  add(query_580804, "$.xgafv", newJString(Xgafv))
  add(query_580804, "alt", newJString(alt))
  add(query_580804, "uploadType", newJString(uploadType))
  add(query_580804, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580805 = body
  add(query_580804, "callback", newJString(callback))
  add(path_580803, "parent", newJString(parent))
  add(query_580804, "fields", newJString(fields))
  add(query_580804, "access_token", newJString(accessToken))
  add(query_580804, "upload_protocol", newJString(uploadProtocol))
  result = call_580802.call(path_580803, query_580804, nil, nil, body_580805)

var runProjectsLocationsServicesCreate* = Call_RunProjectsLocationsServicesCreate_580785(
    name: "runProjectsLocationsServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesCreate_580786, base: "/",
    url: url_RunProjectsLocationsServicesCreate_580787, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesList_580759 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsServicesList_580761(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
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

proc validate_RunProjectsLocationsServicesList_580760(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the services should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580762 = path.getOrDefault("parent")
  valid_580762 = validateParameter(valid_580762, JString, required = true,
                                 default = nil)
  if valid_580762 != nil:
    section.add "parent", valid_580762
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
  var valid_580763 = query.getOrDefault("key")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = nil)
  if valid_580763 != nil:
    section.add "key", valid_580763
  var valid_580764 = query.getOrDefault("includeUninitialized")
  valid_580764 = validateParameter(valid_580764, JBool, required = false, default = nil)
  if valid_580764 != nil:
    section.add "includeUninitialized", valid_580764
  var valid_580765 = query.getOrDefault("prettyPrint")
  valid_580765 = validateParameter(valid_580765, JBool, required = false,
                                 default = newJBool(true))
  if valid_580765 != nil:
    section.add "prettyPrint", valid_580765
  var valid_580766 = query.getOrDefault("oauth_token")
  valid_580766 = validateParameter(valid_580766, JString, required = false,
                                 default = nil)
  if valid_580766 != nil:
    section.add "oauth_token", valid_580766
  var valid_580767 = query.getOrDefault("fieldSelector")
  valid_580767 = validateParameter(valid_580767, JString, required = false,
                                 default = nil)
  if valid_580767 != nil:
    section.add "fieldSelector", valid_580767
  var valid_580768 = query.getOrDefault("labelSelector")
  valid_580768 = validateParameter(valid_580768, JString, required = false,
                                 default = nil)
  if valid_580768 != nil:
    section.add "labelSelector", valid_580768
  var valid_580769 = query.getOrDefault("$.xgafv")
  valid_580769 = validateParameter(valid_580769, JString, required = false,
                                 default = newJString("1"))
  if valid_580769 != nil:
    section.add "$.xgafv", valid_580769
  var valid_580770 = query.getOrDefault("limit")
  valid_580770 = validateParameter(valid_580770, JInt, required = false, default = nil)
  if valid_580770 != nil:
    section.add "limit", valid_580770
  var valid_580771 = query.getOrDefault("alt")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = newJString("json"))
  if valid_580771 != nil:
    section.add "alt", valid_580771
  var valid_580772 = query.getOrDefault("uploadType")
  valid_580772 = validateParameter(valid_580772, JString, required = false,
                                 default = nil)
  if valid_580772 != nil:
    section.add "uploadType", valid_580772
  var valid_580773 = query.getOrDefault("quotaUser")
  valid_580773 = validateParameter(valid_580773, JString, required = false,
                                 default = nil)
  if valid_580773 != nil:
    section.add "quotaUser", valid_580773
  var valid_580774 = query.getOrDefault("watch")
  valid_580774 = validateParameter(valid_580774, JBool, required = false, default = nil)
  if valid_580774 != nil:
    section.add "watch", valid_580774
  var valid_580775 = query.getOrDefault("callback")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "callback", valid_580775
  var valid_580776 = query.getOrDefault("resourceVersion")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = nil)
  if valid_580776 != nil:
    section.add "resourceVersion", valid_580776
  var valid_580777 = query.getOrDefault("fields")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "fields", valid_580777
  var valid_580778 = query.getOrDefault("access_token")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "access_token", valid_580778
  var valid_580779 = query.getOrDefault("upload_protocol")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "upload_protocol", valid_580779
  var valid_580780 = query.getOrDefault("continue")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = nil)
  if valid_580780 != nil:
    section.add "continue", valid_580780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580781: Call_RunProjectsLocationsServicesList_580759;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list services.
  ## 
  let valid = call_580781.validator(path, query, header, formData, body)
  let scheme = call_580781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580781.url(scheme.get, call_580781.host, call_580781.base,
                         call_580781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580781, url, valid)

proc call*(call_580782: Call_RunProjectsLocationsServicesList_580759;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsServicesList
  ## Rpc to list services.
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
  ##         : The project ID or project number from which the services should be listed.
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
  var path_580783 = newJObject()
  var query_580784 = newJObject()
  add(query_580784, "key", newJString(key))
  add(query_580784, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580784, "prettyPrint", newJBool(prettyPrint))
  add(query_580784, "oauth_token", newJString(oauthToken))
  add(query_580784, "fieldSelector", newJString(fieldSelector))
  add(query_580784, "labelSelector", newJString(labelSelector))
  add(query_580784, "$.xgafv", newJString(Xgafv))
  add(query_580784, "limit", newJInt(limit))
  add(query_580784, "alt", newJString(alt))
  add(query_580784, "uploadType", newJString(uploadType))
  add(query_580784, "quotaUser", newJString(quotaUser))
  add(query_580784, "watch", newJBool(watch))
  add(query_580784, "callback", newJString(callback))
  add(path_580783, "parent", newJString(parent))
  add(query_580784, "resourceVersion", newJString(resourceVersion))
  add(query_580784, "fields", newJString(fields))
  add(query_580784, "access_token", newJString(accessToken))
  add(query_580784, "upload_protocol", newJString(uploadProtocol))
  add(query_580784, "continue", newJString(`continue`))
  result = call_580782.call(path_580783, query_580784, nil, nil, nil)

var runProjectsLocationsServicesList* = Call_RunProjectsLocationsServicesList_580759(
    name: "runProjectsLocationsServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesList_580760, base: "/",
    url: url_RunProjectsLocationsServicesList_580761, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsTriggersCreate_580832 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsTriggersCreate_580834(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsTriggersCreate_580833(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this trigger should
  ## be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580835 = path.getOrDefault("parent")
  valid_580835 = validateParameter(valid_580835, JString, required = true,
                                 default = nil)
  if valid_580835 != nil:
    section.add "parent", valid_580835
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
  var valid_580836 = query.getOrDefault("key")
  valid_580836 = validateParameter(valid_580836, JString, required = false,
                                 default = nil)
  if valid_580836 != nil:
    section.add "key", valid_580836
  var valid_580837 = query.getOrDefault("prettyPrint")
  valid_580837 = validateParameter(valid_580837, JBool, required = false,
                                 default = newJBool(true))
  if valid_580837 != nil:
    section.add "prettyPrint", valid_580837
  var valid_580838 = query.getOrDefault("oauth_token")
  valid_580838 = validateParameter(valid_580838, JString, required = false,
                                 default = nil)
  if valid_580838 != nil:
    section.add "oauth_token", valid_580838
  var valid_580839 = query.getOrDefault("$.xgafv")
  valid_580839 = validateParameter(valid_580839, JString, required = false,
                                 default = newJString("1"))
  if valid_580839 != nil:
    section.add "$.xgafv", valid_580839
  var valid_580840 = query.getOrDefault("alt")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = newJString("json"))
  if valid_580840 != nil:
    section.add "alt", valid_580840
  var valid_580841 = query.getOrDefault("uploadType")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = nil)
  if valid_580841 != nil:
    section.add "uploadType", valid_580841
  var valid_580842 = query.getOrDefault("quotaUser")
  valid_580842 = validateParameter(valid_580842, JString, required = false,
                                 default = nil)
  if valid_580842 != nil:
    section.add "quotaUser", valid_580842
  var valid_580843 = query.getOrDefault("callback")
  valid_580843 = validateParameter(valid_580843, JString, required = false,
                                 default = nil)
  if valid_580843 != nil:
    section.add "callback", valid_580843
  var valid_580844 = query.getOrDefault("fields")
  valid_580844 = validateParameter(valid_580844, JString, required = false,
                                 default = nil)
  if valid_580844 != nil:
    section.add "fields", valid_580844
  var valid_580845 = query.getOrDefault("access_token")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "access_token", valid_580845
  var valid_580846 = query.getOrDefault("upload_protocol")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = nil)
  if valid_580846 != nil:
    section.add "upload_protocol", valid_580846
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

proc call*(call_580848: Call_RunProjectsLocationsTriggersCreate_580832;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new trigger.
  ## 
  let valid = call_580848.validator(path, query, header, formData, body)
  let scheme = call_580848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580848.url(scheme.get, call_580848.host, call_580848.base,
                         call_580848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580848, url, valid)

proc call*(call_580849: Call_RunProjectsLocationsTriggersCreate_580832;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsTriggersCreate
  ## Creates a new trigger.
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
  ##         : The project ID or project number in which this trigger should
  ## be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580850 = newJObject()
  var query_580851 = newJObject()
  var body_580852 = newJObject()
  add(query_580851, "key", newJString(key))
  add(query_580851, "prettyPrint", newJBool(prettyPrint))
  add(query_580851, "oauth_token", newJString(oauthToken))
  add(query_580851, "$.xgafv", newJString(Xgafv))
  add(query_580851, "alt", newJString(alt))
  add(query_580851, "uploadType", newJString(uploadType))
  add(query_580851, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580852 = body
  add(query_580851, "callback", newJString(callback))
  add(path_580850, "parent", newJString(parent))
  add(query_580851, "fields", newJString(fields))
  add(query_580851, "access_token", newJString(accessToken))
  add(query_580851, "upload_protocol", newJString(uploadProtocol))
  result = call_580849.call(path_580850, query_580851, nil, nil, body_580852)

var runProjectsLocationsTriggersCreate* = Call_RunProjectsLocationsTriggersCreate_580832(
    name: "runProjectsLocationsTriggersCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/triggers",
    validator: validate_RunProjectsLocationsTriggersCreate_580833, base: "/",
    url: url_RunProjectsLocationsTriggersCreate_580834, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsTriggersList_580806 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsTriggersList_580808(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsTriggersList_580807(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list triggers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the triggers should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580809 = path.getOrDefault("parent")
  valid_580809 = validateParameter(valid_580809, JString, required = true,
                                 default = nil)
  if valid_580809 != nil:
    section.add "parent", valid_580809
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
  var valid_580810 = query.getOrDefault("key")
  valid_580810 = validateParameter(valid_580810, JString, required = false,
                                 default = nil)
  if valid_580810 != nil:
    section.add "key", valid_580810
  var valid_580811 = query.getOrDefault("includeUninitialized")
  valid_580811 = validateParameter(valid_580811, JBool, required = false, default = nil)
  if valid_580811 != nil:
    section.add "includeUninitialized", valid_580811
  var valid_580812 = query.getOrDefault("prettyPrint")
  valid_580812 = validateParameter(valid_580812, JBool, required = false,
                                 default = newJBool(true))
  if valid_580812 != nil:
    section.add "prettyPrint", valid_580812
  var valid_580813 = query.getOrDefault("oauth_token")
  valid_580813 = validateParameter(valid_580813, JString, required = false,
                                 default = nil)
  if valid_580813 != nil:
    section.add "oauth_token", valid_580813
  var valid_580814 = query.getOrDefault("fieldSelector")
  valid_580814 = validateParameter(valid_580814, JString, required = false,
                                 default = nil)
  if valid_580814 != nil:
    section.add "fieldSelector", valid_580814
  var valid_580815 = query.getOrDefault("labelSelector")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = nil)
  if valid_580815 != nil:
    section.add "labelSelector", valid_580815
  var valid_580816 = query.getOrDefault("$.xgafv")
  valid_580816 = validateParameter(valid_580816, JString, required = false,
                                 default = newJString("1"))
  if valid_580816 != nil:
    section.add "$.xgafv", valid_580816
  var valid_580817 = query.getOrDefault("limit")
  valid_580817 = validateParameter(valid_580817, JInt, required = false, default = nil)
  if valid_580817 != nil:
    section.add "limit", valid_580817
  var valid_580818 = query.getOrDefault("alt")
  valid_580818 = validateParameter(valid_580818, JString, required = false,
                                 default = newJString("json"))
  if valid_580818 != nil:
    section.add "alt", valid_580818
  var valid_580819 = query.getOrDefault("uploadType")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "uploadType", valid_580819
  var valid_580820 = query.getOrDefault("quotaUser")
  valid_580820 = validateParameter(valid_580820, JString, required = false,
                                 default = nil)
  if valid_580820 != nil:
    section.add "quotaUser", valid_580820
  var valid_580821 = query.getOrDefault("watch")
  valid_580821 = validateParameter(valid_580821, JBool, required = false, default = nil)
  if valid_580821 != nil:
    section.add "watch", valid_580821
  var valid_580822 = query.getOrDefault("callback")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = nil)
  if valid_580822 != nil:
    section.add "callback", valid_580822
  var valid_580823 = query.getOrDefault("resourceVersion")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "resourceVersion", valid_580823
  var valid_580824 = query.getOrDefault("fields")
  valid_580824 = validateParameter(valid_580824, JString, required = false,
                                 default = nil)
  if valid_580824 != nil:
    section.add "fields", valid_580824
  var valid_580825 = query.getOrDefault("access_token")
  valid_580825 = validateParameter(valid_580825, JString, required = false,
                                 default = nil)
  if valid_580825 != nil:
    section.add "access_token", valid_580825
  var valid_580826 = query.getOrDefault("upload_protocol")
  valid_580826 = validateParameter(valid_580826, JString, required = false,
                                 default = nil)
  if valid_580826 != nil:
    section.add "upload_protocol", valid_580826
  var valid_580827 = query.getOrDefault("continue")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "continue", valid_580827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580828: Call_RunProjectsLocationsTriggersList_580806;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list triggers.
  ## 
  let valid = call_580828.validator(path, query, header, formData, body)
  let scheme = call_580828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580828.url(scheme.get, call_580828.host, call_580828.base,
                         call_580828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580828, url, valid)

proc call*(call_580829: Call_RunProjectsLocationsTriggersList_580806;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsTriggersList
  ## Rpc to list triggers.
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
  ##         : The project ID or project number from which the triggers should
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
  var path_580830 = newJObject()
  var query_580831 = newJObject()
  add(query_580831, "key", newJString(key))
  add(query_580831, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580831, "prettyPrint", newJBool(prettyPrint))
  add(query_580831, "oauth_token", newJString(oauthToken))
  add(query_580831, "fieldSelector", newJString(fieldSelector))
  add(query_580831, "labelSelector", newJString(labelSelector))
  add(query_580831, "$.xgafv", newJString(Xgafv))
  add(query_580831, "limit", newJInt(limit))
  add(query_580831, "alt", newJString(alt))
  add(query_580831, "uploadType", newJString(uploadType))
  add(query_580831, "quotaUser", newJString(quotaUser))
  add(query_580831, "watch", newJBool(watch))
  add(query_580831, "callback", newJString(callback))
  add(path_580830, "parent", newJString(parent))
  add(query_580831, "resourceVersion", newJString(resourceVersion))
  add(query_580831, "fields", newJString(fields))
  add(query_580831, "access_token", newJString(accessToken))
  add(query_580831, "upload_protocol", newJString(uploadProtocol))
  add(query_580831, "continue", newJString(`continue`))
  result = call_580829.call(path_580830, query_580831, nil, nil, nil)

var runProjectsLocationsTriggersList* = Call_RunProjectsLocationsTriggersList_580806(
    name: "runProjectsLocationsTriggersList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/triggers",
    validator: validate_RunProjectsLocationsTriggersList_580807, base: "/",
    url: url_RunProjectsLocationsTriggersList_580808, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesGetIamPolicy_580853 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsServicesGetIamPolicy_580855(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesGetIamPolicy_580854(path: JsonNode;
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
  var valid_580856 = path.getOrDefault("resource")
  valid_580856 = validateParameter(valid_580856, JString, required = true,
                                 default = nil)
  if valid_580856 != nil:
    section.add "resource", valid_580856
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
  var valid_580857 = query.getOrDefault("key")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = nil)
  if valid_580857 != nil:
    section.add "key", valid_580857
  var valid_580858 = query.getOrDefault("prettyPrint")
  valid_580858 = validateParameter(valid_580858, JBool, required = false,
                                 default = newJBool(true))
  if valid_580858 != nil:
    section.add "prettyPrint", valid_580858
  var valid_580859 = query.getOrDefault("oauth_token")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = nil)
  if valid_580859 != nil:
    section.add "oauth_token", valid_580859
  var valid_580860 = query.getOrDefault("$.xgafv")
  valid_580860 = validateParameter(valid_580860, JString, required = false,
                                 default = newJString("1"))
  if valid_580860 != nil:
    section.add "$.xgafv", valid_580860
  var valid_580861 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580861 = validateParameter(valid_580861, JInt, required = false, default = nil)
  if valid_580861 != nil:
    section.add "options.requestedPolicyVersion", valid_580861
  var valid_580862 = query.getOrDefault("alt")
  valid_580862 = validateParameter(valid_580862, JString, required = false,
                                 default = newJString("json"))
  if valid_580862 != nil:
    section.add "alt", valid_580862
  var valid_580863 = query.getOrDefault("uploadType")
  valid_580863 = validateParameter(valid_580863, JString, required = false,
                                 default = nil)
  if valid_580863 != nil:
    section.add "uploadType", valid_580863
  var valid_580864 = query.getOrDefault("quotaUser")
  valid_580864 = validateParameter(valid_580864, JString, required = false,
                                 default = nil)
  if valid_580864 != nil:
    section.add "quotaUser", valid_580864
  var valid_580865 = query.getOrDefault("callback")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = nil)
  if valid_580865 != nil:
    section.add "callback", valid_580865
  var valid_580866 = query.getOrDefault("fields")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = nil)
  if valid_580866 != nil:
    section.add "fields", valid_580866
  var valid_580867 = query.getOrDefault("access_token")
  valid_580867 = validateParameter(valid_580867, JString, required = false,
                                 default = nil)
  if valid_580867 != nil:
    section.add "access_token", valid_580867
  var valid_580868 = query.getOrDefault("upload_protocol")
  valid_580868 = validateParameter(valid_580868, JString, required = false,
                                 default = nil)
  if valid_580868 != nil:
    section.add "upload_protocol", valid_580868
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580869: Call_RunProjectsLocationsServicesGetIamPolicy_580853;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  let valid = call_580869.validator(path, query, header, formData, body)
  let scheme = call_580869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580869.url(scheme.get, call_580869.host, call_580869.base,
                         call_580869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580869, url, valid)

proc call*(call_580870: Call_RunProjectsLocationsServicesGetIamPolicy_580853;
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
  var path_580871 = newJObject()
  var query_580872 = newJObject()
  add(query_580872, "key", newJString(key))
  add(query_580872, "prettyPrint", newJBool(prettyPrint))
  add(query_580872, "oauth_token", newJString(oauthToken))
  add(query_580872, "$.xgafv", newJString(Xgafv))
  add(query_580872, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580872, "alt", newJString(alt))
  add(query_580872, "uploadType", newJString(uploadType))
  add(query_580872, "quotaUser", newJString(quotaUser))
  add(path_580871, "resource", newJString(resource))
  add(query_580872, "callback", newJString(callback))
  add(query_580872, "fields", newJString(fields))
  add(query_580872, "access_token", newJString(accessToken))
  add(query_580872, "upload_protocol", newJString(uploadProtocol))
  result = call_580870.call(path_580871, query_580872, nil, nil, nil)

var runProjectsLocationsServicesGetIamPolicy* = Call_RunProjectsLocationsServicesGetIamPolicy_580853(
    name: "runProjectsLocationsServicesGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_RunProjectsLocationsServicesGetIamPolicy_580854,
    base: "/", url: url_RunProjectsLocationsServicesGetIamPolicy_580855,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesSetIamPolicy_580873 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsServicesSetIamPolicy_580875(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesSetIamPolicy_580874(path: JsonNode;
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
  var valid_580876 = path.getOrDefault("resource")
  valid_580876 = validateParameter(valid_580876, JString, required = true,
                                 default = nil)
  if valid_580876 != nil:
    section.add "resource", valid_580876
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
  var valid_580877 = query.getOrDefault("key")
  valid_580877 = validateParameter(valid_580877, JString, required = false,
                                 default = nil)
  if valid_580877 != nil:
    section.add "key", valid_580877
  var valid_580878 = query.getOrDefault("prettyPrint")
  valid_580878 = validateParameter(valid_580878, JBool, required = false,
                                 default = newJBool(true))
  if valid_580878 != nil:
    section.add "prettyPrint", valid_580878
  var valid_580879 = query.getOrDefault("oauth_token")
  valid_580879 = validateParameter(valid_580879, JString, required = false,
                                 default = nil)
  if valid_580879 != nil:
    section.add "oauth_token", valid_580879
  var valid_580880 = query.getOrDefault("$.xgafv")
  valid_580880 = validateParameter(valid_580880, JString, required = false,
                                 default = newJString("1"))
  if valid_580880 != nil:
    section.add "$.xgafv", valid_580880
  var valid_580881 = query.getOrDefault("alt")
  valid_580881 = validateParameter(valid_580881, JString, required = false,
                                 default = newJString("json"))
  if valid_580881 != nil:
    section.add "alt", valid_580881
  var valid_580882 = query.getOrDefault("uploadType")
  valid_580882 = validateParameter(valid_580882, JString, required = false,
                                 default = nil)
  if valid_580882 != nil:
    section.add "uploadType", valid_580882
  var valid_580883 = query.getOrDefault("quotaUser")
  valid_580883 = validateParameter(valid_580883, JString, required = false,
                                 default = nil)
  if valid_580883 != nil:
    section.add "quotaUser", valid_580883
  var valid_580884 = query.getOrDefault("callback")
  valid_580884 = validateParameter(valid_580884, JString, required = false,
                                 default = nil)
  if valid_580884 != nil:
    section.add "callback", valid_580884
  var valid_580885 = query.getOrDefault("fields")
  valid_580885 = validateParameter(valid_580885, JString, required = false,
                                 default = nil)
  if valid_580885 != nil:
    section.add "fields", valid_580885
  var valid_580886 = query.getOrDefault("access_token")
  valid_580886 = validateParameter(valid_580886, JString, required = false,
                                 default = nil)
  if valid_580886 != nil:
    section.add "access_token", valid_580886
  var valid_580887 = query.getOrDefault("upload_protocol")
  valid_580887 = validateParameter(valid_580887, JString, required = false,
                                 default = nil)
  if valid_580887 != nil:
    section.add "upload_protocol", valid_580887
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

proc call*(call_580889: Call_RunProjectsLocationsServicesSetIamPolicy_580873;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  let valid = call_580889.validator(path, query, header, formData, body)
  let scheme = call_580889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580889.url(scheme.get, call_580889.host, call_580889.base,
                         call_580889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580889, url, valid)

proc call*(call_580890: Call_RunProjectsLocationsServicesSetIamPolicy_580873;
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
  var path_580891 = newJObject()
  var query_580892 = newJObject()
  var body_580893 = newJObject()
  add(query_580892, "key", newJString(key))
  add(query_580892, "prettyPrint", newJBool(prettyPrint))
  add(query_580892, "oauth_token", newJString(oauthToken))
  add(query_580892, "$.xgafv", newJString(Xgafv))
  add(query_580892, "alt", newJString(alt))
  add(query_580892, "uploadType", newJString(uploadType))
  add(query_580892, "quotaUser", newJString(quotaUser))
  add(path_580891, "resource", newJString(resource))
  if body != nil:
    body_580893 = body
  add(query_580892, "callback", newJString(callback))
  add(query_580892, "fields", newJString(fields))
  add(query_580892, "access_token", newJString(accessToken))
  add(query_580892, "upload_protocol", newJString(uploadProtocol))
  result = call_580890.call(path_580891, query_580892, nil, nil, body_580893)

var runProjectsLocationsServicesSetIamPolicy* = Call_RunProjectsLocationsServicesSetIamPolicy_580873(
    name: "runProjectsLocationsServicesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_RunProjectsLocationsServicesSetIamPolicy_580874,
    base: "/", url: url_RunProjectsLocationsServicesSetIamPolicy_580875,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesTestIamPermissions_580894 = ref object of OpenApiRestCall_579373
proc url_RunProjectsLocationsServicesTestIamPermissions_580896(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesTestIamPermissions_580895(
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
  var valid_580897 = path.getOrDefault("resource")
  valid_580897 = validateParameter(valid_580897, JString, required = true,
                                 default = nil)
  if valid_580897 != nil:
    section.add "resource", valid_580897
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
  var valid_580898 = query.getOrDefault("key")
  valid_580898 = validateParameter(valid_580898, JString, required = false,
                                 default = nil)
  if valid_580898 != nil:
    section.add "key", valid_580898
  var valid_580899 = query.getOrDefault("prettyPrint")
  valid_580899 = validateParameter(valid_580899, JBool, required = false,
                                 default = newJBool(true))
  if valid_580899 != nil:
    section.add "prettyPrint", valid_580899
  var valid_580900 = query.getOrDefault("oauth_token")
  valid_580900 = validateParameter(valid_580900, JString, required = false,
                                 default = nil)
  if valid_580900 != nil:
    section.add "oauth_token", valid_580900
  var valid_580901 = query.getOrDefault("$.xgafv")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = newJString("1"))
  if valid_580901 != nil:
    section.add "$.xgafv", valid_580901
  var valid_580902 = query.getOrDefault("alt")
  valid_580902 = validateParameter(valid_580902, JString, required = false,
                                 default = newJString("json"))
  if valid_580902 != nil:
    section.add "alt", valid_580902
  var valid_580903 = query.getOrDefault("uploadType")
  valid_580903 = validateParameter(valid_580903, JString, required = false,
                                 default = nil)
  if valid_580903 != nil:
    section.add "uploadType", valid_580903
  var valid_580904 = query.getOrDefault("quotaUser")
  valid_580904 = validateParameter(valid_580904, JString, required = false,
                                 default = nil)
  if valid_580904 != nil:
    section.add "quotaUser", valid_580904
  var valid_580905 = query.getOrDefault("callback")
  valid_580905 = validateParameter(valid_580905, JString, required = false,
                                 default = nil)
  if valid_580905 != nil:
    section.add "callback", valid_580905
  var valid_580906 = query.getOrDefault("fields")
  valid_580906 = validateParameter(valid_580906, JString, required = false,
                                 default = nil)
  if valid_580906 != nil:
    section.add "fields", valid_580906
  var valid_580907 = query.getOrDefault("access_token")
  valid_580907 = validateParameter(valid_580907, JString, required = false,
                                 default = nil)
  if valid_580907 != nil:
    section.add "access_token", valid_580907
  var valid_580908 = query.getOrDefault("upload_protocol")
  valid_580908 = validateParameter(valid_580908, JString, required = false,
                                 default = nil)
  if valid_580908 != nil:
    section.add "upload_protocol", valid_580908
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

proc call*(call_580910: Call_RunProjectsLocationsServicesTestIamPermissions_580894;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_580910.validator(path, query, header, formData, body)
  let scheme = call_580910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580910.url(scheme.get, call_580910.host, call_580910.base,
                         call_580910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580910, url, valid)

proc call*(call_580911: Call_RunProjectsLocationsServicesTestIamPermissions_580894;
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
  var path_580912 = newJObject()
  var query_580913 = newJObject()
  var body_580914 = newJObject()
  add(query_580913, "key", newJString(key))
  add(query_580913, "prettyPrint", newJBool(prettyPrint))
  add(query_580913, "oauth_token", newJString(oauthToken))
  add(query_580913, "$.xgafv", newJString(Xgafv))
  add(query_580913, "alt", newJString(alt))
  add(query_580913, "uploadType", newJString(uploadType))
  add(query_580913, "quotaUser", newJString(quotaUser))
  add(path_580912, "resource", newJString(resource))
  if body != nil:
    body_580914 = body
  add(query_580913, "callback", newJString(callback))
  add(query_580913, "fields", newJString(fields))
  add(query_580913, "access_token", newJString(accessToken))
  add(query_580913, "upload_protocol", newJString(uploadProtocol))
  result = call_580911.call(path_580912, query_580913, nil, nil, body_580914)

var runProjectsLocationsServicesTestIamPermissions* = Call_RunProjectsLocationsServicesTestIamPermissions_580894(
    name: "runProjectsLocationsServicesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_RunProjectsLocationsServicesTestIamPermissions_580895,
    base: "/", url: url_RunProjectsLocationsServicesTestIamPermissions_580896,
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
