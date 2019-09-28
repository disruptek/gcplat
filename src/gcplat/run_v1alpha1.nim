
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "run"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RunNamespacesDomainmappingsGet_579690 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesDomainmappingsGet_579692(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsGet_579691(path: JsonNode;
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

proc call*(call_579865: Call_RunNamespacesDomainmappingsGet_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a domain mapping.
  ## 
  let valid = call_579865.validator(path, query, header, formData, body)
  let scheme = call_579865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579865.url(scheme.get, call_579865.host, call_579865.base,
                         call_579865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579865, url, valid)

proc call*(call_579936: Call_RunNamespacesDomainmappingsGet_579690; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runNamespacesDomainmappingsGet
  ## Rpc to get information about a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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

var runNamespacesDomainmappingsGet* = Call_RunNamespacesDomainmappingsGet_579690(
    name: "runNamespacesDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{name}",
    validator: validate_RunNamespacesDomainmappingsGet_579691, base: "/",
    url: url_RunNamespacesDomainmappingsGet_579692, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsDelete_579978 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesDomainmappingsDelete_579980(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsDelete_579979(path: JsonNode;
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
  ##   orphanDependents: JBool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
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
  ##       : Cloud Run currently ignores this parameter.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
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
  var valid_579984 = query.getOrDefault("orphanDependents")
  valid_579984 = validateParameter(valid_579984, JBool, required = false, default = nil)
  if valid_579984 != nil:
    section.add "orphanDependents", valid_579984
  var valid_579985 = query.getOrDefault("quotaUser")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "quotaUser", valid_579985
  var valid_579986 = query.getOrDefault("alt")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = newJString("json"))
  if valid_579986 != nil:
    section.add "alt", valid_579986
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
  var valid_579991 = query.getOrDefault("kind")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "kind", valid_579991
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
  var valid_579995 = query.getOrDefault("propagationPolicy")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "propagationPolicy", valid_579995
  var valid_579996 = query.getOrDefault("apiVersion")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "apiVersion", valid_579996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579997: Call_RunNamespacesDomainmappingsDelete_579978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to delete a domain mapping.
  ## 
  let valid = call_579997.validator(path, query, header, formData, body)
  let scheme = call_579997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579997.url(scheme.get, call_579997.host, call_579997.base,
                         call_579997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579997, url, valid)

proc call*(call_579998: Call_RunNamespacesDomainmappingsDelete_579978;
          name: string; uploadProtocol: string = ""; fields: string = "";
          orphanDependents: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runNamespacesDomainmappingsDelete
  ## Rpc to delete a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orphanDependents: bool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  var path_579999 = newJObject()
  var query_580000 = newJObject()
  add(query_580000, "upload_protocol", newJString(uploadProtocol))
  add(query_580000, "fields", newJString(fields))
  add(query_580000, "orphanDependents", newJBool(orphanDependents))
  add(query_580000, "quotaUser", newJString(quotaUser))
  add(path_579999, "name", newJString(name))
  add(query_580000, "alt", newJString(alt))
  add(query_580000, "oauth_token", newJString(oauthToken))
  add(query_580000, "callback", newJString(callback))
  add(query_580000, "access_token", newJString(accessToken))
  add(query_580000, "uploadType", newJString(uploadType))
  add(query_580000, "kind", newJString(kind))
  add(query_580000, "key", newJString(key))
  add(query_580000, "$.xgafv", newJString(Xgafv))
  add(query_580000, "prettyPrint", newJBool(prettyPrint))
  add(query_580000, "propagationPolicy", newJString(propagationPolicy))
  add(query_580000, "apiVersion", newJString(apiVersion))
  result = call_579998.call(path_579999, query_580000, nil, nil, nil)

var runNamespacesDomainmappingsDelete* = Call_RunNamespacesDomainmappingsDelete_579978(
    name: "runNamespacesDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{name}",
    validator: validate_RunNamespacesDomainmappingsDelete_579979, base: "/",
    url: url_RunNamespacesDomainmappingsDelete_579980, schemes: {Scheme.Https})
type
  Call_RunNamespacesAuthorizeddomainsList_580001 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesAuthorizeddomainsList_580003(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesAuthorizeddomainsList_580002(path: JsonNode;
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
  var valid_580004 = path.getOrDefault("parent")
  valid_580004 = validateParameter(valid_580004, JString, required = true,
                                 default = nil)
  if valid_580004 != nil:
    section.add "parent", valid_580004
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
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
  ##           : Maximum results to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580005 = query.getOrDefault("upload_protocol")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "upload_protocol", valid_580005
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
  var valid_580007 = query.getOrDefault("pageToken")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "pageToken", valid_580007
  var valid_580008 = query.getOrDefault("quotaUser")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "quotaUser", valid_580008
  var valid_580009 = query.getOrDefault("alt")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("json"))
  if valid_580009 != nil:
    section.add "alt", valid_580009
  var valid_580010 = query.getOrDefault("oauth_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "oauth_token", valid_580010
  var valid_580011 = query.getOrDefault("callback")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "callback", valid_580011
  var valid_580012 = query.getOrDefault("access_token")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "access_token", valid_580012
  var valid_580013 = query.getOrDefault("uploadType")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "uploadType", valid_580013
  var valid_580014 = query.getOrDefault("key")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "key", valid_580014
  var valid_580015 = query.getOrDefault("$.xgafv")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("1"))
  if valid_580015 != nil:
    section.add "$.xgafv", valid_580015
  var valid_580016 = query.getOrDefault("pageSize")
  valid_580016 = validateParameter(valid_580016, JInt, required = false, default = nil)
  if valid_580016 != nil:
    section.add "pageSize", valid_580016
  var valid_580017 = query.getOrDefault("prettyPrint")
  valid_580017 = validateParameter(valid_580017, JBool, required = false,
                                 default = newJBool(true))
  if valid_580017 != nil:
    section.add "prettyPrint", valid_580017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580018: Call_RunNamespacesAuthorizeddomainsList_580001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RPC to list authorized domains.
  ## 
  let valid = call_580018.validator(path, query, header, formData, body)
  let scheme = call_580018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580018.url(scheme.get, call_580018.host, call_580018.base,
                         call_580018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580018, url, valid)

proc call*(call_580019: Call_RunNamespacesAuthorizeddomainsList_580001;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesAuthorizeddomainsList
  ## RPC to list authorized domains.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
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
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580020 = newJObject()
  var query_580021 = newJObject()
  add(query_580021, "upload_protocol", newJString(uploadProtocol))
  add(query_580021, "fields", newJString(fields))
  add(query_580021, "pageToken", newJString(pageToken))
  add(query_580021, "quotaUser", newJString(quotaUser))
  add(query_580021, "alt", newJString(alt))
  add(query_580021, "oauth_token", newJString(oauthToken))
  add(query_580021, "callback", newJString(callback))
  add(query_580021, "access_token", newJString(accessToken))
  add(query_580021, "uploadType", newJString(uploadType))
  add(path_580020, "parent", newJString(parent))
  add(query_580021, "key", newJString(key))
  add(query_580021, "$.xgafv", newJString(Xgafv))
  add(query_580021, "pageSize", newJInt(pageSize))
  add(query_580021, "prettyPrint", newJBool(prettyPrint))
  result = call_580019.call(path_580020, query_580021, nil, nil, nil)

var runNamespacesAuthorizeddomainsList* = Call_RunNamespacesAuthorizeddomainsList_580001(
    name: "runNamespacesAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/authorizeddomains",
    validator: validate_RunNamespacesAuthorizeddomainsList_580002, base: "/",
    url: url_RunNamespacesAuthorizeddomainsList_580003, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsCreate_580048 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesDomainmappingsCreate_580050(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsCreate_580049(path: JsonNode;
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
  var valid_580051 = path.getOrDefault("parent")
  valid_580051 = validateParameter(valid_580051, JString, required = true,
                                 default = nil)
  if valid_580051 != nil:
    section.add "parent", valid_580051
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
  var valid_580052 = query.getOrDefault("upload_protocol")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "upload_protocol", valid_580052
  var valid_580053 = query.getOrDefault("fields")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "fields", valid_580053
  var valid_580054 = query.getOrDefault("quotaUser")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "quotaUser", valid_580054
  var valid_580055 = query.getOrDefault("alt")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("json"))
  if valid_580055 != nil:
    section.add "alt", valid_580055
  var valid_580056 = query.getOrDefault("oauth_token")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "oauth_token", valid_580056
  var valid_580057 = query.getOrDefault("callback")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "callback", valid_580057
  var valid_580058 = query.getOrDefault("access_token")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "access_token", valid_580058
  var valid_580059 = query.getOrDefault("uploadType")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "uploadType", valid_580059
  var valid_580060 = query.getOrDefault("key")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "key", valid_580060
  var valid_580061 = query.getOrDefault("$.xgafv")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("1"))
  if valid_580061 != nil:
    section.add "$.xgafv", valid_580061
  var valid_580062 = query.getOrDefault("prettyPrint")
  valid_580062 = validateParameter(valid_580062, JBool, required = false,
                                 default = newJBool(true))
  if valid_580062 != nil:
    section.add "prettyPrint", valid_580062
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

proc call*(call_580064: Call_RunNamespacesDomainmappingsCreate_580048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new domain mapping.
  ## 
  let valid = call_580064.validator(path, query, header, formData, body)
  let scheme = call_580064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580064.url(scheme.get, call_580064.host, call_580064.base,
                         call_580064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580064, url, valid)

proc call*(call_580065: Call_RunNamespacesDomainmappingsCreate_580048;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesDomainmappingsCreate
  ## Creates a new domain mapping.
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
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580066 = newJObject()
  var query_580067 = newJObject()
  var body_580068 = newJObject()
  add(query_580067, "upload_protocol", newJString(uploadProtocol))
  add(query_580067, "fields", newJString(fields))
  add(query_580067, "quotaUser", newJString(quotaUser))
  add(query_580067, "alt", newJString(alt))
  add(query_580067, "oauth_token", newJString(oauthToken))
  add(query_580067, "callback", newJString(callback))
  add(query_580067, "access_token", newJString(accessToken))
  add(query_580067, "uploadType", newJString(uploadType))
  add(path_580066, "parent", newJString(parent))
  add(query_580067, "key", newJString(key))
  add(query_580067, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580068 = body
  add(query_580067, "prettyPrint", newJBool(prettyPrint))
  result = call_580065.call(path_580066, query_580067, nil, nil, body_580068)

var runNamespacesDomainmappingsCreate* = Call_RunNamespacesDomainmappingsCreate_580048(
    name: "runNamespacesDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsCreate_580049, base: "/",
    url: url_RunNamespacesDomainmappingsCreate_580050, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsList_580022 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesDomainmappingsList_580024(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsList_580023(path: JsonNode;
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
  var valid_580025 = path.getOrDefault("parent")
  valid_580025 = validateParameter(valid_580025, JString, required = true,
                                 default = nil)
  if valid_580025 != nil:
    section.add "parent", valid_580025
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580026 = query.getOrDefault("upload_protocol")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "upload_protocol", valid_580026
  var valid_580027 = query.getOrDefault("fields")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "fields", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  var valid_580029 = query.getOrDefault("includeUninitialized")
  valid_580029 = validateParameter(valid_580029, JBool, required = false, default = nil)
  if valid_580029 != nil:
    section.add "includeUninitialized", valid_580029
  var valid_580030 = query.getOrDefault("alt")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("json"))
  if valid_580030 != nil:
    section.add "alt", valid_580030
  var valid_580031 = query.getOrDefault("continue")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "continue", valid_580031
  var valid_580032 = query.getOrDefault("oauth_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "oauth_token", valid_580032
  var valid_580033 = query.getOrDefault("callback")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "callback", valid_580033
  var valid_580034 = query.getOrDefault("access_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "access_token", valid_580034
  var valid_580035 = query.getOrDefault("uploadType")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "uploadType", valid_580035
  var valid_580036 = query.getOrDefault("resourceVersion")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "resourceVersion", valid_580036
  var valid_580037 = query.getOrDefault("watch")
  valid_580037 = validateParameter(valid_580037, JBool, required = false, default = nil)
  if valid_580037 != nil:
    section.add "watch", valid_580037
  var valid_580038 = query.getOrDefault("key")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "key", valid_580038
  var valid_580039 = query.getOrDefault("$.xgafv")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("1"))
  if valid_580039 != nil:
    section.add "$.xgafv", valid_580039
  var valid_580040 = query.getOrDefault("labelSelector")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "labelSelector", valid_580040
  var valid_580041 = query.getOrDefault("prettyPrint")
  valid_580041 = validateParameter(valid_580041, JBool, required = false,
                                 default = newJBool(true))
  if valid_580041 != nil:
    section.add "prettyPrint", valid_580041
  var valid_580042 = query.getOrDefault("fieldSelector")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "fieldSelector", valid_580042
  var valid_580043 = query.getOrDefault("limit")
  valid_580043 = validateParameter(valid_580043, JInt, required = false, default = nil)
  if valid_580043 != nil:
    section.add "limit", valid_580043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580044: Call_RunNamespacesDomainmappingsList_580022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list domain mappings.
  ## 
  let valid = call_580044.validator(path, query, header, formData, body)
  let scheme = call_580044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580044.url(scheme.get, call_580044.host, call_580044.base,
                         call_580044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580044, url, valid)

proc call*(call_580045: Call_RunNamespacesDomainmappingsList_580022;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesDomainmappingsList
  ## Rpc to list domain mappings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580046 = newJObject()
  var query_580047 = newJObject()
  add(query_580047, "upload_protocol", newJString(uploadProtocol))
  add(query_580047, "fields", newJString(fields))
  add(query_580047, "quotaUser", newJString(quotaUser))
  add(query_580047, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580047, "alt", newJString(alt))
  add(query_580047, "continue", newJString(`continue`))
  add(query_580047, "oauth_token", newJString(oauthToken))
  add(query_580047, "callback", newJString(callback))
  add(query_580047, "access_token", newJString(accessToken))
  add(query_580047, "uploadType", newJString(uploadType))
  add(path_580046, "parent", newJString(parent))
  add(query_580047, "resourceVersion", newJString(resourceVersion))
  add(query_580047, "watch", newJBool(watch))
  add(query_580047, "key", newJString(key))
  add(query_580047, "$.xgafv", newJString(Xgafv))
  add(query_580047, "labelSelector", newJString(labelSelector))
  add(query_580047, "prettyPrint", newJBool(prettyPrint))
  add(query_580047, "fieldSelector", newJString(fieldSelector))
  add(query_580047, "limit", newJInt(limit))
  result = call_580045.call(path_580046, query_580047, nil, nil, nil)

var runNamespacesDomainmappingsList* = Call_RunNamespacesDomainmappingsList_580022(
    name: "runNamespacesDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsList_580023, base: "/",
    url: url_RunNamespacesDomainmappingsList_580024, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersReplaceTrigger_580088 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesTriggersReplaceTrigger_580090(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesTriggersReplaceTrigger_580089(path: JsonNode;
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
  var valid_580091 = path.getOrDefault("name")
  valid_580091 = validateParameter(valid_580091, JString, required = true,
                                 default = nil)
  if valid_580091 != nil:
    section.add "name", valid_580091
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
  var valid_580092 = query.getOrDefault("upload_protocol")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "upload_protocol", valid_580092
  var valid_580093 = query.getOrDefault("fields")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "fields", valid_580093
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
  var valid_580101 = query.getOrDefault("$.xgafv")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = newJString("1"))
  if valid_580101 != nil:
    section.add "$.xgafv", valid_580101
  var valid_580102 = query.getOrDefault("prettyPrint")
  valid_580102 = validateParameter(valid_580102, JBool, required = false,
                                 default = newJBool(true))
  if valid_580102 != nil:
    section.add "prettyPrint", valid_580102
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

proc call*(call_580104: Call_RunNamespacesTriggersReplaceTrigger_580088;
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
  let valid = call_580104.validator(path, query, header, formData, body)
  let scheme = call_580104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580104.url(scheme.get, call_580104.host, call_580104.base,
                         call_580104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580104, url, valid)

proc call*(call_580105: Call_RunNamespacesTriggersReplaceTrigger_580088;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesTriggersReplaceTrigger
  ## Rpc to replace a trigger.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the trigger being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_580106 = newJObject()
  var query_580107 = newJObject()
  var body_580108 = newJObject()
  add(query_580107, "upload_protocol", newJString(uploadProtocol))
  add(query_580107, "fields", newJString(fields))
  add(query_580107, "quotaUser", newJString(quotaUser))
  add(path_580106, "name", newJString(name))
  add(query_580107, "alt", newJString(alt))
  add(query_580107, "oauth_token", newJString(oauthToken))
  add(query_580107, "callback", newJString(callback))
  add(query_580107, "access_token", newJString(accessToken))
  add(query_580107, "uploadType", newJString(uploadType))
  add(query_580107, "key", newJString(key))
  add(query_580107, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580108 = body
  add(query_580107, "prettyPrint", newJBool(prettyPrint))
  result = call_580105.call(path_580106, query_580107, nil, nil, body_580108)

var runNamespacesTriggersReplaceTrigger* = Call_RunNamespacesTriggersReplaceTrigger_580088(
    name: "runNamespacesTriggersReplaceTrigger", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersReplaceTrigger_580089, base: "/",
    url: url_RunNamespacesTriggersReplaceTrigger_580090, schemes: {Scheme.Https})
type
  Call_RunNamespacesEventtypesGet_580069 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesEventtypesGet_580071(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesEventtypesGet_580070(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to get information about an EventType.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the trigger being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580072 = path.getOrDefault("name")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "name", valid_580072
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
  var valid_580073 = query.getOrDefault("upload_protocol")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "upload_protocol", valid_580073
  var valid_580074 = query.getOrDefault("fields")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "fields", valid_580074
  var valid_580075 = query.getOrDefault("quotaUser")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "quotaUser", valid_580075
  var valid_580076 = query.getOrDefault("alt")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("json"))
  if valid_580076 != nil:
    section.add "alt", valid_580076
  var valid_580077 = query.getOrDefault("oauth_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "oauth_token", valid_580077
  var valid_580078 = query.getOrDefault("callback")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "callback", valid_580078
  var valid_580079 = query.getOrDefault("access_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "access_token", valid_580079
  var valid_580080 = query.getOrDefault("uploadType")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "uploadType", valid_580080
  var valid_580081 = query.getOrDefault("key")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "key", valid_580081
  var valid_580082 = query.getOrDefault("$.xgafv")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("1"))
  if valid_580082 != nil:
    section.add "$.xgafv", valid_580082
  var valid_580083 = query.getOrDefault("prettyPrint")
  valid_580083 = validateParameter(valid_580083, JBool, required = false,
                                 default = newJBool(true))
  if valid_580083 != nil:
    section.add "prettyPrint", valid_580083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580084: Call_RunNamespacesEventtypesGet_580069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about an EventType.
  ## 
  let valid = call_580084.validator(path, query, header, formData, body)
  let scheme = call_580084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580084.url(scheme.get, call_580084.host, call_580084.base,
                         call_580084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580084, url, valid)

proc call*(call_580085: Call_RunNamespacesEventtypesGet_580069; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runNamespacesEventtypesGet
  ## Rpc to get information about an EventType.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the trigger being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_580086 = newJObject()
  var query_580087 = newJObject()
  add(query_580087, "upload_protocol", newJString(uploadProtocol))
  add(query_580087, "fields", newJString(fields))
  add(query_580087, "quotaUser", newJString(quotaUser))
  add(path_580086, "name", newJString(name))
  add(query_580087, "alt", newJString(alt))
  add(query_580087, "oauth_token", newJString(oauthToken))
  add(query_580087, "callback", newJString(callback))
  add(query_580087, "access_token", newJString(accessToken))
  add(query_580087, "uploadType", newJString(uploadType))
  add(query_580087, "key", newJString(key))
  add(query_580087, "$.xgafv", newJString(Xgafv))
  add(query_580087, "prettyPrint", newJBool(prettyPrint))
  result = call_580085.call(path_580086, query_580087, nil, nil, nil)

var runNamespacesEventtypesGet* = Call_RunNamespacesEventtypesGet_580069(
    name: "runNamespacesEventtypesGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesEventtypesGet_580070, base: "/",
    url: url_RunNamespacesEventtypesGet_580071, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersDelete_580109 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesTriggersDelete_580111(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesTriggersDelete_580110(path: JsonNode; query: JsonNode;
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
  var valid_580112 = path.getOrDefault("name")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "name", valid_580112
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
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  section = newJObject()
  var valid_580113 = query.getOrDefault("upload_protocol")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "upload_protocol", valid_580113
  var valid_580114 = query.getOrDefault("fields")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "fields", valid_580114
  var valid_580115 = query.getOrDefault("quotaUser")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "quotaUser", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("oauth_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "oauth_token", valid_580117
  var valid_580118 = query.getOrDefault("callback")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "callback", valid_580118
  var valid_580119 = query.getOrDefault("access_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "access_token", valid_580119
  var valid_580120 = query.getOrDefault("uploadType")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "uploadType", valid_580120
  var valid_580121 = query.getOrDefault("kind")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "kind", valid_580121
  var valid_580122 = query.getOrDefault("key")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "key", valid_580122
  var valid_580123 = query.getOrDefault("$.xgafv")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = newJString("1"))
  if valid_580123 != nil:
    section.add "$.xgafv", valid_580123
  var valid_580124 = query.getOrDefault("prettyPrint")
  valid_580124 = validateParameter(valid_580124, JBool, required = false,
                                 default = newJBool(true))
  if valid_580124 != nil:
    section.add "prettyPrint", valid_580124
  var valid_580125 = query.getOrDefault("propagationPolicy")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "propagationPolicy", valid_580125
  var valid_580126 = query.getOrDefault("apiVersion")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "apiVersion", valid_580126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580127: Call_RunNamespacesTriggersDelete_580109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to delete a trigger.
  ## 
  let valid = call_580127.validator(path, query, header, formData, body)
  let scheme = call_580127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580127.url(scheme.get, call_580127.host, call_580127.base,
                         call_580127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580127, url, valid)

proc call*(call_580128: Call_RunNamespacesTriggersDelete_580109; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; kind: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          propagationPolicy: string = ""; apiVersion: string = ""): Recallable =
  ## runNamespacesTriggersDelete
  ## Rpc to delete a trigger.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the trigger being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  var path_580129 = newJObject()
  var query_580130 = newJObject()
  add(query_580130, "upload_protocol", newJString(uploadProtocol))
  add(query_580130, "fields", newJString(fields))
  add(query_580130, "quotaUser", newJString(quotaUser))
  add(path_580129, "name", newJString(name))
  add(query_580130, "alt", newJString(alt))
  add(query_580130, "oauth_token", newJString(oauthToken))
  add(query_580130, "callback", newJString(callback))
  add(query_580130, "access_token", newJString(accessToken))
  add(query_580130, "uploadType", newJString(uploadType))
  add(query_580130, "kind", newJString(kind))
  add(query_580130, "key", newJString(key))
  add(query_580130, "$.xgafv", newJString(Xgafv))
  add(query_580130, "prettyPrint", newJBool(prettyPrint))
  add(query_580130, "propagationPolicy", newJString(propagationPolicy))
  add(query_580130, "apiVersion", newJString(apiVersion))
  result = call_580128.call(path_580129, query_580130, nil, nil, nil)

var runNamespacesTriggersDelete* = Call_RunNamespacesTriggersDelete_580109(
    name: "runNamespacesTriggersDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersDelete_580110, base: "/",
    url: url_RunNamespacesTriggersDelete_580111, schemes: {Scheme.Https})
type
  Call_RunNamespacesEventtypesList_580131 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesEventtypesList_580133(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesEventtypesList_580132(path: JsonNode; query: JsonNode;
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
  var valid_580134 = path.getOrDefault("parent")
  valid_580134 = validateParameter(valid_580134, JString, required = true,
                                 default = nil)
  if valid_580134 != nil:
    section.add "parent", valid_580134
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580135 = query.getOrDefault("upload_protocol")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "upload_protocol", valid_580135
  var valid_580136 = query.getOrDefault("fields")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "fields", valid_580136
  var valid_580137 = query.getOrDefault("quotaUser")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "quotaUser", valid_580137
  var valid_580138 = query.getOrDefault("includeUninitialized")
  valid_580138 = validateParameter(valid_580138, JBool, required = false, default = nil)
  if valid_580138 != nil:
    section.add "includeUninitialized", valid_580138
  var valid_580139 = query.getOrDefault("alt")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = newJString("json"))
  if valid_580139 != nil:
    section.add "alt", valid_580139
  var valid_580140 = query.getOrDefault("continue")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "continue", valid_580140
  var valid_580141 = query.getOrDefault("oauth_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "oauth_token", valid_580141
  var valid_580142 = query.getOrDefault("callback")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "callback", valid_580142
  var valid_580143 = query.getOrDefault("access_token")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "access_token", valid_580143
  var valid_580144 = query.getOrDefault("uploadType")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "uploadType", valid_580144
  var valid_580145 = query.getOrDefault("resourceVersion")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "resourceVersion", valid_580145
  var valid_580146 = query.getOrDefault("watch")
  valid_580146 = validateParameter(valid_580146, JBool, required = false, default = nil)
  if valid_580146 != nil:
    section.add "watch", valid_580146
  var valid_580147 = query.getOrDefault("key")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "key", valid_580147
  var valid_580148 = query.getOrDefault("$.xgafv")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("1"))
  if valid_580148 != nil:
    section.add "$.xgafv", valid_580148
  var valid_580149 = query.getOrDefault("labelSelector")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "labelSelector", valid_580149
  var valid_580150 = query.getOrDefault("prettyPrint")
  valid_580150 = validateParameter(valid_580150, JBool, required = false,
                                 default = newJBool(true))
  if valid_580150 != nil:
    section.add "prettyPrint", valid_580150
  var valid_580151 = query.getOrDefault("fieldSelector")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "fieldSelector", valid_580151
  var valid_580152 = query.getOrDefault("limit")
  valid_580152 = validateParameter(valid_580152, JInt, required = false, default = nil)
  if valid_580152 != nil:
    section.add "limit", valid_580152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580153: Call_RunNamespacesEventtypesList_580131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list EventTypes.
  ## 
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_RunNamespacesEventtypesList_580131; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesEventtypesList
  ## Rpc to list EventTypes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the EventTypes should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580155 = newJObject()
  var query_580156 = newJObject()
  add(query_580156, "upload_protocol", newJString(uploadProtocol))
  add(query_580156, "fields", newJString(fields))
  add(query_580156, "quotaUser", newJString(quotaUser))
  add(query_580156, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580156, "alt", newJString(alt))
  add(query_580156, "continue", newJString(`continue`))
  add(query_580156, "oauth_token", newJString(oauthToken))
  add(query_580156, "callback", newJString(callback))
  add(query_580156, "access_token", newJString(accessToken))
  add(query_580156, "uploadType", newJString(uploadType))
  add(path_580155, "parent", newJString(parent))
  add(query_580156, "resourceVersion", newJString(resourceVersion))
  add(query_580156, "watch", newJBool(watch))
  add(query_580156, "key", newJString(key))
  add(query_580156, "$.xgafv", newJString(Xgafv))
  add(query_580156, "labelSelector", newJString(labelSelector))
  add(query_580156, "prettyPrint", newJBool(prettyPrint))
  add(query_580156, "fieldSelector", newJString(fieldSelector))
  add(query_580156, "limit", newJInt(limit))
  result = call_580154.call(path_580155, query_580156, nil, nil, nil)

var runNamespacesEventtypesList* = Call_RunNamespacesEventtypesList_580131(
    name: "runNamespacesEventtypesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/eventtypes",
    validator: validate_RunNamespacesEventtypesList_580132, base: "/",
    url: url_RunNamespacesEventtypesList_580133, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersCreate_580183 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesTriggersCreate_580185(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesTriggersCreate_580184(path: JsonNode; query: JsonNode;
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
  var valid_580186 = path.getOrDefault("parent")
  valid_580186 = validateParameter(valid_580186, JString, required = true,
                                 default = nil)
  if valid_580186 != nil:
    section.add "parent", valid_580186
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
  var valid_580187 = query.getOrDefault("upload_protocol")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "upload_protocol", valid_580187
  var valid_580188 = query.getOrDefault("fields")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "fields", valid_580188
  var valid_580189 = query.getOrDefault("quotaUser")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "quotaUser", valid_580189
  var valid_580190 = query.getOrDefault("alt")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = newJString("json"))
  if valid_580190 != nil:
    section.add "alt", valid_580190
  var valid_580191 = query.getOrDefault("oauth_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "oauth_token", valid_580191
  var valid_580192 = query.getOrDefault("callback")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "callback", valid_580192
  var valid_580193 = query.getOrDefault("access_token")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "access_token", valid_580193
  var valid_580194 = query.getOrDefault("uploadType")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "uploadType", valid_580194
  var valid_580195 = query.getOrDefault("key")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "key", valid_580195
  var valid_580196 = query.getOrDefault("$.xgafv")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = newJString("1"))
  if valid_580196 != nil:
    section.add "$.xgafv", valid_580196
  var valid_580197 = query.getOrDefault("prettyPrint")
  valid_580197 = validateParameter(valid_580197, JBool, required = false,
                                 default = newJBool(true))
  if valid_580197 != nil:
    section.add "prettyPrint", valid_580197
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

proc call*(call_580199: Call_RunNamespacesTriggersCreate_580183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new trigger.
  ## 
  let valid = call_580199.validator(path, query, header, formData, body)
  let scheme = call_580199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580199.url(scheme.get, call_580199.host, call_580199.base,
                         call_580199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580199, url, valid)

proc call*(call_580200: Call_RunNamespacesTriggersCreate_580183; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## runNamespacesTriggersCreate
  ## Creates a new trigger.
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
  ##         : The project ID or project number in which this trigger should
  ## be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580201 = newJObject()
  var query_580202 = newJObject()
  var body_580203 = newJObject()
  add(query_580202, "upload_protocol", newJString(uploadProtocol))
  add(query_580202, "fields", newJString(fields))
  add(query_580202, "quotaUser", newJString(quotaUser))
  add(query_580202, "alt", newJString(alt))
  add(query_580202, "oauth_token", newJString(oauthToken))
  add(query_580202, "callback", newJString(callback))
  add(query_580202, "access_token", newJString(accessToken))
  add(query_580202, "uploadType", newJString(uploadType))
  add(path_580201, "parent", newJString(parent))
  add(query_580202, "key", newJString(key))
  add(query_580202, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580203 = body
  add(query_580202, "prettyPrint", newJBool(prettyPrint))
  result = call_580200.call(path_580201, query_580202, nil, nil, body_580203)

var runNamespacesTriggersCreate* = Call_RunNamespacesTriggersCreate_580183(
    name: "runNamespacesTriggersCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/triggers",
    validator: validate_RunNamespacesTriggersCreate_580184, base: "/",
    url: url_RunNamespacesTriggersCreate_580185, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersList_580157 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesTriggersList_580159(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesTriggersList_580158(path: JsonNode; query: JsonNode;
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
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
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
  var valid_580164 = query.getOrDefault("includeUninitialized")
  valid_580164 = validateParameter(valid_580164, JBool, required = false, default = nil)
  if valid_580164 != nil:
    section.add "includeUninitialized", valid_580164
  var valid_580165 = query.getOrDefault("alt")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = newJString("json"))
  if valid_580165 != nil:
    section.add "alt", valid_580165
  var valid_580166 = query.getOrDefault("continue")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "continue", valid_580166
  var valid_580167 = query.getOrDefault("oauth_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "oauth_token", valid_580167
  var valid_580168 = query.getOrDefault("callback")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "callback", valid_580168
  var valid_580169 = query.getOrDefault("access_token")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "access_token", valid_580169
  var valid_580170 = query.getOrDefault("uploadType")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "uploadType", valid_580170
  var valid_580171 = query.getOrDefault("resourceVersion")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "resourceVersion", valid_580171
  var valid_580172 = query.getOrDefault("watch")
  valid_580172 = validateParameter(valid_580172, JBool, required = false, default = nil)
  if valid_580172 != nil:
    section.add "watch", valid_580172
  var valid_580173 = query.getOrDefault("key")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "key", valid_580173
  var valid_580174 = query.getOrDefault("$.xgafv")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = newJString("1"))
  if valid_580174 != nil:
    section.add "$.xgafv", valid_580174
  var valid_580175 = query.getOrDefault("labelSelector")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "labelSelector", valid_580175
  var valid_580176 = query.getOrDefault("prettyPrint")
  valid_580176 = validateParameter(valid_580176, JBool, required = false,
                                 default = newJBool(true))
  if valid_580176 != nil:
    section.add "prettyPrint", valid_580176
  var valid_580177 = query.getOrDefault("fieldSelector")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "fieldSelector", valid_580177
  var valid_580178 = query.getOrDefault("limit")
  valid_580178 = validateParameter(valid_580178, JInt, required = false, default = nil)
  if valid_580178 != nil:
    section.add "limit", valid_580178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580179: Call_RunNamespacesTriggersList_580157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list triggers.
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_RunNamespacesTriggersList_580157; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesTriggersList
  ## Rpc to list triggers.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the triggers should
  ## be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  add(query_580182, "upload_protocol", newJString(uploadProtocol))
  add(query_580182, "fields", newJString(fields))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(query_580182, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580182, "alt", newJString(alt))
  add(query_580182, "continue", newJString(`continue`))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(query_580182, "callback", newJString(callback))
  add(query_580182, "access_token", newJString(accessToken))
  add(query_580182, "uploadType", newJString(uploadType))
  add(path_580181, "parent", newJString(parent))
  add(query_580182, "resourceVersion", newJString(resourceVersion))
  add(query_580182, "watch", newJBool(watch))
  add(query_580182, "key", newJString(key))
  add(query_580182, "$.xgafv", newJString(Xgafv))
  add(query_580182, "labelSelector", newJString(labelSelector))
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  add(query_580182, "fieldSelector", newJString(fieldSelector))
  add(query_580182, "limit", newJInt(limit))
  result = call_580180.call(path_580181, query_580182, nil, nil, nil)

var runNamespacesTriggersList* = Call_RunNamespacesTriggersList_580157(
    name: "runNamespacesTriggersList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/triggers",
    validator: validate_RunNamespacesTriggersList_580158, base: "/",
    url: url_RunNamespacesTriggersList_580159, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesReplaceService_580223 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesServicesReplaceService_580225(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesServicesReplaceService_580224(path: JsonNode;
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
  var valid_580226 = path.getOrDefault("name")
  valid_580226 = validateParameter(valid_580226, JString, required = true,
                                 default = nil)
  if valid_580226 != nil:
    section.add "name", valid_580226
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
  var valid_580227 = query.getOrDefault("upload_protocol")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "upload_protocol", valid_580227
  var valid_580228 = query.getOrDefault("fields")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "fields", valid_580228
  var valid_580229 = query.getOrDefault("quotaUser")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "quotaUser", valid_580229
  var valid_580230 = query.getOrDefault("alt")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = newJString("json"))
  if valid_580230 != nil:
    section.add "alt", valid_580230
  var valid_580231 = query.getOrDefault("oauth_token")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "oauth_token", valid_580231
  var valid_580232 = query.getOrDefault("callback")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "callback", valid_580232
  var valid_580233 = query.getOrDefault("access_token")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "access_token", valid_580233
  var valid_580234 = query.getOrDefault("uploadType")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "uploadType", valid_580234
  var valid_580235 = query.getOrDefault("key")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "key", valid_580235
  var valid_580236 = query.getOrDefault("$.xgafv")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = newJString("1"))
  if valid_580236 != nil:
    section.add "$.xgafv", valid_580236
  var valid_580237 = query.getOrDefault("prettyPrint")
  valid_580237 = validateParameter(valid_580237, JBool, required = false,
                                 default = newJBool(true))
  if valid_580237 != nil:
    section.add "prettyPrint", valid_580237
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

proc call*(call_580239: Call_RunNamespacesServicesReplaceService_580223;
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
  let valid = call_580239.validator(path, query, header, formData, body)
  let scheme = call_580239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580239.url(scheme.get, call_580239.host, call_580239.base,
                         call_580239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580239, url, valid)

proc call*(call_580240: Call_RunNamespacesServicesReplaceService_580223;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesServicesReplaceService
  ## Rpc to replace a service.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the service being replaced. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_580241 = newJObject()
  var query_580242 = newJObject()
  var body_580243 = newJObject()
  add(query_580242, "upload_protocol", newJString(uploadProtocol))
  add(query_580242, "fields", newJString(fields))
  add(query_580242, "quotaUser", newJString(quotaUser))
  add(path_580241, "name", newJString(name))
  add(query_580242, "alt", newJString(alt))
  add(query_580242, "oauth_token", newJString(oauthToken))
  add(query_580242, "callback", newJString(callback))
  add(query_580242, "access_token", newJString(accessToken))
  add(query_580242, "uploadType", newJString(uploadType))
  add(query_580242, "key", newJString(key))
  add(query_580242, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580243 = body
  add(query_580242, "prettyPrint", newJBool(prettyPrint))
  result = call_580240.call(path_580241, query_580242, nil, nil, body_580243)

var runNamespacesServicesReplaceService* = Call_RunNamespacesServicesReplaceService_580223(
    name: "runNamespacesServicesReplaceService", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesServicesReplaceService_580224, base: "/",
    url: url_RunNamespacesServicesReplaceService_580225, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsGet_580204 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesConfigurationsGet_580206(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsGet_580205(path: JsonNode;
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
  var valid_580207 = path.getOrDefault("name")
  valid_580207 = validateParameter(valid_580207, JString, required = true,
                                 default = nil)
  if valid_580207 != nil:
    section.add "name", valid_580207
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
  var valid_580208 = query.getOrDefault("upload_protocol")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "upload_protocol", valid_580208
  var valid_580209 = query.getOrDefault("fields")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "fields", valid_580209
  var valid_580210 = query.getOrDefault("quotaUser")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "quotaUser", valid_580210
  var valid_580211 = query.getOrDefault("alt")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("json"))
  if valid_580211 != nil:
    section.add "alt", valid_580211
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
  var valid_580216 = query.getOrDefault("key")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "key", valid_580216
  var valid_580217 = query.getOrDefault("$.xgafv")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = newJString("1"))
  if valid_580217 != nil:
    section.add "$.xgafv", valid_580217
  var valid_580218 = query.getOrDefault("prettyPrint")
  valid_580218 = validateParameter(valid_580218, JBool, required = false,
                                 default = newJBool(true))
  if valid_580218 != nil:
    section.add "prettyPrint", valid_580218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580219: Call_RunNamespacesConfigurationsGet_580204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a configuration.
  ## 
  let valid = call_580219.validator(path, query, header, formData, body)
  let scheme = call_580219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580219.url(scheme.get, call_580219.host, call_580219.base,
                         call_580219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580219, url, valid)

proc call*(call_580220: Call_RunNamespacesConfigurationsGet_580204; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runNamespacesConfigurationsGet
  ## Rpc to get information about a configuration.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_580221 = newJObject()
  var query_580222 = newJObject()
  add(query_580222, "upload_protocol", newJString(uploadProtocol))
  add(query_580222, "fields", newJString(fields))
  add(query_580222, "quotaUser", newJString(quotaUser))
  add(path_580221, "name", newJString(name))
  add(query_580222, "alt", newJString(alt))
  add(query_580222, "oauth_token", newJString(oauthToken))
  add(query_580222, "callback", newJString(callback))
  add(query_580222, "access_token", newJString(accessToken))
  add(query_580222, "uploadType", newJString(uploadType))
  add(query_580222, "key", newJString(key))
  add(query_580222, "$.xgafv", newJString(Xgafv))
  add(query_580222, "prettyPrint", newJBool(prettyPrint))
  result = call_580220.call(path_580221, query_580222, nil, nil, nil)

var runNamespacesConfigurationsGet* = Call_RunNamespacesConfigurationsGet_580204(
    name: "runNamespacesConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesConfigurationsGet_580205, base: "/",
    url: url_RunNamespacesConfigurationsGet_580206, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsDelete_580244 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesRevisionsDelete_580246(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesRevisionsDelete_580245(path: JsonNode; query: JsonNode;
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
  var valid_580247 = path.getOrDefault("name")
  valid_580247 = validateParameter(valid_580247, JString, required = true,
                                 default = nil)
  if valid_580247 != nil:
    section.add "name", valid_580247
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   orphanDependents: JBool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
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
  ##       : Cloud Run currently ignores this parameter.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  section = newJObject()
  var valid_580248 = query.getOrDefault("upload_protocol")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "upload_protocol", valid_580248
  var valid_580249 = query.getOrDefault("fields")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "fields", valid_580249
  var valid_580250 = query.getOrDefault("orphanDependents")
  valid_580250 = validateParameter(valid_580250, JBool, required = false, default = nil)
  if valid_580250 != nil:
    section.add "orphanDependents", valid_580250
  var valid_580251 = query.getOrDefault("quotaUser")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "quotaUser", valid_580251
  var valid_580252 = query.getOrDefault("alt")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = newJString("json"))
  if valid_580252 != nil:
    section.add "alt", valid_580252
  var valid_580253 = query.getOrDefault("oauth_token")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "oauth_token", valid_580253
  var valid_580254 = query.getOrDefault("callback")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "callback", valid_580254
  var valid_580255 = query.getOrDefault("access_token")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "access_token", valid_580255
  var valid_580256 = query.getOrDefault("uploadType")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "uploadType", valid_580256
  var valid_580257 = query.getOrDefault("kind")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "kind", valid_580257
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
  var valid_580261 = query.getOrDefault("propagationPolicy")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "propagationPolicy", valid_580261
  var valid_580262 = query.getOrDefault("apiVersion")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "apiVersion", valid_580262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580263: Call_RunNamespacesRevisionsDelete_580244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to delete a revision.
  ## 
  let valid = call_580263.validator(path, query, header, formData, body)
  let scheme = call_580263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580263.url(scheme.get, call_580263.host, call_580263.base,
                         call_580263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580263, url, valid)

proc call*(call_580264: Call_RunNamespacesRevisionsDelete_580244; name: string;
          uploadProtocol: string = ""; fields: string = "";
          orphanDependents: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runNamespacesRevisionsDelete
  ## Rpc to delete a revision.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orphanDependents: bool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the revision being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  var path_580265 = newJObject()
  var query_580266 = newJObject()
  add(query_580266, "upload_protocol", newJString(uploadProtocol))
  add(query_580266, "fields", newJString(fields))
  add(query_580266, "orphanDependents", newJBool(orphanDependents))
  add(query_580266, "quotaUser", newJString(quotaUser))
  add(path_580265, "name", newJString(name))
  add(query_580266, "alt", newJString(alt))
  add(query_580266, "oauth_token", newJString(oauthToken))
  add(query_580266, "callback", newJString(callback))
  add(query_580266, "access_token", newJString(accessToken))
  add(query_580266, "uploadType", newJString(uploadType))
  add(query_580266, "kind", newJString(kind))
  add(query_580266, "key", newJString(key))
  add(query_580266, "$.xgafv", newJString(Xgafv))
  add(query_580266, "prettyPrint", newJBool(prettyPrint))
  add(query_580266, "propagationPolicy", newJString(propagationPolicy))
  add(query_580266, "apiVersion", newJString(apiVersion))
  result = call_580264.call(path_580265, query_580266, nil, nil, nil)

var runNamespacesRevisionsDelete* = Call_RunNamespacesRevisionsDelete_580244(
    name: "runNamespacesRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesRevisionsDelete_580245, base: "/",
    url: url_RunNamespacesRevisionsDelete_580246, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsList_580267 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesConfigurationsList_580269(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsList_580268(path: JsonNode;
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
  var valid_580270 = path.getOrDefault("parent")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "parent", valid_580270
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
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
  var valid_580274 = query.getOrDefault("includeUninitialized")
  valid_580274 = validateParameter(valid_580274, JBool, required = false, default = nil)
  if valid_580274 != nil:
    section.add "includeUninitialized", valid_580274
  var valid_580275 = query.getOrDefault("alt")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = newJString("json"))
  if valid_580275 != nil:
    section.add "alt", valid_580275
  var valid_580276 = query.getOrDefault("continue")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "continue", valid_580276
  var valid_580277 = query.getOrDefault("oauth_token")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "oauth_token", valid_580277
  var valid_580278 = query.getOrDefault("callback")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "callback", valid_580278
  var valid_580279 = query.getOrDefault("access_token")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "access_token", valid_580279
  var valid_580280 = query.getOrDefault("uploadType")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "uploadType", valid_580280
  var valid_580281 = query.getOrDefault("resourceVersion")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "resourceVersion", valid_580281
  var valid_580282 = query.getOrDefault("watch")
  valid_580282 = validateParameter(valid_580282, JBool, required = false, default = nil)
  if valid_580282 != nil:
    section.add "watch", valid_580282
  var valid_580283 = query.getOrDefault("key")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "key", valid_580283
  var valid_580284 = query.getOrDefault("$.xgafv")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = newJString("1"))
  if valid_580284 != nil:
    section.add "$.xgafv", valid_580284
  var valid_580285 = query.getOrDefault("labelSelector")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "labelSelector", valid_580285
  var valid_580286 = query.getOrDefault("prettyPrint")
  valid_580286 = validateParameter(valid_580286, JBool, required = false,
                                 default = newJBool(true))
  if valid_580286 != nil:
    section.add "prettyPrint", valid_580286
  var valid_580287 = query.getOrDefault("fieldSelector")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "fieldSelector", valid_580287
  var valid_580288 = query.getOrDefault("limit")
  valid_580288 = validateParameter(valid_580288, JInt, required = false, default = nil)
  if valid_580288 != nil:
    section.add "limit", valid_580288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580289: Call_RunNamespacesConfigurationsList_580267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list configurations.
  ## 
  let valid = call_580289.validator(path, query, header, formData, body)
  let scheme = call_580289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580289.url(scheme.get, call_580289.host, call_580289.base,
                         call_580289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580289, url, valid)

proc call*(call_580290: Call_RunNamespacesConfigurationsList_580267;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesConfigurationsList
  ## Rpc to list configurations.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580291 = newJObject()
  var query_580292 = newJObject()
  add(query_580292, "upload_protocol", newJString(uploadProtocol))
  add(query_580292, "fields", newJString(fields))
  add(query_580292, "quotaUser", newJString(quotaUser))
  add(query_580292, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580292, "alt", newJString(alt))
  add(query_580292, "continue", newJString(`continue`))
  add(query_580292, "oauth_token", newJString(oauthToken))
  add(query_580292, "callback", newJString(callback))
  add(query_580292, "access_token", newJString(accessToken))
  add(query_580292, "uploadType", newJString(uploadType))
  add(path_580291, "parent", newJString(parent))
  add(query_580292, "resourceVersion", newJString(resourceVersion))
  add(query_580292, "watch", newJBool(watch))
  add(query_580292, "key", newJString(key))
  add(query_580292, "$.xgafv", newJString(Xgafv))
  add(query_580292, "labelSelector", newJString(labelSelector))
  add(query_580292, "prettyPrint", newJBool(prettyPrint))
  add(query_580292, "fieldSelector", newJString(fieldSelector))
  add(query_580292, "limit", newJInt(limit))
  result = call_580290.call(path_580291, query_580292, nil, nil, nil)

var runNamespacesConfigurationsList* = Call_RunNamespacesConfigurationsList_580267(
    name: "runNamespacesConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsList_580268, base: "/",
    url: url_RunNamespacesConfigurationsList_580269, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsList_580293 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesRevisionsList_580295(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesRevisionsList_580294(path: JsonNode; query: JsonNode;
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
  var valid_580296 = path.getOrDefault("parent")
  valid_580296 = validateParameter(valid_580296, JString, required = true,
                                 default = nil)
  if valid_580296 != nil:
    section.add "parent", valid_580296
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580297 = query.getOrDefault("upload_protocol")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "upload_protocol", valid_580297
  var valid_580298 = query.getOrDefault("fields")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "fields", valid_580298
  var valid_580299 = query.getOrDefault("quotaUser")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "quotaUser", valid_580299
  var valid_580300 = query.getOrDefault("includeUninitialized")
  valid_580300 = validateParameter(valid_580300, JBool, required = false, default = nil)
  if valid_580300 != nil:
    section.add "includeUninitialized", valid_580300
  var valid_580301 = query.getOrDefault("alt")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = newJString("json"))
  if valid_580301 != nil:
    section.add "alt", valid_580301
  var valid_580302 = query.getOrDefault("continue")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "continue", valid_580302
  var valid_580303 = query.getOrDefault("oauth_token")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "oauth_token", valid_580303
  var valid_580304 = query.getOrDefault("callback")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "callback", valid_580304
  var valid_580305 = query.getOrDefault("access_token")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "access_token", valid_580305
  var valid_580306 = query.getOrDefault("uploadType")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "uploadType", valid_580306
  var valid_580307 = query.getOrDefault("resourceVersion")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "resourceVersion", valid_580307
  var valid_580308 = query.getOrDefault("watch")
  valid_580308 = validateParameter(valid_580308, JBool, required = false, default = nil)
  if valid_580308 != nil:
    section.add "watch", valid_580308
  var valid_580309 = query.getOrDefault("key")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "key", valid_580309
  var valid_580310 = query.getOrDefault("$.xgafv")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = newJString("1"))
  if valid_580310 != nil:
    section.add "$.xgafv", valid_580310
  var valid_580311 = query.getOrDefault("labelSelector")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "labelSelector", valid_580311
  var valid_580312 = query.getOrDefault("prettyPrint")
  valid_580312 = validateParameter(valid_580312, JBool, required = false,
                                 default = newJBool(true))
  if valid_580312 != nil:
    section.add "prettyPrint", valid_580312
  var valid_580313 = query.getOrDefault("fieldSelector")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "fieldSelector", valid_580313
  var valid_580314 = query.getOrDefault("limit")
  valid_580314 = validateParameter(valid_580314, JInt, required = false, default = nil)
  if valid_580314 != nil:
    section.add "limit", valid_580314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580315: Call_RunNamespacesRevisionsList_580293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list revisions.
  ## 
  let valid = call_580315.validator(path, query, header, formData, body)
  let scheme = call_580315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580315.url(scheme.get, call_580315.host, call_580315.base,
                         call_580315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580315, url, valid)

proc call*(call_580316: Call_RunNamespacesRevisionsList_580293; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesRevisionsList
  ## Rpc to list revisions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the revisions should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580317 = newJObject()
  var query_580318 = newJObject()
  add(query_580318, "upload_protocol", newJString(uploadProtocol))
  add(query_580318, "fields", newJString(fields))
  add(query_580318, "quotaUser", newJString(quotaUser))
  add(query_580318, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580318, "alt", newJString(alt))
  add(query_580318, "continue", newJString(`continue`))
  add(query_580318, "oauth_token", newJString(oauthToken))
  add(query_580318, "callback", newJString(callback))
  add(query_580318, "access_token", newJString(accessToken))
  add(query_580318, "uploadType", newJString(uploadType))
  add(path_580317, "parent", newJString(parent))
  add(query_580318, "resourceVersion", newJString(resourceVersion))
  add(query_580318, "watch", newJBool(watch))
  add(query_580318, "key", newJString(key))
  add(query_580318, "$.xgafv", newJString(Xgafv))
  add(query_580318, "labelSelector", newJString(labelSelector))
  add(query_580318, "prettyPrint", newJBool(prettyPrint))
  add(query_580318, "fieldSelector", newJString(fieldSelector))
  add(query_580318, "limit", newJInt(limit))
  result = call_580316.call(path_580317, query_580318, nil, nil, nil)

var runNamespacesRevisionsList* = Call_RunNamespacesRevisionsList_580293(
    name: "runNamespacesRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/revisions",
    validator: validate_RunNamespacesRevisionsList_580294, base: "/",
    url: url_RunNamespacesRevisionsList_580295, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesList_580319 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesRoutesList_580321(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesRoutesList_580320(path: JsonNode; query: JsonNode;
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
  var valid_580322 = path.getOrDefault("parent")
  valid_580322 = validateParameter(valid_580322, JString, required = true,
                                 default = nil)
  if valid_580322 != nil:
    section.add "parent", valid_580322
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580323 = query.getOrDefault("upload_protocol")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "upload_protocol", valid_580323
  var valid_580324 = query.getOrDefault("fields")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "fields", valid_580324
  var valid_580325 = query.getOrDefault("quotaUser")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "quotaUser", valid_580325
  var valid_580326 = query.getOrDefault("includeUninitialized")
  valid_580326 = validateParameter(valid_580326, JBool, required = false, default = nil)
  if valid_580326 != nil:
    section.add "includeUninitialized", valid_580326
  var valid_580327 = query.getOrDefault("alt")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = newJString("json"))
  if valid_580327 != nil:
    section.add "alt", valid_580327
  var valid_580328 = query.getOrDefault("continue")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "continue", valid_580328
  var valid_580329 = query.getOrDefault("oauth_token")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "oauth_token", valid_580329
  var valid_580330 = query.getOrDefault("callback")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "callback", valid_580330
  var valid_580331 = query.getOrDefault("access_token")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "access_token", valid_580331
  var valid_580332 = query.getOrDefault("uploadType")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "uploadType", valid_580332
  var valid_580333 = query.getOrDefault("resourceVersion")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "resourceVersion", valid_580333
  var valid_580334 = query.getOrDefault("watch")
  valid_580334 = validateParameter(valid_580334, JBool, required = false, default = nil)
  if valid_580334 != nil:
    section.add "watch", valid_580334
  var valid_580335 = query.getOrDefault("key")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "key", valid_580335
  var valid_580336 = query.getOrDefault("$.xgafv")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = newJString("1"))
  if valid_580336 != nil:
    section.add "$.xgafv", valid_580336
  var valid_580337 = query.getOrDefault("labelSelector")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "labelSelector", valid_580337
  var valid_580338 = query.getOrDefault("prettyPrint")
  valid_580338 = validateParameter(valid_580338, JBool, required = false,
                                 default = newJBool(true))
  if valid_580338 != nil:
    section.add "prettyPrint", valid_580338
  var valid_580339 = query.getOrDefault("fieldSelector")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "fieldSelector", valid_580339
  var valid_580340 = query.getOrDefault("limit")
  valid_580340 = validateParameter(valid_580340, JInt, required = false, default = nil)
  if valid_580340 != nil:
    section.add "limit", valid_580340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580341: Call_RunNamespacesRoutesList_580319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list routes.
  ## 
  let valid = call_580341.validator(path, query, header, formData, body)
  let scheme = call_580341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580341.url(scheme.get, call_580341.host, call_580341.base,
                         call_580341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580341, url, valid)

proc call*(call_580342: Call_RunNamespacesRoutesList_580319; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesRoutesList
  ## Rpc to list routes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the routes should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580343 = newJObject()
  var query_580344 = newJObject()
  add(query_580344, "upload_protocol", newJString(uploadProtocol))
  add(query_580344, "fields", newJString(fields))
  add(query_580344, "quotaUser", newJString(quotaUser))
  add(query_580344, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580344, "alt", newJString(alt))
  add(query_580344, "continue", newJString(`continue`))
  add(query_580344, "oauth_token", newJString(oauthToken))
  add(query_580344, "callback", newJString(callback))
  add(query_580344, "access_token", newJString(accessToken))
  add(query_580344, "uploadType", newJString(uploadType))
  add(path_580343, "parent", newJString(parent))
  add(query_580344, "resourceVersion", newJString(resourceVersion))
  add(query_580344, "watch", newJBool(watch))
  add(query_580344, "key", newJString(key))
  add(query_580344, "$.xgafv", newJString(Xgafv))
  add(query_580344, "labelSelector", newJString(labelSelector))
  add(query_580344, "prettyPrint", newJBool(prettyPrint))
  add(query_580344, "fieldSelector", newJString(fieldSelector))
  add(query_580344, "limit", newJInt(limit))
  result = call_580342.call(path_580343, query_580344, nil, nil, nil)

var runNamespacesRoutesList* = Call_RunNamespacesRoutesList_580319(
    name: "runNamespacesRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/routes",
    validator: validate_RunNamespacesRoutesList_580320, base: "/",
    url: url_RunNamespacesRoutesList_580321, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesCreate_580371 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesServicesCreate_580373(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesServicesCreate_580372(path: JsonNode; query: JsonNode;
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
  var valid_580374 = path.getOrDefault("parent")
  valid_580374 = validateParameter(valid_580374, JString, required = true,
                                 default = nil)
  if valid_580374 != nil:
    section.add "parent", valid_580374
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
  var valid_580375 = query.getOrDefault("upload_protocol")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "upload_protocol", valid_580375
  var valid_580376 = query.getOrDefault("fields")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "fields", valid_580376
  var valid_580377 = query.getOrDefault("quotaUser")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "quotaUser", valid_580377
  var valid_580378 = query.getOrDefault("alt")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = newJString("json"))
  if valid_580378 != nil:
    section.add "alt", valid_580378
  var valid_580379 = query.getOrDefault("oauth_token")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "oauth_token", valid_580379
  var valid_580380 = query.getOrDefault("callback")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "callback", valid_580380
  var valid_580381 = query.getOrDefault("access_token")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "access_token", valid_580381
  var valid_580382 = query.getOrDefault("uploadType")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "uploadType", valid_580382
  var valid_580383 = query.getOrDefault("key")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "key", valid_580383
  var valid_580384 = query.getOrDefault("$.xgafv")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = newJString("1"))
  if valid_580384 != nil:
    section.add "$.xgafv", valid_580384
  var valid_580385 = query.getOrDefault("prettyPrint")
  valid_580385 = validateParameter(valid_580385, JBool, required = false,
                                 default = newJBool(true))
  if valid_580385 != nil:
    section.add "prettyPrint", valid_580385
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

proc call*(call_580387: Call_RunNamespacesServicesCreate_580371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to create a service.
  ## 
  let valid = call_580387.validator(path, query, header, formData, body)
  let scheme = call_580387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580387.url(scheme.get, call_580387.host, call_580387.base,
                         call_580387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580387, url, valid)

proc call*(call_580388: Call_RunNamespacesServicesCreate_580371; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## runNamespacesServicesCreate
  ## Rpc to create a service.
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
  ##         : The project ID or project number in which this service should be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580389 = newJObject()
  var query_580390 = newJObject()
  var body_580391 = newJObject()
  add(query_580390, "upload_protocol", newJString(uploadProtocol))
  add(query_580390, "fields", newJString(fields))
  add(query_580390, "quotaUser", newJString(quotaUser))
  add(query_580390, "alt", newJString(alt))
  add(query_580390, "oauth_token", newJString(oauthToken))
  add(query_580390, "callback", newJString(callback))
  add(query_580390, "access_token", newJString(accessToken))
  add(query_580390, "uploadType", newJString(uploadType))
  add(path_580389, "parent", newJString(parent))
  add(query_580390, "key", newJString(key))
  add(query_580390, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580391 = body
  add(query_580390, "prettyPrint", newJBool(prettyPrint))
  result = call_580388.call(path_580389, query_580390, nil, nil, body_580391)

var runNamespacesServicesCreate* = Call_RunNamespacesServicesCreate_580371(
    name: "runNamespacesServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/services",
    validator: validate_RunNamespacesServicesCreate_580372, base: "/",
    url: url_RunNamespacesServicesCreate_580373, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesList_580345 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesServicesList_580347(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesServicesList_580346(path: JsonNode; query: JsonNode;
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
  var valid_580348 = path.getOrDefault("parent")
  valid_580348 = validateParameter(valid_580348, JString, required = true,
                                 default = nil)
  if valid_580348 != nil:
    section.add "parent", valid_580348
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580349 = query.getOrDefault("upload_protocol")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "upload_protocol", valid_580349
  var valid_580350 = query.getOrDefault("fields")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "fields", valid_580350
  var valid_580351 = query.getOrDefault("quotaUser")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "quotaUser", valid_580351
  var valid_580352 = query.getOrDefault("includeUninitialized")
  valid_580352 = validateParameter(valid_580352, JBool, required = false, default = nil)
  if valid_580352 != nil:
    section.add "includeUninitialized", valid_580352
  var valid_580353 = query.getOrDefault("alt")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = newJString("json"))
  if valid_580353 != nil:
    section.add "alt", valid_580353
  var valid_580354 = query.getOrDefault("continue")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "continue", valid_580354
  var valid_580355 = query.getOrDefault("oauth_token")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "oauth_token", valid_580355
  var valid_580356 = query.getOrDefault("callback")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "callback", valid_580356
  var valid_580357 = query.getOrDefault("access_token")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "access_token", valid_580357
  var valid_580358 = query.getOrDefault("uploadType")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "uploadType", valid_580358
  var valid_580359 = query.getOrDefault("resourceVersion")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "resourceVersion", valid_580359
  var valid_580360 = query.getOrDefault("watch")
  valid_580360 = validateParameter(valid_580360, JBool, required = false, default = nil)
  if valid_580360 != nil:
    section.add "watch", valid_580360
  var valid_580361 = query.getOrDefault("key")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "key", valid_580361
  var valid_580362 = query.getOrDefault("$.xgafv")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = newJString("1"))
  if valid_580362 != nil:
    section.add "$.xgafv", valid_580362
  var valid_580363 = query.getOrDefault("labelSelector")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "labelSelector", valid_580363
  var valid_580364 = query.getOrDefault("prettyPrint")
  valid_580364 = validateParameter(valid_580364, JBool, required = false,
                                 default = newJBool(true))
  if valid_580364 != nil:
    section.add "prettyPrint", valid_580364
  var valid_580365 = query.getOrDefault("fieldSelector")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "fieldSelector", valid_580365
  var valid_580366 = query.getOrDefault("limit")
  valid_580366 = validateParameter(valid_580366, JInt, required = false, default = nil)
  if valid_580366 != nil:
    section.add "limit", valid_580366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580367: Call_RunNamespacesServicesList_580345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list services.
  ## 
  let valid = call_580367.validator(path, query, header, formData, body)
  let scheme = call_580367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580367.url(scheme.get, call_580367.host, call_580367.base,
                         call_580367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580367, url, valid)

proc call*(call_580368: Call_RunNamespacesServicesList_580345; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesServicesList
  ## Rpc to list services.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the services should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580369 = newJObject()
  var query_580370 = newJObject()
  add(query_580370, "upload_protocol", newJString(uploadProtocol))
  add(query_580370, "fields", newJString(fields))
  add(query_580370, "quotaUser", newJString(quotaUser))
  add(query_580370, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580370, "alt", newJString(alt))
  add(query_580370, "continue", newJString(`continue`))
  add(query_580370, "oauth_token", newJString(oauthToken))
  add(query_580370, "callback", newJString(callback))
  add(query_580370, "access_token", newJString(accessToken))
  add(query_580370, "uploadType", newJString(uploadType))
  add(path_580369, "parent", newJString(parent))
  add(query_580370, "resourceVersion", newJString(resourceVersion))
  add(query_580370, "watch", newJBool(watch))
  add(query_580370, "key", newJString(key))
  add(query_580370, "$.xgafv", newJString(Xgafv))
  add(query_580370, "labelSelector", newJString(labelSelector))
  add(query_580370, "prettyPrint", newJBool(prettyPrint))
  add(query_580370, "fieldSelector", newJString(fieldSelector))
  add(query_580370, "limit", newJInt(limit))
  result = call_580368.call(path_580369, query_580370, nil, nil, nil)

var runNamespacesServicesList* = Call_RunNamespacesServicesList_580345(
    name: "runNamespacesServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/services",
    validator: validate_RunNamespacesServicesList_580346, base: "/",
    url: url_RunNamespacesServicesList_580347, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesReplaceService_580411 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsServicesReplaceService_580413(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesReplaceService_580412(path: JsonNode;
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
  var valid_580414 = path.getOrDefault("name")
  valid_580414 = validateParameter(valid_580414, JString, required = true,
                                 default = nil)
  if valid_580414 != nil:
    section.add "name", valid_580414
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
  var valid_580415 = query.getOrDefault("upload_protocol")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "upload_protocol", valid_580415
  var valid_580416 = query.getOrDefault("fields")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "fields", valid_580416
  var valid_580417 = query.getOrDefault("quotaUser")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "quotaUser", valid_580417
  var valid_580418 = query.getOrDefault("alt")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = newJString("json"))
  if valid_580418 != nil:
    section.add "alt", valid_580418
  var valid_580419 = query.getOrDefault("oauth_token")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "oauth_token", valid_580419
  var valid_580420 = query.getOrDefault("callback")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "callback", valid_580420
  var valid_580421 = query.getOrDefault("access_token")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "access_token", valid_580421
  var valid_580422 = query.getOrDefault("uploadType")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "uploadType", valid_580422
  var valid_580423 = query.getOrDefault("key")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "key", valid_580423
  var valid_580424 = query.getOrDefault("$.xgafv")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = newJString("1"))
  if valid_580424 != nil:
    section.add "$.xgafv", valid_580424
  var valid_580425 = query.getOrDefault("prettyPrint")
  valid_580425 = validateParameter(valid_580425, JBool, required = false,
                                 default = newJBool(true))
  if valid_580425 != nil:
    section.add "prettyPrint", valid_580425
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

proc call*(call_580427: Call_RunProjectsLocationsServicesReplaceService_580411;
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
  let valid = call_580427.validator(path, query, header, formData, body)
  let scheme = call_580427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580427.url(scheme.get, call_580427.host, call_580427.base,
                         call_580427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580427, url, valid)

proc call*(call_580428: Call_RunProjectsLocationsServicesReplaceService_580411;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesReplaceService
  ## Rpc to replace a service.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the service being replaced. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_580429 = newJObject()
  var query_580430 = newJObject()
  var body_580431 = newJObject()
  add(query_580430, "upload_protocol", newJString(uploadProtocol))
  add(query_580430, "fields", newJString(fields))
  add(query_580430, "quotaUser", newJString(quotaUser))
  add(path_580429, "name", newJString(name))
  add(query_580430, "alt", newJString(alt))
  add(query_580430, "oauth_token", newJString(oauthToken))
  add(query_580430, "callback", newJString(callback))
  add(query_580430, "access_token", newJString(accessToken))
  add(query_580430, "uploadType", newJString(uploadType))
  add(query_580430, "key", newJString(key))
  add(query_580430, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580431 = body
  add(query_580430, "prettyPrint", newJBool(prettyPrint))
  result = call_580428.call(path_580429, query_580430, nil, nil, body_580431)

var runProjectsLocationsServicesReplaceService* = Call_RunProjectsLocationsServicesReplaceService_580411(
    name: "runProjectsLocationsServicesReplaceService", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsServicesReplaceService_580412,
    base: "/", url: url_RunProjectsLocationsServicesReplaceService_580413,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsGet_580392 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsDomainmappingsGet_580394(protocol: Scheme;
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

proc validate_RunProjectsLocationsDomainmappingsGet_580393(path: JsonNode;
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
  var valid_580395 = path.getOrDefault("name")
  valid_580395 = validateParameter(valid_580395, JString, required = true,
                                 default = nil)
  if valid_580395 != nil:
    section.add "name", valid_580395
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
  var valid_580396 = query.getOrDefault("upload_protocol")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "upload_protocol", valid_580396
  var valid_580397 = query.getOrDefault("fields")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "fields", valid_580397
  var valid_580398 = query.getOrDefault("quotaUser")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "quotaUser", valid_580398
  var valid_580399 = query.getOrDefault("alt")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = newJString("json"))
  if valid_580399 != nil:
    section.add "alt", valid_580399
  var valid_580400 = query.getOrDefault("oauth_token")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "oauth_token", valid_580400
  var valid_580401 = query.getOrDefault("callback")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "callback", valid_580401
  var valid_580402 = query.getOrDefault("access_token")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "access_token", valid_580402
  var valid_580403 = query.getOrDefault("uploadType")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "uploadType", valid_580403
  var valid_580404 = query.getOrDefault("key")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "key", valid_580404
  var valid_580405 = query.getOrDefault("$.xgafv")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = newJString("1"))
  if valid_580405 != nil:
    section.add "$.xgafv", valid_580405
  var valid_580406 = query.getOrDefault("prettyPrint")
  valid_580406 = validateParameter(valid_580406, JBool, required = false,
                                 default = newJBool(true))
  if valid_580406 != nil:
    section.add "prettyPrint", valid_580406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580407: Call_RunProjectsLocationsDomainmappingsGet_580392;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to get information about a domain mapping.
  ## 
  let valid = call_580407.validator(path, query, header, formData, body)
  let scheme = call_580407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580407.url(scheme.get, call_580407.host, call_580407.base,
                         call_580407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580407, url, valid)

proc call*(call_580408: Call_RunProjectsLocationsDomainmappingsGet_580392;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsDomainmappingsGet
  ## Rpc to get information about a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_580409 = newJObject()
  var query_580410 = newJObject()
  add(query_580410, "upload_protocol", newJString(uploadProtocol))
  add(query_580410, "fields", newJString(fields))
  add(query_580410, "quotaUser", newJString(quotaUser))
  add(path_580409, "name", newJString(name))
  add(query_580410, "alt", newJString(alt))
  add(query_580410, "oauth_token", newJString(oauthToken))
  add(query_580410, "callback", newJString(callback))
  add(query_580410, "access_token", newJString(accessToken))
  add(query_580410, "uploadType", newJString(uploadType))
  add(query_580410, "key", newJString(key))
  add(query_580410, "$.xgafv", newJString(Xgafv))
  add(query_580410, "prettyPrint", newJBool(prettyPrint))
  result = call_580408.call(path_580409, query_580410, nil, nil, nil)

var runProjectsLocationsDomainmappingsGet* = Call_RunProjectsLocationsDomainmappingsGet_580392(
    name: "runProjectsLocationsDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsGet_580393, base: "/",
    url: url_RunProjectsLocationsDomainmappingsGet_580394, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsDelete_580432 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsDomainmappingsDelete_580434(protocol: Scheme;
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

proc validate_RunProjectsLocationsDomainmappingsDelete_580433(path: JsonNode;
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
  var valid_580435 = path.getOrDefault("name")
  valid_580435 = validateParameter(valid_580435, JString, required = true,
                                 default = nil)
  if valid_580435 != nil:
    section.add "name", valid_580435
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   orphanDependents: JBool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
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
  ##       : Cloud Run currently ignores this parameter.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  section = newJObject()
  var valid_580436 = query.getOrDefault("upload_protocol")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "upload_protocol", valid_580436
  var valid_580437 = query.getOrDefault("fields")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "fields", valid_580437
  var valid_580438 = query.getOrDefault("orphanDependents")
  valid_580438 = validateParameter(valid_580438, JBool, required = false, default = nil)
  if valid_580438 != nil:
    section.add "orphanDependents", valid_580438
  var valid_580439 = query.getOrDefault("quotaUser")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "quotaUser", valid_580439
  var valid_580440 = query.getOrDefault("alt")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = newJString("json"))
  if valid_580440 != nil:
    section.add "alt", valid_580440
  var valid_580441 = query.getOrDefault("oauth_token")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "oauth_token", valid_580441
  var valid_580442 = query.getOrDefault("callback")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "callback", valid_580442
  var valid_580443 = query.getOrDefault("access_token")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "access_token", valid_580443
  var valid_580444 = query.getOrDefault("uploadType")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "uploadType", valid_580444
  var valid_580445 = query.getOrDefault("kind")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "kind", valid_580445
  var valid_580446 = query.getOrDefault("key")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "key", valid_580446
  var valid_580447 = query.getOrDefault("$.xgafv")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = newJString("1"))
  if valid_580447 != nil:
    section.add "$.xgafv", valid_580447
  var valid_580448 = query.getOrDefault("prettyPrint")
  valid_580448 = validateParameter(valid_580448, JBool, required = false,
                                 default = newJBool(true))
  if valid_580448 != nil:
    section.add "prettyPrint", valid_580448
  var valid_580449 = query.getOrDefault("propagationPolicy")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "propagationPolicy", valid_580449
  var valid_580450 = query.getOrDefault("apiVersion")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "apiVersion", valid_580450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580451: Call_RunProjectsLocationsDomainmappingsDelete_580432;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to delete a domain mapping.
  ## 
  let valid = call_580451.validator(path, query, header, formData, body)
  let scheme = call_580451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580451.url(scheme.get, call_580451.host, call_580451.base,
                         call_580451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580451, url, valid)

proc call*(call_580452: Call_RunProjectsLocationsDomainmappingsDelete_580432;
          name: string; uploadProtocol: string = ""; fields: string = "";
          orphanDependents: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsDelete
  ## Rpc to delete a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orphanDependents: bool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  var path_580453 = newJObject()
  var query_580454 = newJObject()
  add(query_580454, "upload_protocol", newJString(uploadProtocol))
  add(query_580454, "fields", newJString(fields))
  add(query_580454, "orphanDependents", newJBool(orphanDependents))
  add(query_580454, "quotaUser", newJString(quotaUser))
  add(path_580453, "name", newJString(name))
  add(query_580454, "alt", newJString(alt))
  add(query_580454, "oauth_token", newJString(oauthToken))
  add(query_580454, "callback", newJString(callback))
  add(query_580454, "access_token", newJString(accessToken))
  add(query_580454, "uploadType", newJString(uploadType))
  add(query_580454, "kind", newJString(kind))
  add(query_580454, "key", newJString(key))
  add(query_580454, "$.xgafv", newJString(Xgafv))
  add(query_580454, "prettyPrint", newJBool(prettyPrint))
  add(query_580454, "propagationPolicy", newJString(propagationPolicy))
  add(query_580454, "apiVersion", newJString(apiVersion))
  result = call_580452.call(path_580453, query_580454, nil, nil, nil)

var runProjectsLocationsDomainmappingsDelete* = Call_RunProjectsLocationsDomainmappingsDelete_580432(
    name: "runProjectsLocationsDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsDelete_580433,
    base: "/", url: url_RunProjectsLocationsDomainmappingsDelete_580434,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsList_580455 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsList_580457(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsList_580456(path: JsonNode; query: JsonNode;
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
  var valid_580458 = path.getOrDefault("name")
  valid_580458 = validateParameter(valid_580458, JString, required = true,
                                 default = nil)
  if valid_580458 != nil:
    section.add "name", valid_580458
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_580459 = query.getOrDefault("upload_protocol")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "upload_protocol", valid_580459
  var valid_580460 = query.getOrDefault("fields")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "fields", valid_580460
  var valid_580461 = query.getOrDefault("pageToken")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "pageToken", valid_580461
  var valid_580462 = query.getOrDefault("quotaUser")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "quotaUser", valid_580462
  var valid_580463 = query.getOrDefault("alt")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = newJString("json"))
  if valid_580463 != nil:
    section.add "alt", valid_580463
  var valid_580464 = query.getOrDefault("oauth_token")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "oauth_token", valid_580464
  var valid_580465 = query.getOrDefault("callback")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "callback", valid_580465
  var valid_580466 = query.getOrDefault("access_token")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "access_token", valid_580466
  var valid_580467 = query.getOrDefault("uploadType")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "uploadType", valid_580467
  var valid_580468 = query.getOrDefault("key")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "key", valid_580468
  var valid_580469 = query.getOrDefault("$.xgafv")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = newJString("1"))
  if valid_580469 != nil:
    section.add "$.xgafv", valid_580469
  var valid_580470 = query.getOrDefault("pageSize")
  valid_580470 = validateParameter(valid_580470, JInt, required = false, default = nil)
  if valid_580470 != nil:
    section.add "pageSize", valid_580470
  var valid_580471 = query.getOrDefault("prettyPrint")
  valid_580471 = validateParameter(valid_580471, JBool, required = false,
                                 default = newJBool(true))
  if valid_580471 != nil:
    section.add "prettyPrint", valid_580471
  var valid_580472 = query.getOrDefault("filter")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "filter", valid_580472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580473: Call_RunProjectsLocationsList_580455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580473.validator(path, query, header, formData, body)
  let scheme = call_580473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580473.url(scheme.get, call_580473.host, call_580473.base,
                         call_580473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580473, url, valid)

proc call*(call_580474: Call_RunProjectsLocationsList_580455; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## runProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
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
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_580475 = newJObject()
  var query_580476 = newJObject()
  add(query_580476, "upload_protocol", newJString(uploadProtocol))
  add(query_580476, "fields", newJString(fields))
  add(query_580476, "pageToken", newJString(pageToken))
  add(query_580476, "quotaUser", newJString(quotaUser))
  add(path_580475, "name", newJString(name))
  add(query_580476, "alt", newJString(alt))
  add(query_580476, "oauth_token", newJString(oauthToken))
  add(query_580476, "callback", newJString(callback))
  add(query_580476, "access_token", newJString(accessToken))
  add(query_580476, "uploadType", newJString(uploadType))
  add(query_580476, "key", newJString(key))
  add(query_580476, "$.xgafv", newJString(Xgafv))
  add(query_580476, "pageSize", newJInt(pageSize))
  add(query_580476, "prettyPrint", newJBool(prettyPrint))
  add(query_580476, "filter", newJString(filter))
  result = call_580474.call(path_580475, query_580476, nil, nil, nil)

var runProjectsLocationsList* = Call_RunProjectsLocationsList_580455(
    name: "runProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{name}/locations",
    validator: validate_RunProjectsLocationsList_580456, base: "/",
    url: url_RunProjectsLocationsList_580457, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAuthorizeddomainsList_580477 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsAuthorizeddomainsList_580479(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsAuthorizeddomainsList_580478(path: JsonNode;
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
  var valid_580480 = path.getOrDefault("parent")
  valid_580480 = validateParameter(valid_580480, JString, required = true,
                                 default = nil)
  if valid_580480 != nil:
    section.add "parent", valid_580480
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
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
  ##           : Maximum results to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580481 = query.getOrDefault("upload_protocol")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "upload_protocol", valid_580481
  var valid_580482 = query.getOrDefault("fields")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "fields", valid_580482
  var valid_580483 = query.getOrDefault("pageToken")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "pageToken", valid_580483
  var valid_580484 = query.getOrDefault("quotaUser")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "quotaUser", valid_580484
  var valid_580485 = query.getOrDefault("alt")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = newJString("json"))
  if valid_580485 != nil:
    section.add "alt", valid_580485
  var valid_580486 = query.getOrDefault("oauth_token")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "oauth_token", valid_580486
  var valid_580487 = query.getOrDefault("callback")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "callback", valid_580487
  var valid_580488 = query.getOrDefault("access_token")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "access_token", valid_580488
  var valid_580489 = query.getOrDefault("uploadType")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "uploadType", valid_580489
  var valid_580490 = query.getOrDefault("key")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "key", valid_580490
  var valid_580491 = query.getOrDefault("$.xgafv")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = newJString("1"))
  if valid_580491 != nil:
    section.add "$.xgafv", valid_580491
  var valid_580492 = query.getOrDefault("pageSize")
  valid_580492 = validateParameter(valid_580492, JInt, required = false, default = nil)
  if valid_580492 != nil:
    section.add "pageSize", valid_580492
  var valid_580493 = query.getOrDefault("prettyPrint")
  valid_580493 = validateParameter(valid_580493, JBool, required = false,
                                 default = newJBool(true))
  if valid_580493 != nil:
    section.add "prettyPrint", valid_580493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580494: Call_RunProjectsLocationsAuthorizeddomainsList_580477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RPC to list authorized domains.
  ## 
  let valid = call_580494.validator(path, query, header, formData, body)
  let scheme = call_580494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580494.url(scheme.get, call_580494.host, call_580494.base,
                         call_580494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580494, url, valid)

proc call*(call_580495: Call_RunProjectsLocationsAuthorizeddomainsList_580477;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsAuthorizeddomainsList
  ## RPC to list authorized domains.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
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
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580496 = newJObject()
  var query_580497 = newJObject()
  add(query_580497, "upload_protocol", newJString(uploadProtocol))
  add(query_580497, "fields", newJString(fields))
  add(query_580497, "pageToken", newJString(pageToken))
  add(query_580497, "quotaUser", newJString(quotaUser))
  add(query_580497, "alt", newJString(alt))
  add(query_580497, "oauth_token", newJString(oauthToken))
  add(query_580497, "callback", newJString(callback))
  add(query_580497, "access_token", newJString(accessToken))
  add(query_580497, "uploadType", newJString(uploadType))
  add(path_580496, "parent", newJString(parent))
  add(query_580497, "key", newJString(key))
  add(query_580497, "$.xgafv", newJString(Xgafv))
  add(query_580497, "pageSize", newJInt(pageSize))
  add(query_580497, "prettyPrint", newJBool(prettyPrint))
  result = call_580495.call(path_580496, query_580497, nil, nil, nil)

var runProjectsLocationsAuthorizeddomainsList* = Call_RunProjectsLocationsAuthorizeddomainsList_580477(
    name: "runProjectsLocationsAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/authorizeddomains",
    validator: validate_RunProjectsLocationsAuthorizeddomainsList_580478,
    base: "/", url: url_RunProjectsLocationsAuthorizeddomainsList_580479,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsList_580498 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsConfigurationsList_580500(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsConfigurationsList_580499(path: JsonNode;
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
  var valid_580501 = path.getOrDefault("parent")
  valid_580501 = validateParameter(valid_580501, JString, required = true,
                                 default = nil)
  if valid_580501 != nil:
    section.add "parent", valid_580501
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580502 = query.getOrDefault("upload_protocol")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "upload_protocol", valid_580502
  var valid_580503 = query.getOrDefault("fields")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "fields", valid_580503
  var valid_580504 = query.getOrDefault("quotaUser")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "quotaUser", valid_580504
  var valid_580505 = query.getOrDefault("includeUninitialized")
  valid_580505 = validateParameter(valid_580505, JBool, required = false, default = nil)
  if valid_580505 != nil:
    section.add "includeUninitialized", valid_580505
  var valid_580506 = query.getOrDefault("alt")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = newJString("json"))
  if valid_580506 != nil:
    section.add "alt", valid_580506
  var valid_580507 = query.getOrDefault("continue")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "continue", valid_580507
  var valid_580508 = query.getOrDefault("oauth_token")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "oauth_token", valid_580508
  var valid_580509 = query.getOrDefault("callback")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "callback", valid_580509
  var valid_580510 = query.getOrDefault("access_token")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "access_token", valid_580510
  var valid_580511 = query.getOrDefault("uploadType")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "uploadType", valid_580511
  var valid_580512 = query.getOrDefault("resourceVersion")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "resourceVersion", valid_580512
  var valid_580513 = query.getOrDefault("watch")
  valid_580513 = validateParameter(valid_580513, JBool, required = false, default = nil)
  if valid_580513 != nil:
    section.add "watch", valid_580513
  var valid_580514 = query.getOrDefault("key")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "key", valid_580514
  var valid_580515 = query.getOrDefault("$.xgafv")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = newJString("1"))
  if valid_580515 != nil:
    section.add "$.xgafv", valid_580515
  var valid_580516 = query.getOrDefault("labelSelector")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "labelSelector", valid_580516
  var valid_580517 = query.getOrDefault("prettyPrint")
  valid_580517 = validateParameter(valid_580517, JBool, required = false,
                                 default = newJBool(true))
  if valid_580517 != nil:
    section.add "prettyPrint", valid_580517
  var valid_580518 = query.getOrDefault("fieldSelector")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "fieldSelector", valid_580518
  var valid_580519 = query.getOrDefault("limit")
  valid_580519 = validateParameter(valid_580519, JInt, required = false, default = nil)
  if valid_580519 != nil:
    section.add "limit", valid_580519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580520: Call_RunProjectsLocationsConfigurationsList_580498;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list configurations.
  ## 
  let valid = call_580520.validator(path, query, header, formData, body)
  let scheme = call_580520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580520.url(scheme.get, call_580520.host, call_580520.base,
                         call_580520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580520, url, valid)

proc call*(call_580521: Call_RunProjectsLocationsConfigurationsList_580498;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsConfigurationsList
  ## Rpc to list configurations.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580522 = newJObject()
  var query_580523 = newJObject()
  add(query_580523, "upload_protocol", newJString(uploadProtocol))
  add(query_580523, "fields", newJString(fields))
  add(query_580523, "quotaUser", newJString(quotaUser))
  add(query_580523, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580523, "alt", newJString(alt))
  add(query_580523, "continue", newJString(`continue`))
  add(query_580523, "oauth_token", newJString(oauthToken))
  add(query_580523, "callback", newJString(callback))
  add(query_580523, "access_token", newJString(accessToken))
  add(query_580523, "uploadType", newJString(uploadType))
  add(path_580522, "parent", newJString(parent))
  add(query_580523, "resourceVersion", newJString(resourceVersion))
  add(query_580523, "watch", newJBool(watch))
  add(query_580523, "key", newJString(key))
  add(query_580523, "$.xgafv", newJString(Xgafv))
  add(query_580523, "labelSelector", newJString(labelSelector))
  add(query_580523, "prettyPrint", newJBool(prettyPrint))
  add(query_580523, "fieldSelector", newJString(fieldSelector))
  add(query_580523, "limit", newJInt(limit))
  result = call_580521.call(path_580522, query_580523, nil, nil, nil)

var runProjectsLocationsConfigurationsList* = Call_RunProjectsLocationsConfigurationsList_580498(
    name: "runProjectsLocationsConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsList_580499, base: "/",
    url: url_RunProjectsLocationsConfigurationsList_580500,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsCreate_580550 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsDomainmappingsCreate_580552(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsCreate_580551(path: JsonNode;
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
  var valid_580553 = path.getOrDefault("parent")
  valid_580553 = validateParameter(valid_580553, JString, required = true,
                                 default = nil)
  if valid_580553 != nil:
    section.add "parent", valid_580553
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
  var valid_580554 = query.getOrDefault("upload_protocol")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "upload_protocol", valid_580554
  var valid_580555 = query.getOrDefault("fields")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "fields", valid_580555
  var valid_580556 = query.getOrDefault("quotaUser")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "quotaUser", valid_580556
  var valid_580557 = query.getOrDefault("alt")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = newJString("json"))
  if valid_580557 != nil:
    section.add "alt", valid_580557
  var valid_580558 = query.getOrDefault("oauth_token")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "oauth_token", valid_580558
  var valid_580559 = query.getOrDefault("callback")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "callback", valid_580559
  var valid_580560 = query.getOrDefault("access_token")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = nil)
  if valid_580560 != nil:
    section.add "access_token", valid_580560
  var valid_580561 = query.getOrDefault("uploadType")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "uploadType", valid_580561
  var valid_580562 = query.getOrDefault("key")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "key", valid_580562
  var valid_580563 = query.getOrDefault("$.xgafv")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = newJString("1"))
  if valid_580563 != nil:
    section.add "$.xgafv", valid_580563
  var valid_580564 = query.getOrDefault("prettyPrint")
  valid_580564 = validateParameter(valid_580564, JBool, required = false,
                                 default = newJBool(true))
  if valid_580564 != nil:
    section.add "prettyPrint", valid_580564
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

proc call*(call_580566: Call_RunProjectsLocationsDomainmappingsCreate_580550;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new domain mapping.
  ## 
  let valid = call_580566.validator(path, query, header, formData, body)
  let scheme = call_580566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580566.url(scheme.get, call_580566.host, call_580566.base,
                         call_580566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580566, url, valid)

proc call*(call_580567: Call_RunProjectsLocationsDomainmappingsCreate_580550;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsDomainmappingsCreate
  ## Creates a new domain mapping.
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
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580568 = newJObject()
  var query_580569 = newJObject()
  var body_580570 = newJObject()
  add(query_580569, "upload_protocol", newJString(uploadProtocol))
  add(query_580569, "fields", newJString(fields))
  add(query_580569, "quotaUser", newJString(quotaUser))
  add(query_580569, "alt", newJString(alt))
  add(query_580569, "oauth_token", newJString(oauthToken))
  add(query_580569, "callback", newJString(callback))
  add(query_580569, "access_token", newJString(accessToken))
  add(query_580569, "uploadType", newJString(uploadType))
  add(path_580568, "parent", newJString(parent))
  add(query_580569, "key", newJString(key))
  add(query_580569, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580570 = body
  add(query_580569, "prettyPrint", newJBool(prettyPrint))
  result = call_580567.call(path_580568, query_580569, nil, nil, body_580570)

var runProjectsLocationsDomainmappingsCreate* = Call_RunProjectsLocationsDomainmappingsCreate_580550(
    name: "runProjectsLocationsDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsCreate_580551,
    base: "/", url: url_RunProjectsLocationsDomainmappingsCreate_580552,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsList_580524 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsDomainmappingsList_580526(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsList_580525(path: JsonNode;
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
  var valid_580527 = path.getOrDefault("parent")
  valid_580527 = validateParameter(valid_580527, JString, required = true,
                                 default = nil)
  if valid_580527 != nil:
    section.add "parent", valid_580527
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580528 = query.getOrDefault("upload_protocol")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "upload_protocol", valid_580528
  var valid_580529 = query.getOrDefault("fields")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "fields", valid_580529
  var valid_580530 = query.getOrDefault("quotaUser")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "quotaUser", valid_580530
  var valid_580531 = query.getOrDefault("includeUninitialized")
  valid_580531 = validateParameter(valid_580531, JBool, required = false, default = nil)
  if valid_580531 != nil:
    section.add "includeUninitialized", valid_580531
  var valid_580532 = query.getOrDefault("alt")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = newJString("json"))
  if valid_580532 != nil:
    section.add "alt", valid_580532
  var valid_580533 = query.getOrDefault("continue")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "continue", valid_580533
  var valid_580534 = query.getOrDefault("oauth_token")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "oauth_token", valid_580534
  var valid_580535 = query.getOrDefault("callback")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "callback", valid_580535
  var valid_580536 = query.getOrDefault("access_token")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "access_token", valid_580536
  var valid_580537 = query.getOrDefault("uploadType")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "uploadType", valid_580537
  var valid_580538 = query.getOrDefault("resourceVersion")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "resourceVersion", valid_580538
  var valid_580539 = query.getOrDefault("watch")
  valid_580539 = validateParameter(valid_580539, JBool, required = false, default = nil)
  if valid_580539 != nil:
    section.add "watch", valid_580539
  var valid_580540 = query.getOrDefault("key")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = nil)
  if valid_580540 != nil:
    section.add "key", valid_580540
  var valid_580541 = query.getOrDefault("$.xgafv")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = newJString("1"))
  if valid_580541 != nil:
    section.add "$.xgafv", valid_580541
  var valid_580542 = query.getOrDefault("labelSelector")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = nil)
  if valid_580542 != nil:
    section.add "labelSelector", valid_580542
  var valid_580543 = query.getOrDefault("prettyPrint")
  valid_580543 = validateParameter(valid_580543, JBool, required = false,
                                 default = newJBool(true))
  if valid_580543 != nil:
    section.add "prettyPrint", valid_580543
  var valid_580544 = query.getOrDefault("fieldSelector")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "fieldSelector", valid_580544
  var valid_580545 = query.getOrDefault("limit")
  valid_580545 = validateParameter(valid_580545, JInt, required = false, default = nil)
  if valid_580545 != nil:
    section.add "limit", valid_580545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580546: Call_RunProjectsLocationsDomainmappingsList_580524;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list domain mappings.
  ## 
  let valid = call_580546.validator(path, query, header, formData, body)
  let scheme = call_580546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580546.url(scheme.get, call_580546.host, call_580546.base,
                         call_580546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580546, url, valid)

proc call*(call_580547: Call_RunProjectsLocationsDomainmappingsList_580524;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsDomainmappingsList
  ## Rpc to list domain mappings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580548 = newJObject()
  var query_580549 = newJObject()
  add(query_580549, "upload_protocol", newJString(uploadProtocol))
  add(query_580549, "fields", newJString(fields))
  add(query_580549, "quotaUser", newJString(quotaUser))
  add(query_580549, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580549, "alt", newJString(alt))
  add(query_580549, "continue", newJString(`continue`))
  add(query_580549, "oauth_token", newJString(oauthToken))
  add(query_580549, "callback", newJString(callback))
  add(query_580549, "access_token", newJString(accessToken))
  add(query_580549, "uploadType", newJString(uploadType))
  add(path_580548, "parent", newJString(parent))
  add(query_580549, "resourceVersion", newJString(resourceVersion))
  add(query_580549, "watch", newJBool(watch))
  add(query_580549, "key", newJString(key))
  add(query_580549, "$.xgafv", newJString(Xgafv))
  add(query_580549, "labelSelector", newJString(labelSelector))
  add(query_580549, "prettyPrint", newJBool(prettyPrint))
  add(query_580549, "fieldSelector", newJString(fieldSelector))
  add(query_580549, "limit", newJInt(limit))
  result = call_580547.call(path_580548, query_580549, nil, nil, nil)

var runProjectsLocationsDomainmappingsList* = Call_RunProjectsLocationsDomainmappingsList_580524(
    name: "runProjectsLocationsDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsList_580525, base: "/",
    url: url_RunProjectsLocationsDomainmappingsList_580526,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsEventtypesList_580571 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsEventtypesList_580573(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsEventtypesList_580572(path: JsonNode;
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
  var valid_580574 = path.getOrDefault("parent")
  valid_580574 = validateParameter(valid_580574, JString, required = true,
                                 default = nil)
  if valid_580574 != nil:
    section.add "parent", valid_580574
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580575 = query.getOrDefault("upload_protocol")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = nil)
  if valid_580575 != nil:
    section.add "upload_protocol", valid_580575
  var valid_580576 = query.getOrDefault("fields")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "fields", valid_580576
  var valid_580577 = query.getOrDefault("quotaUser")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "quotaUser", valid_580577
  var valid_580578 = query.getOrDefault("includeUninitialized")
  valid_580578 = validateParameter(valid_580578, JBool, required = false, default = nil)
  if valid_580578 != nil:
    section.add "includeUninitialized", valid_580578
  var valid_580579 = query.getOrDefault("alt")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = newJString("json"))
  if valid_580579 != nil:
    section.add "alt", valid_580579
  var valid_580580 = query.getOrDefault("continue")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "continue", valid_580580
  var valid_580581 = query.getOrDefault("oauth_token")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "oauth_token", valid_580581
  var valid_580582 = query.getOrDefault("callback")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "callback", valid_580582
  var valid_580583 = query.getOrDefault("access_token")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "access_token", valid_580583
  var valid_580584 = query.getOrDefault("uploadType")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "uploadType", valid_580584
  var valid_580585 = query.getOrDefault("resourceVersion")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "resourceVersion", valid_580585
  var valid_580586 = query.getOrDefault("watch")
  valid_580586 = validateParameter(valid_580586, JBool, required = false, default = nil)
  if valid_580586 != nil:
    section.add "watch", valid_580586
  var valid_580587 = query.getOrDefault("key")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "key", valid_580587
  var valid_580588 = query.getOrDefault("$.xgafv")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = newJString("1"))
  if valid_580588 != nil:
    section.add "$.xgafv", valid_580588
  var valid_580589 = query.getOrDefault("labelSelector")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "labelSelector", valid_580589
  var valid_580590 = query.getOrDefault("prettyPrint")
  valid_580590 = validateParameter(valid_580590, JBool, required = false,
                                 default = newJBool(true))
  if valid_580590 != nil:
    section.add "prettyPrint", valid_580590
  var valid_580591 = query.getOrDefault("fieldSelector")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "fieldSelector", valid_580591
  var valid_580592 = query.getOrDefault("limit")
  valid_580592 = validateParameter(valid_580592, JInt, required = false, default = nil)
  if valid_580592 != nil:
    section.add "limit", valid_580592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580593: Call_RunProjectsLocationsEventtypesList_580571;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list EventTypes.
  ## 
  let valid = call_580593.validator(path, query, header, formData, body)
  let scheme = call_580593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580593.url(scheme.get, call_580593.host, call_580593.base,
                         call_580593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580593, url, valid)

proc call*(call_580594: Call_RunProjectsLocationsEventtypesList_580571;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsEventtypesList
  ## Rpc to list EventTypes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the EventTypes should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580595 = newJObject()
  var query_580596 = newJObject()
  add(query_580596, "upload_protocol", newJString(uploadProtocol))
  add(query_580596, "fields", newJString(fields))
  add(query_580596, "quotaUser", newJString(quotaUser))
  add(query_580596, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580596, "alt", newJString(alt))
  add(query_580596, "continue", newJString(`continue`))
  add(query_580596, "oauth_token", newJString(oauthToken))
  add(query_580596, "callback", newJString(callback))
  add(query_580596, "access_token", newJString(accessToken))
  add(query_580596, "uploadType", newJString(uploadType))
  add(path_580595, "parent", newJString(parent))
  add(query_580596, "resourceVersion", newJString(resourceVersion))
  add(query_580596, "watch", newJBool(watch))
  add(query_580596, "key", newJString(key))
  add(query_580596, "$.xgafv", newJString(Xgafv))
  add(query_580596, "labelSelector", newJString(labelSelector))
  add(query_580596, "prettyPrint", newJBool(prettyPrint))
  add(query_580596, "fieldSelector", newJString(fieldSelector))
  add(query_580596, "limit", newJInt(limit))
  result = call_580594.call(path_580595, query_580596, nil, nil, nil)

var runProjectsLocationsEventtypesList* = Call_RunProjectsLocationsEventtypesList_580571(
    name: "runProjectsLocationsEventtypesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/eventtypes",
    validator: validate_RunProjectsLocationsEventtypesList_580572, base: "/",
    url: url_RunProjectsLocationsEventtypesList_580573, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRevisionsList_580597 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsRevisionsList_580599(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsRevisionsList_580598(path: JsonNode;
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
  var valid_580600 = path.getOrDefault("parent")
  valid_580600 = validateParameter(valid_580600, JString, required = true,
                                 default = nil)
  if valid_580600 != nil:
    section.add "parent", valid_580600
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580601 = query.getOrDefault("upload_protocol")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "upload_protocol", valid_580601
  var valid_580602 = query.getOrDefault("fields")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = nil)
  if valid_580602 != nil:
    section.add "fields", valid_580602
  var valid_580603 = query.getOrDefault("quotaUser")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "quotaUser", valid_580603
  var valid_580604 = query.getOrDefault("includeUninitialized")
  valid_580604 = validateParameter(valid_580604, JBool, required = false, default = nil)
  if valid_580604 != nil:
    section.add "includeUninitialized", valid_580604
  var valid_580605 = query.getOrDefault("alt")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = newJString("json"))
  if valid_580605 != nil:
    section.add "alt", valid_580605
  var valid_580606 = query.getOrDefault("continue")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "continue", valid_580606
  var valid_580607 = query.getOrDefault("oauth_token")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "oauth_token", valid_580607
  var valid_580608 = query.getOrDefault("callback")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "callback", valid_580608
  var valid_580609 = query.getOrDefault("access_token")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "access_token", valid_580609
  var valid_580610 = query.getOrDefault("uploadType")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "uploadType", valid_580610
  var valid_580611 = query.getOrDefault("resourceVersion")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "resourceVersion", valid_580611
  var valid_580612 = query.getOrDefault("watch")
  valid_580612 = validateParameter(valid_580612, JBool, required = false, default = nil)
  if valid_580612 != nil:
    section.add "watch", valid_580612
  var valid_580613 = query.getOrDefault("key")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "key", valid_580613
  var valid_580614 = query.getOrDefault("$.xgafv")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = newJString("1"))
  if valid_580614 != nil:
    section.add "$.xgafv", valid_580614
  var valid_580615 = query.getOrDefault("labelSelector")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "labelSelector", valid_580615
  var valid_580616 = query.getOrDefault("prettyPrint")
  valid_580616 = validateParameter(valid_580616, JBool, required = false,
                                 default = newJBool(true))
  if valid_580616 != nil:
    section.add "prettyPrint", valid_580616
  var valid_580617 = query.getOrDefault("fieldSelector")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "fieldSelector", valid_580617
  var valid_580618 = query.getOrDefault("limit")
  valid_580618 = validateParameter(valid_580618, JInt, required = false, default = nil)
  if valid_580618 != nil:
    section.add "limit", valid_580618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580619: Call_RunProjectsLocationsRevisionsList_580597;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list revisions.
  ## 
  let valid = call_580619.validator(path, query, header, formData, body)
  let scheme = call_580619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580619.url(scheme.get, call_580619.host, call_580619.base,
                         call_580619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580619, url, valid)

proc call*(call_580620: Call_RunProjectsLocationsRevisionsList_580597;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsRevisionsList
  ## Rpc to list revisions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the revisions should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580621 = newJObject()
  var query_580622 = newJObject()
  add(query_580622, "upload_protocol", newJString(uploadProtocol))
  add(query_580622, "fields", newJString(fields))
  add(query_580622, "quotaUser", newJString(quotaUser))
  add(query_580622, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580622, "alt", newJString(alt))
  add(query_580622, "continue", newJString(`continue`))
  add(query_580622, "oauth_token", newJString(oauthToken))
  add(query_580622, "callback", newJString(callback))
  add(query_580622, "access_token", newJString(accessToken))
  add(query_580622, "uploadType", newJString(uploadType))
  add(path_580621, "parent", newJString(parent))
  add(query_580622, "resourceVersion", newJString(resourceVersion))
  add(query_580622, "watch", newJBool(watch))
  add(query_580622, "key", newJString(key))
  add(query_580622, "$.xgafv", newJString(Xgafv))
  add(query_580622, "labelSelector", newJString(labelSelector))
  add(query_580622, "prettyPrint", newJBool(prettyPrint))
  add(query_580622, "fieldSelector", newJString(fieldSelector))
  add(query_580622, "limit", newJInt(limit))
  result = call_580620.call(path_580621, query_580622, nil, nil, nil)

var runProjectsLocationsRevisionsList* = Call_RunProjectsLocationsRevisionsList_580597(
    name: "runProjectsLocationsRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/revisions",
    validator: validate_RunProjectsLocationsRevisionsList_580598, base: "/",
    url: url_RunProjectsLocationsRevisionsList_580599, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesList_580623 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsRoutesList_580625(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsRoutesList_580624(path: JsonNode;
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
  var valid_580626 = path.getOrDefault("parent")
  valid_580626 = validateParameter(valid_580626, JString, required = true,
                                 default = nil)
  if valid_580626 != nil:
    section.add "parent", valid_580626
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580627 = query.getOrDefault("upload_protocol")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "upload_protocol", valid_580627
  var valid_580628 = query.getOrDefault("fields")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "fields", valid_580628
  var valid_580629 = query.getOrDefault("quotaUser")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "quotaUser", valid_580629
  var valid_580630 = query.getOrDefault("includeUninitialized")
  valid_580630 = validateParameter(valid_580630, JBool, required = false, default = nil)
  if valid_580630 != nil:
    section.add "includeUninitialized", valid_580630
  var valid_580631 = query.getOrDefault("alt")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = newJString("json"))
  if valid_580631 != nil:
    section.add "alt", valid_580631
  var valid_580632 = query.getOrDefault("continue")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "continue", valid_580632
  var valid_580633 = query.getOrDefault("oauth_token")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "oauth_token", valid_580633
  var valid_580634 = query.getOrDefault("callback")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "callback", valid_580634
  var valid_580635 = query.getOrDefault("access_token")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "access_token", valid_580635
  var valid_580636 = query.getOrDefault("uploadType")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "uploadType", valid_580636
  var valid_580637 = query.getOrDefault("resourceVersion")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "resourceVersion", valid_580637
  var valid_580638 = query.getOrDefault("watch")
  valid_580638 = validateParameter(valid_580638, JBool, required = false, default = nil)
  if valid_580638 != nil:
    section.add "watch", valid_580638
  var valid_580639 = query.getOrDefault("key")
  valid_580639 = validateParameter(valid_580639, JString, required = false,
                                 default = nil)
  if valid_580639 != nil:
    section.add "key", valid_580639
  var valid_580640 = query.getOrDefault("$.xgafv")
  valid_580640 = validateParameter(valid_580640, JString, required = false,
                                 default = newJString("1"))
  if valid_580640 != nil:
    section.add "$.xgafv", valid_580640
  var valid_580641 = query.getOrDefault("labelSelector")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "labelSelector", valid_580641
  var valid_580642 = query.getOrDefault("prettyPrint")
  valid_580642 = validateParameter(valid_580642, JBool, required = false,
                                 default = newJBool(true))
  if valid_580642 != nil:
    section.add "prettyPrint", valid_580642
  var valid_580643 = query.getOrDefault("fieldSelector")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "fieldSelector", valid_580643
  var valid_580644 = query.getOrDefault("limit")
  valid_580644 = validateParameter(valid_580644, JInt, required = false, default = nil)
  if valid_580644 != nil:
    section.add "limit", valid_580644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580645: Call_RunProjectsLocationsRoutesList_580623; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list routes.
  ## 
  let valid = call_580645.validator(path, query, header, formData, body)
  let scheme = call_580645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580645.url(scheme.get, call_580645.host, call_580645.base,
                         call_580645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580645, url, valid)

proc call*(call_580646: Call_RunProjectsLocationsRoutesList_580623; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsRoutesList
  ## Rpc to list routes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the routes should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580647 = newJObject()
  var query_580648 = newJObject()
  add(query_580648, "upload_protocol", newJString(uploadProtocol))
  add(query_580648, "fields", newJString(fields))
  add(query_580648, "quotaUser", newJString(quotaUser))
  add(query_580648, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580648, "alt", newJString(alt))
  add(query_580648, "continue", newJString(`continue`))
  add(query_580648, "oauth_token", newJString(oauthToken))
  add(query_580648, "callback", newJString(callback))
  add(query_580648, "access_token", newJString(accessToken))
  add(query_580648, "uploadType", newJString(uploadType))
  add(path_580647, "parent", newJString(parent))
  add(query_580648, "resourceVersion", newJString(resourceVersion))
  add(query_580648, "watch", newJBool(watch))
  add(query_580648, "key", newJString(key))
  add(query_580648, "$.xgafv", newJString(Xgafv))
  add(query_580648, "labelSelector", newJString(labelSelector))
  add(query_580648, "prettyPrint", newJBool(prettyPrint))
  add(query_580648, "fieldSelector", newJString(fieldSelector))
  add(query_580648, "limit", newJInt(limit))
  result = call_580646.call(path_580647, query_580648, nil, nil, nil)

var runProjectsLocationsRoutesList* = Call_RunProjectsLocationsRoutesList_580623(
    name: "runProjectsLocationsRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesList_580624, base: "/",
    url: url_RunProjectsLocationsRoutesList_580625, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesCreate_580675 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsServicesCreate_580677(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesCreate_580676(path: JsonNode;
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
  var valid_580678 = path.getOrDefault("parent")
  valid_580678 = validateParameter(valid_580678, JString, required = true,
                                 default = nil)
  if valid_580678 != nil:
    section.add "parent", valid_580678
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
  var valid_580679 = query.getOrDefault("upload_protocol")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = nil)
  if valid_580679 != nil:
    section.add "upload_protocol", valid_580679
  var valid_580680 = query.getOrDefault("fields")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "fields", valid_580680
  var valid_580681 = query.getOrDefault("quotaUser")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = nil)
  if valid_580681 != nil:
    section.add "quotaUser", valid_580681
  var valid_580682 = query.getOrDefault("alt")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = newJString("json"))
  if valid_580682 != nil:
    section.add "alt", valid_580682
  var valid_580683 = query.getOrDefault("oauth_token")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "oauth_token", valid_580683
  var valid_580684 = query.getOrDefault("callback")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "callback", valid_580684
  var valid_580685 = query.getOrDefault("access_token")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = nil)
  if valid_580685 != nil:
    section.add "access_token", valid_580685
  var valid_580686 = query.getOrDefault("uploadType")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = nil)
  if valid_580686 != nil:
    section.add "uploadType", valid_580686
  var valid_580687 = query.getOrDefault("key")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = nil)
  if valid_580687 != nil:
    section.add "key", valid_580687
  var valid_580688 = query.getOrDefault("$.xgafv")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = newJString("1"))
  if valid_580688 != nil:
    section.add "$.xgafv", valid_580688
  var valid_580689 = query.getOrDefault("prettyPrint")
  valid_580689 = validateParameter(valid_580689, JBool, required = false,
                                 default = newJBool(true))
  if valid_580689 != nil:
    section.add "prettyPrint", valid_580689
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

proc call*(call_580691: Call_RunProjectsLocationsServicesCreate_580675;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to create a service.
  ## 
  let valid = call_580691.validator(path, query, header, formData, body)
  let scheme = call_580691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580691.url(scheme.get, call_580691.host, call_580691.base,
                         call_580691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580691, url, valid)

proc call*(call_580692: Call_RunProjectsLocationsServicesCreate_580675;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesCreate
  ## Rpc to create a service.
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
  ##         : The project ID or project number in which this service should be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580693 = newJObject()
  var query_580694 = newJObject()
  var body_580695 = newJObject()
  add(query_580694, "upload_protocol", newJString(uploadProtocol))
  add(query_580694, "fields", newJString(fields))
  add(query_580694, "quotaUser", newJString(quotaUser))
  add(query_580694, "alt", newJString(alt))
  add(query_580694, "oauth_token", newJString(oauthToken))
  add(query_580694, "callback", newJString(callback))
  add(query_580694, "access_token", newJString(accessToken))
  add(query_580694, "uploadType", newJString(uploadType))
  add(path_580693, "parent", newJString(parent))
  add(query_580694, "key", newJString(key))
  add(query_580694, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580695 = body
  add(query_580694, "prettyPrint", newJBool(prettyPrint))
  result = call_580692.call(path_580693, query_580694, nil, nil, body_580695)

var runProjectsLocationsServicesCreate* = Call_RunProjectsLocationsServicesCreate_580675(
    name: "runProjectsLocationsServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesCreate_580676, base: "/",
    url: url_RunProjectsLocationsServicesCreate_580677, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesList_580649 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsServicesList_580651(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesList_580650(path: JsonNode;
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
  var valid_580652 = path.getOrDefault("parent")
  valid_580652 = validateParameter(valid_580652, JString, required = true,
                                 default = nil)
  if valid_580652 != nil:
    section.add "parent", valid_580652
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580653 = query.getOrDefault("upload_protocol")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "upload_protocol", valid_580653
  var valid_580654 = query.getOrDefault("fields")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "fields", valid_580654
  var valid_580655 = query.getOrDefault("quotaUser")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "quotaUser", valid_580655
  var valid_580656 = query.getOrDefault("includeUninitialized")
  valid_580656 = validateParameter(valid_580656, JBool, required = false, default = nil)
  if valid_580656 != nil:
    section.add "includeUninitialized", valid_580656
  var valid_580657 = query.getOrDefault("alt")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = newJString("json"))
  if valid_580657 != nil:
    section.add "alt", valid_580657
  var valid_580658 = query.getOrDefault("continue")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = nil)
  if valid_580658 != nil:
    section.add "continue", valid_580658
  var valid_580659 = query.getOrDefault("oauth_token")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "oauth_token", valid_580659
  var valid_580660 = query.getOrDefault("callback")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "callback", valid_580660
  var valid_580661 = query.getOrDefault("access_token")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "access_token", valid_580661
  var valid_580662 = query.getOrDefault("uploadType")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "uploadType", valid_580662
  var valid_580663 = query.getOrDefault("resourceVersion")
  valid_580663 = validateParameter(valid_580663, JString, required = false,
                                 default = nil)
  if valid_580663 != nil:
    section.add "resourceVersion", valid_580663
  var valid_580664 = query.getOrDefault("watch")
  valid_580664 = validateParameter(valid_580664, JBool, required = false, default = nil)
  if valid_580664 != nil:
    section.add "watch", valid_580664
  var valid_580665 = query.getOrDefault("key")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = nil)
  if valid_580665 != nil:
    section.add "key", valid_580665
  var valid_580666 = query.getOrDefault("$.xgafv")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = newJString("1"))
  if valid_580666 != nil:
    section.add "$.xgafv", valid_580666
  var valid_580667 = query.getOrDefault("labelSelector")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "labelSelector", valid_580667
  var valid_580668 = query.getOrDefault("prettyPrint")
  valid_580668 = validateParameter(valid_580668, JBool, required = false,
                                 default = newJBool(true))
  if valid_580668 != nil:
    section.add "prettyPrint", valid_580668
  var valid_580669 = query.getOrDefault("fieldSelector")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "fieldSelector", valid_580669
  var valid_580670 = query.getOrDefault("limit")
  valid_580670 = validateParameter(valid_580670, JInt, required = false, default = nil)
  if valid_580670 != nil:
    section.add "limit", valid_580670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580671: Call_RunProjectsLocationsServicesList_580649;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list services.
  ## 
  let valid = call_580671.validator(path, query, header, formData, body)
  let scheme = call_580671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580671.url(scheme.get, call_580671.host, call_580671.base,
                         call_580671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580671, url, valid)

proc call*(call_580672: Call_RunProjectsLocationsServicesList_580649;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsServicesList
  ## Rpc to list services.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the services should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580673 = newJObject()
  var query_580674 = newJObject()
  add(query_580674, "upload_protocol", newJString(uploadProtocol))
  add(query_580674, "fields", newJString(fields))
  add(query_580674, "quotaUser", newJString(quotaUser))
  add(query_580674, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580674, "alt", newJString(alt))
  add(query_580674, "continue", newJString(`continue`))
  add(query_580674, "oauth_token", newJString(oauthToken))
  add(query_580674, "callback", newJString(callback))
  add(query_580674, "access_token", newJString(accessToken))
  add(query_580674, "uploadType", newJString(uploadType))
  add(path_580673, "parent", newJString(parent))
  add(query_580674, "resourceVersion", newJString(resourceVersion))
  add(query_580674, "watch", newJBool(watch))
  add(query_580674, "key", newJString(key))
  add(query_580674, "$.xgafv", newJString(Xgafv))
  add(query_580674, "labelSelector", newJString(labelSelector))
  add(query_580674, "prettyPrint", newJBool(prettyPrint))
  add(query_580674, "fieldSelector", newJString(fieldSelector))
  add(query_580674, "limit", newJInt(limit))
  result = call_580672.call(path_580673, query_580674, nil, nil, nil)

var runProjectsLocationsServicesList* = Call_RunProjectsLocationsServicesList_580649(
    name: "runProjectsLocationsServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesList_580650, base: "/",
    url: url_RunProjectsLocationsServicesList_580651, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsTriggersCreate_580722 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsTriggersCreate_580724(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsTriggersCreate_580723(path: JsonNode;
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
  var valid_580725 = path.getOrDefault("parent")
  valid_580725 = validateParameter(valid_580725, JString, required = true,
                                 default = nil)
  if valid_580725 != nil:
    section.add "parent", valid_580725
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
  var valid_580726 = query.getOrDefault("upload_protocol")
  valid_580726 = validateParameter(valid_580726, JString, required = false,
                                 default = nil)
  if valid_580726 != nil:
    section.add "upload_protocol", valid_580726
  var valid_580727 = query.getOrDefault("fields")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = nil)
  if valid_580727 != nil:
    section.add "fields", valid_580727
  var valid_580728 = query.getOrDefault("quotaUser")
  valid_580728 = validateParameter(valid_580728, JString, required = false,
                                 default = nil)
  if valid_580728 != nil:
    section.add "quotaUser", valid_580728
  var valid_580729 = query.getOrDefault("alt")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = newJString("json"))
  if valid_580729 != nil:
    section.add "alt", valid_580729
  var valid_580730 = query.getOrDefault("oauth_token")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "oauth_token", valid_580730
  var valid_580731 = query.getOrDefault("callback")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = nil)
  if valid_580731 != nil:
    section.add "callback", valid_580731
  var valid_580732 = query.getOrDefault("access_token")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "access_token", valid_580732
  var valid_580733 = query.getOrDefault("uploadType")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "uploadType", valid_580733
  var valid_580734 = query.getOrDefault("key")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "key", valid_580734
  var valid_580735 = query.getOrDefault("$.xgafv")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = newJString("1"))
  if valid_580735 != nil:
    section.add "$.xgafv", valid_580735
  var valid_580736 = query.getOrDefault("prettyPrint")
  valid_580736 = validateParameter(valid_580736, JBool, required = false,
                                 default = newJBool(true))
  if valid_580736 != nil:
    section.add "prettyPrint", valid_580736
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

proc call*(call_580738: Call_RunProjectsLocationsTriggersCreate_580722;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new trigger.
  ## 
  let valid = call_580738.validator(path, query, header, formData, body)
  let scheme = call_580738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580738.url(scheme.get, call_580738.host, call_580738.base,
                         call_580738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580738, url, valid)

proc call*(call_580739: Call_RunProjectsLocationsTriggersCreate_580722;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsTriggersCreate
  ## Creates a new trigger.
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
  ##         : The project ID or project number in which this trigger should
  ## be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580740 = newJObject()
  var query_580741 = newJObject()
  var body_580742 = newJObject()
  add(query_580741, "upload_protocol", newJString(uploadProtocol))
  add(query_580741, "fields", newJString(fields))
  add(query_580741, "quotaUser", newJString(quotaUser))
  add(query_580741, "alt", newJString(alt))
  add(query_580741, "oauth_token", newJString(oauthToken))
  add(query_580741, "callback", newJString(callback))
  add(query_580741, "access_token", newJString(accessToken))
  add(query_580741, "uploadType", newJString(uploadType))
  add(path_580740, "parent", newJString(parent))
  add(query_580741, "key", newJString(key))
  add(query_580741, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580742 = body
  add(query_580741, "prettyPrint", newJBool(prettyPrint))
  result = call_580739.call(path_580740, query_580741, nil, nil, body_580742)

var runProjectsLocationsTriggersCreate* = Call_RunProjectsLocationsTriggersCreate_580722(
    name: "runProjectsLocationsTriggersCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/triggers",
    validator: validate_RunProjectsLocationsTriggersCreate_580723, base: "/",
    url: url_RunProjectsLocationsTriggersCreate_580724, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsTriggersList_580696 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsTriggersList_580698(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsTriggersList_580697(path: JsonNode;
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
  var valid_580699 = path.getOrDefault("parent")
  valid_580699 = validateParameter(valid_580699, JString, required = true,
                                 default = nil)
  if valid_580699 != nil:
    section.add "parent", valid_580699
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580700 = query.getOrDefault("upload_protocol")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "upload_protocol", valid_580700
  var valid_580701 = query.getOrDefault("fields")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "fields", valid_580701
  var valid_580702 = query.getOrDefault("quotaUser")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "quotaUser", valid_580702
  var valid_580703 = query.getOrDefault("includeUninitialized")
  valid_580703 = validateParameter(valid_580703, JBool, required = false, default = nil)
  if valid_580703 != nil:
    section.add "includeUninitialized", valid_580703
  var valid_580704 = query.getOrDefault("alt")
  valid_580704 = validateParameter(valid_580704, JString, required = false,
                                 default = newJString("json"))
  if valid_580704 != nil:
    section.add "alt", valid_580704
  var valid_580705 = query.getOrDefault("continue")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "continue", valid_580705
  var valid_580706 = query.getOrDefault("oauth_token")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "oauth_token", valid_580706
  var valid_580707 = query.getOrDefault("callback")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = nil)
  if valid_580707 != nil:
    section.add "callback", valid_580707
  var valid_580708 = query.getOrDefault("access_token")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "access_token", valid_580708
  var valid_580709 = query.getOrDefault("uploadType")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = nil)
  if valid_580709 != nil:
    section.add "uploadType", valid_580709
  var valid_580710 = query.getOrDefault("resourceVersion")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = nil)
  if valid_580710 != nil:
    section.add "resourceVersion", valid_580710
  var valid_580711 = query.getOrDefault("watch")
  valid_580711 = validateParameter(valid_580711, JBool, required = false, default = nil)
  if valid_580711 != nil:
    section.add "watch", valid_580711
  var valid_580712 = query.getOrDefault("key")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "key", valid_580712
  var valid_580713 = query.getOrDefault("$.xgafv")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = newJString("1"))
  if valid_580713 != nil:
    section.add "$.xgafv", valid_580713
  var valid_580714 = query.getOrDefault("labelSelector")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "labelSelector", valid_580714
  var valid_580715 = query.getOrDefault("prettyPrint")
  valid_580715 = validateParameter(valid_580715, JBool, required = false,
                                 default = newJBool(true))
  if valid_580715 != nil:
    section.add "prettyPrint", valid_580715
  var valid_580716 = query.getOrDefault("fieldSelector")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "fieldSelector", valid_580716
  var valid_580717 = query.getOrDefault("limit")
  valid_580717 = validateParameter(valid_580717, JInt, required = false, default = nil)
  if valid_580717 != nil:
    section.add "limit", valid_580717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580718: Call_RunProjectsLocationsTriggersList_580696;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list triggers.
  ## 
  let valid = call_580718.validator(path, query, header, formData, body)
  let scheme = call_580718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580718.url(scheme.get, call_580718.host, call_580718.base,
                         call_580718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580718, url, valid)

proc call*(call_580719: Call_RunProjectsLocationsTriggersList_580696;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsTriggersList
  ## Rpc to list triggers.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the triggers should
  ## be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580720 = newJObject()
  var query_580721 = newJObject()
  add(query_580721, "upload_protocol", newJString(uploadProtocol))
  add(query_580721, "fields", newJString(fields))
  add(query_580721, "quotaUser", newJString(quotaUser))
  add(query_580721, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580721, "alt", newJString(alt))
  add(query_580721, "continue", newJString(`continue`))
  add(query_580721, "oauth_token", newJString(oauthToken))
  add(query_580721, "callback", newJString(callback))
  add(query_580721, "access_token", newJString(accessToken))
  add(query_580721, "uploadType", newJString(uploadType))
  add(path_580720, "parent", newJString(parent))
  add(query_580721, "resourceVersion", newJString(resourceVersion))
  add(query_580721, "watch", newJBool(watch))
  add(query_580721, "key", newJString(key))
  add(query_580721, "$.xgafv", newJString(Xgafv))
  add(query_580721, "labelSelector", newJString(labelSelector))
  add(query_580721, "prettyPrint", newJBool(prettyPrint))
  add(query_580721, "fieldSelector", newJString(fieldSelector))
  add(query_580721, "limit", newJInt(limit))
  result = call_580719.call(path_580720, query_580721, nil, nil, nil)

var runProjectsLocationsTriggersList* = Call_RunProjectsLocationsTriggersList_580696(
    name: "runProjectsLocationsTriggersList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/triggers",
    validator: validate_RunProjectsLocationsTriggersList_580697, base: "/",
    url: url_RunProjectsLocationsTriggersList_580698, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesGetIamPolicy_580743 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsServicesGetIamPolicy_580745(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesGetIamPolicy_580744(path: JsonNode;
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
  var valid_580746 = path.getOrDefault("resource")
  valid_580746 = validateParameter(valid_580746, JString, required = true,
                                 default = nil)
  if valid_580746 != nil:
    section.add "resource", valid_580746
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580747 = query.getOrDefault("upload_protocol")
  valid_580747 = validateParameter(valid_580747, JString, required = false,
                                 default = nil)
  if valid_580747 != nil:
    section.add "upload_protocol", valid_580747
  var valid_580748 = query.getOrDefault("fields")
  valid_580748 = validateParameter(valid_580748, JString, required = false,
                                 default = nil)
  if valid_580748 != nil:
    section.add "fields", valid_580748
  var valid_580749 = query.getOrDefault("quotaUser")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "quotaUser", valid_580749
  var valid_580750 = query.getOrDefault("alt")
  valid_580750 = validateParameter(valid_580750, JString, required = false,
                                 default = newJString("json"))
  if valid_580750 != nil:
    section.add "alt", valid_580750
  var valid_580751 = query.getOrDefault("oauth_token")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "oauth_token", valid_580751
  var valid_580752 = query.getOrDefault("callback")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "callback", valid_580752
  var valid_580753 = query.getOrDefault("access_token")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "access_token", valid_580753
  var valid_580754 = query.getOrDefault("uploadType")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "uploadType", valid_580754
  var valid_580755 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580755 = validateParameter(valid_580755, JInt, required = false, default = nil)
  if valid_580755 != nil:
    section.add "options.requestedPolicyVersion", valid_580755
  var valid_580756 = query.getOrDefault("key")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = nil)
  if valid_580756 != nil:
    section.add "key", valid_580756
  var valid_580757 = query.getOrDefault("$.xgafv")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = newJString("1"))
  if valid_580757 != nil:
    section.add "$.xgafv", valid_580757
  var valid_580758 = query.getOrDefault("prettyPrint")
  valid_580758 = validateParameter(valid_580758, JBool, required = false,
                                 default = newJBool(true))
  if valid_580758 != nil:
    section.add "prettyPrint", valid_580758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580759: Call_RunProjectsLocationsServicesGetIamPolicy_580743;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  let valid = call_580759.validator(path, query, header, formData, body)
  let scheme = call_580759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580759.url(scheme.get, call_580759.host, call_580759.base,
                         call_580759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580759, url, valid)

proc call*(call_580760: Call_RunProjectsLocationsServicesGetIamPolicy_580743;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesGetIamPolicy
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580761 = newJObject()
  var query_580762 = newJObject()
  add(query_580762, "upload_protocol", newJString(uploadProtocol))
  add(query_580762, "fields", newJString(fields))
  add(query_580762, "quotaUser", newJString(quotaUser))
  add(query_580762, "alt", newJString(alt))
  add(query_580762, "oauth_token", newJString(oauthToken))
  add(query_580762, "callback", newJString(callback))
  add(query_580762, "access_token", newJString(accessToken))
  add(query_580762, "uploadType", newJString(uploadType))
  add(query_580762, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580762, "key", newJString(key))
  add(query_580762, "$.xgafv", newJString(Xgafv))
  add(path_580761, "resource", newJString(resource))
  add(query_580762, "prettyPrint", newJBool(prettyPrint))
  result = call_580760.call(path_580761, query_580762, nil, nil, nil)

var runProjectsLocationsServicesGetIamPolicy* = Call_RunProjectsLocationsServicesGetIamPolicy_580743(
    name: "runProjectsLocationsServicesGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_RunProjectsLocationsServicesGetIamPolicy_580744,
    base: "/", url: url_RunProjectsLocationsServicesGetIamPolicy_580745,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesSetIamPolicy_580763 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsServicesSetIamPolicy_580765(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesSetIamPolicy_580764(path: JsonNode;
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
  var valid_580766 = path.getOrDefault("resource")
  valid_580766 = validateParameter(valid_580766, JString, required = true,
                                 default = nil)
  if valid_580766 != nil:
    section.add "resource", valid_580766
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
  var valid_580767 = query.getOrDefault("upload_protocol")
  valid_580767 = validateParameter(valid_580767, JString, required = false,
                                 default = nil)
  if valid_580767 != nil:
    section.add "upload_protocol", valid_580767
  var valid_580768 = query.getOrDefault("fields")
  valid_580768 = validateParameter(valid_580768, JString, required = false,
                                 default = nil)
  if valid_580768 != nil:
    section.add "fields", valid_580768
  var valid_580769 = query.getOrDefault("quotaUser")
  valid_580769 = validateParameter(valid_580769, JString, required = false,
                                 default = nil)
  if valid_580769 != nil:
    section.add "quotaUser", valid_580769
  var valid_580770 = query.getOrDefault("alt")
  valid_580770 = validateParameter(valid_580770, JString, required = false,
                                 default = newJString("json"))
  if valid_580770 != nil:
    section.add "alt", valid_580770
  var valid_580771 = query.getOrDefault("oauth_token")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = nil)
  if valid_580771 != nil:
    section.add "oauth_token", valid_580771
  var valid_580772 = query.getOrDefault("callback")
  valid_580772 = validateParameter(valid_580772, JString, required = false,
                                 default = nil)
  if valid_580772 != nil:
    section.add "callback", valid_580772
  var valid_580773 = query.getOrDefault("access_token")
  valid_580773 = validateParameter(valid_580773, JString, required = false,
                                 default = nil)
  if valid_580773 != nil:
    section.add "access_token", valid_580773
  var valid_580774 = query.getOrDefault("uploadType")
  valid_580774 = validateParameter(valid_580774, JString, required = false,
                                 default = nil)
  if valid_580774 != nil:
    section.add "uploadType", valid_580774
  var valid_580775 = query.getOrDefault("key")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "key", valid_580775
  var valid_580776 = query.getOrDefault("$.xgafv")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = newJString("1"))
  if valid_580776 != nil:
    section.add "$.xgafv", valid_580776
  var valid_580777 = query.getOrDefault("prettyPrint")
  valid_580777 = validateParameter(valid_580777, JBool, required = false,
                                 default = newJBool(true))
  if valid_580777 != nil:
    section.add "prettyPrint", valid_580777
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

proc call*(call_580779: Call_RunProjectsLocationsServicesSetIamPolicy_580763;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  let valid = call_580779.validator(path, query, header, formData, body)
  let scheme = call_580779.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580779.url(scheme.get, call_580779.host, call_580779.base,
                         call_580779.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580779, url, valid)

proc call*(call_580780: Call_RunProjectsLocationsServicesSetIamPolicy_580763;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesSetIamPolicy
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
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
  var path_580781 = newJObject()
  var query_580782 = newJObject()
  var body_580783 = newJObject()
  add(query_580782, "upload_protocol", newJString(uploadProtocol))
  add(query_580782, "fields", newJString(fields))
  add(query_580782, "quotaUser", newJString(quotaUser))
  add(query_580782, "alt", newJString(alt))
  add(query_580782, "oauth_token", newJString(oauthToken))
  add(query_580782, "callback", newJString(callback))
  add(query_580782, "access_token", newJString(accessToken))
  add(query_580782, "uploadType", newJString(uploadType))
  add(query_580782, "key", newJString(key))
  add(query_580782, "$.xgafv", newJString(Xgafv))
  add(path_580781, "resource", newJString(resource))
  if body != nil:
    body_580783 = body
  add(query_580782, "prettyPrint", newJBool(prettyPrint))
  result = call_580780.call(path_580781, query_580782, nil, nil, body_580783)

var runProjectsLocationsServicesSetIamPolicy* = Call_RunProjectsLocationsServicesSetIamPolicy_580763(
    name: "runProjectsLocationsServicesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_RunProjectsLocationsServicesSetIamPolicy_580764,
    base: "/", url: url_RunProjectsLocationsServicesSetIamPolicy_580765,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesTestIamPermissions_580784 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsServicesTestIamPermissions_580786(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesTestIamPermissions_580785(
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
  var valid_580787 = path.getOrDefault("resource")
  valid_580787 = validateParameter(valid_580787, JString, required = true,
                                 default = nil)
  if valid_580787 != nil:
    section.add "resource", valid_580787
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
  var valid_580788 = query.getOrDefault("upload_protocol")
  valid_580788 = validateParameter(valid_580788, JString, required = false,
                                 default = nil)
  if valid_580788 != nil:
    section.add "upload_protocol", valid_580788
  var valid_580789 = query.getOrDefault("fields")
  valid_580789 = validateParameter(valid_580789, JString, required = false,
                                 default = nil)
  if valid_580789 != nil:
    section.add "fields", valid_580789
  var valid_580790 = query.getOrDefault("quotaUser")
  valid_580790 = validateParameter(valid_580790, JString, required = false,
                                 default = nil)
  if valid_580790 != nil:
    section.add "quotaUser", valid_580790
  var valid_580791 = query.getOrDefault("alt")
  valid_580791 = validateParameter(valid_580791, JString, required = false,
                                 default = newJString("json"))
  if valid_580791 != nil:
    section.add "alt", valid_580791
  var valid_580792 = query.getOrDefault("oauth_token")
  valid_580792 = validateParameter(valid_580792, JString, required = false,
                                 default = nil)
  if valid_580792 != nil:
    section.add "oauth_token", valid_580792
  var valid_580793 = query.getOrDefault("callback")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = nil)
  if valid_580793 != nil:
    section.add "callback", valid_580793
  var valid_580794 = query.getOrDefault("access_token")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = nil)
  if valid_580794 != nil:
    section.add "access_token", valid_580794
  var valid_580795 = query.getOrDefault("uploadType")
  valid_580795 = validateParameter(valid_580795, JString, required = false,
                                 default = nil)
  if valid_580795 != nil:
    section.add "uploadType", valid_580795
  var valid_580796 = query.getOrDefault("key")
  valid_580796 = validateParameter(valid_580796, JString, required = false,
                                 default = nil)
  if valid_580796 != nil:
    section.add "key", valid_580796
  var valid_580797 = query.getOrDefault("$.xgafv")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = newJString("1"))
  if valid_580797 != nil:
    section.add "$.xgafv", valid_580797
  var valid_580798 = query.getOrDefault("prettyPrint")
  valid_580798 = validateParameter(valid_580798, JBool, required = false,
                                 default = newJBool(true))
  if valid_580798 != nil:
    section.add "prettyPrint", valid_580798
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

proc call*(call_580800: Call_RunProjectsLocationsServicesTestIamPermissions_580784;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_580800.validator(path, query, header, formData, body)
  let scheme = call_580800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580800.url(scheme.get, call_580800.host, call_580800.base,
                         call_580800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580800, url, valid)

proc call*(call_580801: Call_RunProjectsLocationsServicesTestIamPermissions_580784;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesTestIamPermissions
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
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
  var path_580802 = newJObject()
  var query_580803 = newJObject()
  var body_580804 = newJObject()
  add(query_580803, "upload_protocol", newJString(uploadProtocol))
  add(query_580803, "fields", newJString(fields))
  add(query_580803, "quotaUser", newJString(quotaUser))
  add(query_580803, "alt", newJString(alt))
  add(query_580803, "oauth_token", newJString(oauthToken))
  add(query_580803, "callback", newJString(callback))
  add(query_580803, "access_token", newJString(accessToken))
  add(query_580803, "uploadType", newJString(uploadType))
  add(query_580803, "key", newJString(key))
  add(query_580803, "$.xgafv", newJString(Xgafv))
  add(path_580802, "resource", newJString(resource))
  if body != nil:
    body_580804 = body
  add(query_580803, "prettyPrint", newJBool(prettyPrint))
  result = call_580801.call(path_580802, query_580803, nil, nil, body_580804)

var runProjectsLocationsServicesTestIamPermissions* = Call_RunProjectsLocationsServicesTestIamPermissions_580784(
    name: "runProjectsLocationsServicesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_RunProjectsLocationsServicesTestIamPermissions_580785,
    base: "/", url: url_RunProjectsLocationsServicesTestIamPermissions_580786,
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
