
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "run"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RunNamespacesDomainmappingsGet_593690 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesDomainmappingsGet_593692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesDomainmappingsGet_593691(path: JsonNode;
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
  var valid_593818 = path.getOrDefault("name")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "name", valid_593818
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
  var valid_593819 = query.getOrDefault("upload_protocol")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "upload_protocol", valid_593819
  var valid_593820 = query.getOrDefault("fields")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "fields", valid_593820
  var valid_593821 = query.getOrDefault("quotaUser")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "quotaUser", valid_593821
  var valid_593835 = query.getOrDefault("alt")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = newJString("json"))
  if valid_593835 != nil:
    section.add "alt", valid_593835
  var valid_593836 = query.getOrDefault("oauth_token")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "oauth_token", valid_593836
  var valid_593837 = query.getOrDefault("callback")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "callback", valid_593837
  var valid_593838 = query.getOrDefault("access_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "access_token", valid_593838
  var valid_593839 = query.getOrDefault("uploadType")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "uploadType", valid_593839
  var valid_593840 = query.getOrDefault("key")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "key", valid_593840
  var valid_593841 = query.getOrDefault("$.xgafv")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = newJString("1"))
  if valid_593841 != nil:
    section.add "$.xgafv", valid_593841
  var valid_593842 = query.getOrDefault("prettyPrint")
  valid_593842 = validateParameter(valid_593842, JBool, required = false,
                                 default = newJBool(true))
  if valid_593842 != nil:
    section.add "prettyPrint", valid_593842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593865: Call_RunNamespacesDomainmappingsGet_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a domain mapping.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_RunNamespacesDomainmappingsGet_593690; name: string;
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
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  add(query_593939, "upload_protocol", newJString(uploadProtocol))
  add(query_593939, "fields", newJString(fields))
  add(query_593939, "quotaUser", newJString(quotaUser))
  add(path_593937, "name", newJString(name))
  add(query_593939, "alt", newJString(alt))
  add(query_593939, "oauth_token", newJString(oauthToken))
  add(query_593939, "callback", newJString(callback))
  add(query_593939, "access_token", newJString(accessToken))
  add(query_593939, "uploadType", newJString(uploadType))
  add(query_593939, "key", newJString(key))
  add(query_593939, "$.xgafv", newJString(Xgafv))
  add(query_593939, "prettyPrint", newJBool(prettyPrint))
  result = call_593936.call(path_593937, query_593939, nil, nil, nil)

var runNamespacesDomainmappingsGet* = Call_RunNamespacesDomainmappingsGet_593690(
    name: "runNamespacesDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{name}",
    validator: validate_RunNamespacesDomainmappingsGet_593691, base: "/",
    url: url_RunNamespacesDomainmappingsGet_593692, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsDelete_593978 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesDomainmappingsDelete_593980(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesDomainmappingsDelete_593979(path: JsonNode;
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
  var valid_593981 = path.getOrDefault("name")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "name", valid_593981
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
  var valid_593984 = query.getOrDefault("orphanDependents")
  valid_593984 = validateParameter(valid_593984, JBool, required = false, default = nil)
  if valid_593984 != nil:
    section.add "orphanDependents", valid_593984
  var valid_593985 = query.getOrDefault("quotaUser")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "quotaUser", valid_593985
  var valid_593986 = query.getOrDefault("alt")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = newJString("json"))
  if valid_593986 != nil:
    section.add "alt", valid_593986
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
  var valid_593991 = query.getOrDefault("kind")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "kind", valid_593991
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
  var valid_593995 = query.getOrDefault("propagationPolicy")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "propagationPolicy", valid_593995
  var valid_593996 = query.getOrDefault("apiVersion")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "apiVersion", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_RunNamespacesDomainmappingsDelete_593978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to delete a domain mapping.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_RunNamespacesDomainmappingsDelete_593978;
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
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(query_594000, "upload_protocol", newJString(uploadProtocol))
  add(query_594000, "fields", newJString(fields))
  add(query_594000, "orphanDependents", newJBool(orphanDependents))
  add(query_594000, "quotaUser", newJString(quotaUser))
  add(path_593999, "name", newJString(name))
  add(query_594000, "alt", newJString(alt))
  add(query_594000, "oauth_token", newJString(oauthToken))
  add(query_594000, "callback", newJString(callback))
  add(query_594000, "access_token", newJString(accessToken))
  add(query_594000, "uploadType", newJString(uploadType))
  add(query_594000, "kind", newJString(kind))
  add(query_594000, "key", newJString(key))
  add(query_594000, "$.xgafv", newJString(Xgafv))
  add(query_594000, "prettyPrint", newJBool(prettyPrint))
  add(query_594000, "propagationPolicy", newJString(propagationPolicy))
  add(query_594000, "apiVersion", newJString(apiVersion))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var runNamespacesDomainmappingsDelete* = Call_RunNamespacesDomainmappingsDelete_593978(
    name: "runNamespacesDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{name}",
    validator: validate_RunNamespacesDomainmappingsDelete_593979, base: "/",
    url: url_RunNamespacesDomainmappingsDelete_593980, schemes: {Scheme.Https})
type
  Call_RunNamespacesAuthorizeddomainsList_594001 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesAuthorizeddomainsList_594003(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesAuthorizeddomainsList_594002(path: JsonNode;
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
  var valid_594004 = path.getOrDefault("parent")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "parent", valid_594004
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
  var valid_594005 = query.getOrDefault("upload_protocol")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "upload_protocol", valid_594005
  var valid_594006 = query.getOrDefault("fields")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "fields", valid_594006
  var valid_594007 = query.getOrDefault("pageToken")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "pageToken", valid_594007
  var valid_594008 = query.getOrDefault("quotaUser")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "quotaUser", valid_594008
  var valid_594009 = query.getOrDefault("alt")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = newJString("json"))
  if valid_594009 != nil:
    section.add "alt", valid_594009
  var valid_594010 = query.getOrDefault("oauth_token")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "oauth_token", valid_594010
  var valid_594011 = query.getOrDefault("callback")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "callback", valid_594011
  var valid_594012 = query.getOrDefault("access_token")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "access_token", valid_594012
  var valid_594013 = query.getOrDefault("uploadType")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "uploadType", valid_594013
  var valid_594014 = query.getOrDefault("key")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "key", valid_594014
  var valid_594015 = query.getOrDefault("$.xgafv")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = newJString("1"))
  if valid_594015 != nil:
    section.add "$.xgafv", valid_594015
  var valid_594016 = query.getOrDefault("pageSize")
  valid_594016 = validateParameter(valid_594016, JInt, required = false, default = nil)
  if valid_594016 != nil:
    section.add "pageSize", valid_594016
  var valid_594017 = query.getOrDefault("prettyPrint")
  valid_594017 = validateParameter(valid_594017, JBool, required = false,
                                 default = newJBool(true))
  if valid_594017 != nil:
    section.add "prettyPrint", valid_594017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_RunNamespacesAuthorizeddomainsList_594001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RPC to list authorized domains.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_RunNamespacesAuthorizeddomainsList_594001;
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
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  add(query_594021, "upload_protocol", newJString(uploadProtocol))
  add(query_594021, "fields", newJString(fields))
  add(query_594021, "pageToken", newJString(pageToken))
  add(query_594021, "quotaUser", newJString(quotaUser))
  add(query_594021, "alt", newJString(alt))
  add(query_594021, "oauth_token", newJString(oauthToken))
  add(query_594021, "callback", newJString(callback))
  add(query_594021, "access_token", newJString(accessToken))
  add(query_594021, "uploadType", newJString(uploadType))
  add(path_594020, "parent", newJString(parent))
  add(query_594021, "key", newJString(key))
  add(query_594021, "$.xgafv", newJString(Xgafv))
  add(query_594021, "pageSize", newJInt(pageSize))
  add(query_594021, "prettyPrint", newJBool(prettyPrint))
  result = call_594019.call(path_594020, query_594021, nil, nil, nil)

var runNamespacesAuthorizeddomainsList* = Call_RunNamespacesAuthorizeddomainsList_594001(
    name: "runNamespacesAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/authorizeddomains",
    validator: validate_RunNamespacesAuthorizeddomainsList_594002, base: "/",
    url: url_RunNamespacesAuthorizeddomainsList_594003, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsCreate_594048 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesDomainmappingsCreate_594050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesDomainmappingsCreate_594049(path: JsonNode;
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
  var valid_594054 = query.getOrDefault("quotaUser")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "quotaUser", valid_594054
  var valid_594055 = query.getOrDefault("alt")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = newJString("json"))
  if valid_594055 != nil:
    section.add "alt", valid_594055
  var valid_594056 = query.getOrDefault("oauth_token")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "oauth_token", valid_594056
  var valid_594057 = query.getOrDefault("callback")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "callback", valid_594057
  var valid_594058 = query.getOrDefault("access_token")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "access_token", valid_594058
  var valid_594059 = query.getOrDefault("uploadType")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "uploadType", valid_594059
  var valid_594060 = query.getOrDefault("key")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "key", valid_594060
  var valid_594061 = query.getOrDefault("$.xgafv")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = newJString("1"))
  if valid_594061 != nil:
    section.add "$.xgafv", valid_594061
  var valid_594062 = query.getOrDefault("prettyPrint")
  valid_594062 = validateParameter(valid_594062, JBool, required = false,
                                 default = newJBool(true))
  if valid_594062 != nil:
    section.add "prettyPrint", valid_594062
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

proc call*(call_594064: Call_RunNamespacesDomainmappingsCreate_594048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new domain mapping.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_RunNamespacesDomainmappingsCreate_594048;
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
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  var body_594068 = newJObject()
  add(query_594067, "upload_protocol", newJString(uploadProtocol))
  add(query_594067, "fields", newJString(fields))
  add(query_594067, "quotaUser", newJString(quotaUser))
  add(query_594067, "alt", newJString(alt))
  add(query_594067, "oauth_token", newJString(oauthToken))
  add(query_594067, "callback", newJString(callback))
  add(query_594067, "access_token", newJString(accessToken))
  add(query_594067, "uploadType", newJString(uploadType))
  add(path_594066, "parent", newJString(parent))
  add(query_594067, "key", newJString(key))
  add(query_594067, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594068 = body
  add(query_594067, "prettyPrint", newJBool(prettyPrint))
  result = call_594065.call(path_594066, query_594067, nil, nil, body_594068)

var runNamespacesDomainmappingsCreate* = Call_RunNamespacesDomainmappingsCreate_594048(
    name: "runNamespacesDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsCreate_594049, base: "/",
    url: url_RunNamespacesDomainmappingsCreate_594050, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsList_594022 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesDomainmappingsList_594024(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesDomainmappingsList_594023(path: JsonNode;
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
  var valid_594025 = path.getOrDefault("parent")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "parent", valid_594025
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
  var valid_594026 = query.getOrDefault("upload_protocol")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "upload_protocol", valid_594026
  var valid_594027 = query.getOrDefault("fields")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "fields", valid_594027
  var valid_594028 = query.getOrDefault("quotaUser")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "quotaUser", valid_594028
  var valid_594029 = query.getOrDefault("includeUninitialized")
  valid_594029 = validateParameter(valid_594029, JBool, required = false, default = nil)
  if valid_594029 != nil:
    section.add "includeUninitialized", valid_594029
  var valid_594030 = query.getOrDefault("alt")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = newJString("json"))
  if valid_594030 != nil:
    section.add "alt", valid_594030
  var valid_594031 = query.getOrDefault("continue")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "continue", valid_594031
  var valid_594032 = query.getOrDefault("oauth_token")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "oauth_token", valid_594032
  var valid_594033 = query.getOrDefault("callback")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "callback", valid_594033
  var valid_594034 = query.getOrDefault("access_token")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "access_token", valid_594034
  var valid_594035 = query.getOrDefault("uploadType")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "uploadType", valid_594035
  var valid_594036 = query.getOrDefault("resourceVersion")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "resourceVersion", valid_594036
  var valid_594037 = query.getOrDefault("watch")
  valid_594037 = validateParameter(valid_594037, JBool, required = false, default = nil)
  if valid_594037 != nil:
    section.add "watch", valid_594037
  var valid_594038 = query.getOrDefault("key")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "key", valid_594038
  var valid_594039 = query.getOrDefault("$.xgafv")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = newJString("1"))
  if valid_594039 != nil:
    section.add "$.xgafv", valid_594039
  var valid_594040 = query.getOrDefault("labelSelector")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "labelSelector", valid_594040
  var valid_594041 = query.getOrDefault("prettyPrint")
  valid_594041 = validateParameter(valid_594041, JBool, required = false,
                                 default = newJBool(true))
  if valid_594041 != nil:
    section.add "prettyPrint", valid_594041
  var valid_594042 = query.getOrDefault("fieldSelector")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "fieldSelector", valid_594042
  var valid_594043 = query.getOrDefault("limit")
  valid_594043 = validateParameter(valid_594043, JInt, required = false, default = nil)
  if valid_594043 != nil:
    section.add "limit", valid_594043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594044: Call_RunNamespacesDomainmappingsList_594022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list domain mappings.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_RunNamespacesDomainmappingsList_594022;
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
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  add(query_594047, "upload_protocol", newJString(uploadProtocol))
  add(query_594047, "fields", newJString(fields))
  add(query_594047, "quotaUser", newJString(quotaUser))
  add(query_594047, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594047, "alt", newJString(alt))
  add(query_594047, "continue", newJString(`continue`))
  add(query_594047, "oauth_token", newJString(oauthToken))
  add(query_594047, "callback", newJString(callback))
  add(query_594047, "access_token", newJString(accessToken))
  add(query_594047, "uploadType", newJString(uploadType))
  add(path_594046, "parent", newJString(parent))
  add(query_594047, "resourceVersion", newJString(resourceVersion))
  add(query_594047, "watch", newJBool(watch))
  add(query_594047, "key", newJString(key))
  add(query_594047, "$.xgafv", newJString(Xgafv))
  add(query_594047, "labelSelector", newJString(labelSelector))
  add(query_594047, "prettyPrint", newJBool(prettyPrint))
  add(query_594047, "fieldSelector", newJString(fieldSelector))
  add(query_594047, "limit", newJInt(limit))
  result = call_594045.call(path_594046, query_594047, nil, nil, nil)

var runNamespacesDomainmappingsList* = Call_RunNamespacesDomainmappingsList_594022(
    name: "runNamespacesDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsList_594023, base: "/",
    url: url_RunNamespacesDomainmappingsList_594024, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersReplaceTrigger_594088 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesTriggersReplaceTrigger_594090(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesTriggersReplaceTrigger_594089(path: JsonNode;
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
  var valid_594091 = path.getOrDefault("name")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "name", valid_594091
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
  var valid_594094 = query.getOrDefault("quotaUser")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "quotaUser", valid_594094
  var valid_594095 = query.getOrDefault("alt")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = newJString("json"))
  if valid_594095 != nil:
    section.add "alt", valid_594095
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
  var valid_594100 = query.getOrDefault("key")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "key", valid_594100
  var valid_594101 = query.getOrDefault("$.xgafv")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = newJString("1"))
  if valid_594101 != nil:
    section.add "$.xgafv", valid_594101
  var valid_594102 = query.getOrDefault("prettyPrint")
  valid_594102 = validateParameter(valid_594102, JBool, required = false,
                                 default = newJBool(true))
  if valid_594102 != nil:
    section.add "prettyPrint", valid_594102
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

proc call*(call_594104: Call_RunNamespacesTriggersReplaceTrigger_594088;
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
  let valid = call_594104.validator(path, query, header, formData, body)
  let scheme = call_594104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594104.url(scheme.get, call_594104.host, call_594104.base,
                         call_594104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594104, url, valid)

proc call*(call_594105: Call_RunNamespacesTriggersReplaceTrigger_594088;
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
  var path_594106 = newJObject()
  var query_594107 = newJObject()
  var body_594108 = newJObject()
  add(query_594107, "upload_protocol", newJString(uploadProtocol))
  add(query_594107, "fields", newJString(fields))
  add(query_594107, "quotaUser", newJString(quotaUser))
  add(path_594106, "name", newJString(name))
  add(query_594107, "alt", newJString(alt))
  add(query_594107, "oauth_token", newJString(oauthToken))
  add(query_594107, "callback", newJString(callback))
  add(query_594107, "access_token", newJString(accessToken))
  add(query_594107, "uploadType", newJString(uploadType))
  add(query_594107, "key", newJString(key))
  add(query_594107, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594108 = body
  add(query_594107, "prettyPrint", newJBool(prettyPrint))
  result = call_594105.call(path_594106, query_594107, nil, nil, body_594108)

var runNamespacesTriggersReplaceTrigger* = Call_RunNamespacesTriggersReplaceTrigger_594088(
    name: "runNamespacesTriggersReplaceTrigger", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersReplaceTrigger_594089, base: "/",
    url: url_RunNamespacesTriggersReplaceTrigger_594090, schemes: {Scheme.Https})
type
  Call_RunNamespacesEventtypesGet_594069 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesEventtypesGet_594071(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesEventtypesGet_594070(path: JsonNode; query: JsonNode;
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
  var valid_594072 = path.getOrDefault("name")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "name", valid_594072
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

proc call*(call_594084: Call_RunNamespacesEventtypesGet_594069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about an EventType.
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_RunNamespacesEventtypesGet_594069; name: string;
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
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  add(query_594087, "upload_protocol", newJString(uploadProtocol))
  add(query_594087, "fields", newJString(fields))
  add(query_594087, "quotaUser", newJString(quotaUser))
  add(path_594086, "name", newJString(name))
  add(query_594087, "alt", newJString(alt))
  add(query_594087, "oauth_token", newJString(oauthToken))
  add(query_594087, "callback", newJString(callback))
  add(query_594087, "access_token", newJString(accessToken))
  add(query_594087, "uploadType", newJString(uploadType))
  add(query_594087, "key", newJString(key))
  add(query_594087, "$.xgafv", newJString(Xgafv))
  add(query_594087, "prettyPrint", newJBool(prettyPrint))
  result = call_594085.call(path_594086, query_594087, nil, nil, nil)

var runNamespacesEventtypesGet* = Call_RunNamespacesEventtypesGet_594069(
    name: "runNamespacesEventtypesGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesEventtypesGet_594070, base: "/",
    url: url_RunNamespacesEventtypesGet_594071, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersDelete_594109 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesTriggersDelete_594111(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesTriggersDelete_594110(path: JsonNode; query: JsonNode;
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
  var valid_594112 = path.getOrDefault("name")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "name", valid_594112
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
  var valid_594113 = query.getOrDefault("upload_protocol")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "upload_protocol", valid_594113
  var valid_594114 = query.getOrDefault("fields")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "fields", valid_594114
  var valid_594115 = query.getOrDefault("quotaUser")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "quotaUser", valid_594115
  var valid_594116 = query.getOrDefault("alt")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = newJString("json"))
  if valid_594116 != nil:
    section.add "alt", valid_594116
  var valid_594117 = query.getOrDefault("oauth_token")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "oauth_token", valid_594117
  var valid_594118 = query.getOrDefault("callback")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "callback", valid_594118
  var valid_594119 = query.getOrDefault("access_token")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "access_token", valid_594119
  var valid_594120 = query.getOrDefault("uploadType")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "uploadType", valid_594120
  var valid_594121 = query.getOrDefault("kind")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "kind", valid_594121
  var valid_594122 = query.getOrDefault("key")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "key", valid_594122
  var valid_594123 = query.getOrDefault("$.xgafv")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = newJString("1"))
  if valid_594123 != nil:
    section.add "$.xgafv", valid_594123
  var valid_594124 = query.getOrDefault("prettyPrint")
  valid_594124 = validateParameter(valid_594124, JBool, required = false,
                                 default = newJBool(true))
  if valid_594124 != nil:
    section.add "prettyPrint", valid_594124
  var valid_594125 = query.getOrDefault("propagationPolicy")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "propagationPolicy", valid_594125
  var valid_594126 = query.getOrDefault("apiVersion")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "apiVersion", valid_594126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594127: Call_RunNamespacesTriggersDelete_594109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to delete a trigger.
  ## 
  let valid = call_594127.validator(path, query, header, formData, body)
  let scheme = call_594127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594127.url(scheme.get, call_594127.host, call_594127.base,
                         call_594127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594127, url, valid)

proc call*(call_594128: Call_RunNamespacesTriggersDelete_594109; name: string;
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
  var path_594129 = newJObject()
  var query_594130 = newJObject()
  add(query_594130, "upload_protocol", newJString(uploadProtocol))
  add(query_594130, "fields", newJString(fields))
  add(query_594130, "quotaUser", newJString(quotaUser))
  add(path_594129, "name", newJString(name))
  add(query_594130, "alt", newJString(alt))
  add(query_594130, "oauth_token", newJString(oauthToken))
  add(query_594130, "callback", newJString(callback))
  add(query_594130, "access_token", newJString(accessToken))
  add(query_594130, "uploadType", newJString(uploadType))
  add(query_594130, "kind", newJString(kind))
  add(query_594130, "key", newJString(key))
  add(query_594130, "$.xgafv", newJString(Xgafv))
  add(query_594130, "prettyPrint", newJBool(prettyPrint))
  add(query_594130, "propagationPolicy", newJString(propagationPolicy))
  add(query_594130, "apiVersion", newJString(apiVersion))
  result = call_594128.call(path_594129, query_594130, nil, nil, nil)

var runNamespacesTriggersDelete* = Call_RunNamespacesTriggersDelete_594109(
    name: "runNamespacesTriggersDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersDelete_594110, base: "/",
    url: url_RunNamespacesTriggersDelete_594111, schemes: {Scheme.Https})
type
  Call_RunNamespacesEventtypesList_594131 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesEventtypesList_594133(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesEventtypesList_594132(path: JsonNode; query: JsonNode;
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
  var valid_594138 = query.getOrDefault("includeUninitialized")
  valid_594138 = validateParameter(valid_594138, JBool, required = false, default = nil)
  if valid_594138 != nil:
    section.add "includeUninitialized", valid_594138
  var valid_594139 = query.getOrDefault("alt")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = newJString("json"))
  if valid_594139 != nil:
    section.add "alt", valid_594139
  var valid_594140 = query.getOrDefault("continue")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "continue", valid_594140
  var valid_594141 = query.getOrDefault("oauth_token")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "oauth_token", valid_594141
  var valid_594142 = query.getOrDefault("callback")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "callback", valid_594142
  var valid_594143 = query.getOrDefault("access_token")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "access_token", valid_594143
  var valid_594144 = query.getOrDefault("uploadType")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "uploadType", valid_594144
  var valid_594145 = query.getOrDefault("resourceVersion")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "resourceVersion", valid_594145
  var valid_594146 = query.getOrDefault("watch")
  valid_594146 = validateParameter(valid_594146, JBool, required = false, default = nil)
  if valid_594146 != nil:
    section.add "watch", valid_594146
  var valid_594147 = query.getOrDefault("key")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "key", valid_594147
  var valid_594148 = query.getOrDefault("$.xgafv")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = newJString("1"))
  if valid_594148 != nil:
    section.add "$.xgafv", valid_594148
  var valid_594149 = query.getOrDefault("labelSelector")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "labelSelector", valid_594149
  var valid_594150 = query.getOrDefault("prettyPrint")
  valid_594150 = validateParameter(valid_594150, JBool, required = false,
                                 default = newJBool(true))
  if valid_594150 != nil:
    section.add "prettyPrint", valid_594150
  var valid_594151 = query.getOrDefault("fieldSelector")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "fieldSelector", valid_594151
  var valid_594152 = query.getOrDefault("limit")
  valid_594152 = validateParameter(valid_594152, JInt, required = false, default = nil)
  if valid_594152 != nil:
    section.add "limit", valid_594152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594153: Call_RunNamespacesEventtypesList_594131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list EventTypes.
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_RunNamespacesEventtypesList_594131; parent: string;
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
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  add(query_594156, "upload_protocol", newJString(uploadProtocol))
  add(query_594156, "fields", newJString(fields))
  add(query_594156, "quotaUser", newJString(quotaUser))
  add(query_594156, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594156, "alt", newJString(alt))
  add(query_594156, "continue", newJString(`continue`))
  add(query_594156, "oauth_token", newJString(oauthToken))
  add(query_594156, "callback", newJString(callback))
  add(query_594156, "access_token", newJString(accessToken))
  add(query_594156, "uploadType", newJString(uploadType))
  add(path_594155, "parent", newJString(parent))
  add(query_594156, "resourceVersion", newJString(resourceVersion))
  add(query_594156, "watch", newJBool(watch))
  add(query_594156, "key", newJString(key))
  add(query_594156, "$.xgafv", newJString(Xgafv))
  add(query_594156, "labelSelector", newJString(labelSelector))
  add(query_594156, "prettyPrint", newJBool(prettyPrint))
  add(query_594156, "fieldSelector", newJString(fieldSelector))
  add(query_594156, "limit", newJInt(limit))
  result = call_594154.call(path_594155, query_594156, nil, nil, nil)

var runNamespacesEventtypesList* = Call_RunNamespacesEventtypesList_594131(
    name: "runNamespacesEventtypesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/eventtypes",
    validator: validate_RunNamespacesEventtypesList_594132, base: "/",
    url: url_RunNamespacesEventtypesList_594133, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersCreate_594183 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesTriggersCreate_594185(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesTriggersCreate_594184(path: JsonNode; query: JsonNode;
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
  var valid_594186 = path.getOrDefault("parent")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "parent", valid_594186
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
  var valid_594187 = query.getOrDefault("upload_protocol")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "upload_protocol", valid_594187
  var valid_594188 = query.getOrDefault("fields")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "fields", valid_594188
  var valid_594189 = query.getOrDefault("quotaUser")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "quotaUser", valid_594189
  var valid_594190 = query.getOrDefault("alt")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = newJString("json"))
  if valid_594190 != nil:
    section.add "alt", valid_594190
  var valid_594191 = query.getOrDefault("oauth_token")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "oauth_token", valid_594191
  var valid_594192 = query.getOrDefault("callback")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "callback", valid_594192
  var valid_594193 = query.getOrDefault("access_token")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "access_token", valid_594193
  var valid_594194 = query.getOrDefault("uploadType")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "uploadType", valid_594194
  var valid_594195 = query.getOrDefault("key")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "key", valid_594195
  var valid_594196 = query.getOrDefault("$.xgafv")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = newJString("1"))
  if valid_594196 != nil:
    section.add "$.xgafv", valid_594196
  var valid_594197 = query.getOrDefault("prettyPrint")
  valid_594197 = validateParameter(valid_594197, JBool, required = false,
                                 default = newJBool(true))
  if valid_594197 != nil:
    section.add "prettyPrint", valid_594197
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

proc call*(call_594199: Call_RunNamespacesTriggersCreate_594183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new trigger.
  ## 
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_RunNamespacesTriggersCreate_594183; parent: string;
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
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  var body_594203 = newJObject()
  add(query_594202, "upload_protocol", newJString(uploadProtocol))
  add(query_594202, "fields", newJString(fields))
  add(query_594202, "quotaUser", newJString(quotaUser))
  add(query_594202, "alt", newJString(alt))
  add(query_594202, "oauth_token", newJString(oauthToken))
  add(query_594202, "callback", newJString(callback))
  add(query_594202, "access_token", newJString(accessToken))
  add(query_594202, "uploadType", newJString(uploadType))
  add(path_594201, "parent", newJString(parent))
  add(query_594202, "key", newJString(key))
  add(query_594202, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594203 = body
  add(query_594202, "prettyPrint", newJBool(prettyPrint))
  result = call_594200.call(path_594201, query_594202, nil, nil, body_594203)

var runNamespacesTriggersCreate* = Call_RunNamespacesTriggersCreate_594183(
    name: "runNamespacesTriggersCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/triggers",
    validator: validate_RunNamespacesTriggersCreate_594184, base: "/",
    url: url_RunNamespacesTriggersCreate_594185, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersList_594157 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesTriggersList_594159(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesTriggersList_594158(path: JsonNode; query: JsonNode;
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
  var valid_594160 = path.getOrDefault("parent")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "parent", valid_594160
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
  var valid_594161 = query.getOrDefault("upload_protocol")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "upload_protocol", valid_594161
  var valid_594162 = query.getOrDefault("fields")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "fields", valid_594162
  var valid_594163 = query.getOrDefault("quotaUser")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "quotaUser", valid_594163
  var valid_594164 = query.getOrDefault("includeUninitialized")
  valid_594164 = validateParameter(valid_594164, JBool, required = false, default = nil)
  if valid_594164 != nil:
    section.add "includeUninitialized", valid_594164
  var valid_594165 = query.getOrDefault("alt")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = newJString("json"))
  if valid_594165 != nil:
    section.add "alt", valid_594165
  var valid_594166 = query.getOrDefault("continue")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "continue", valid_594166
  var valid_594167 = query.getOrDefault("oauth_token")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "oauth_token", valid_594167
  var valid_594168 = query.getOrDefault("callback")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "callback", valid_594168
  var valid_594169 = query.getOrDefault("access_token")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "access_token", valid_594169
  var valid_594170 = query.getOrDefault("uploadType")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "uploadType", valid_594170
  var valid_594171 = query.getOrDefault("resourceVersion")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "resourceVersion", valid_594171
  var valid_594172 = query.getOrDefault("watch")
  valid_594172 = validateParameter(valid_594172, JBool, required = false, default = nil)
  if valid_594172 != nil:
    section.add "watch", valid_594172
  var valid_594173 = query.getOrDefault("key")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "key", valid_594173
  var valid_594174 = query.getOrDefault("$.xgafv")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = newJString("1"))
  if valid_594174 != nil:
    section.add "$.xgafv", valid_594174
  var valid_594175 = query.getOrDefault("labelSelector")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "labelSelector", valid_594175
  var valid_594176 = query.getOrDefault("prettyPrint")
  valid_594176 = validateParameter(valid_594176, JBool, required = false,
                                 default = newJBool(true))
  if valid_594176 != nil:
    section.add "prettyPrint", valid_594176
  var valid_594177 = query.getOrDefault("fieldSelector")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "fieldSelector", valid_594177
  var valid_594178 = query.getOrDefault("limit")
  valid_594178 = validateParameter(valid_594178, JInt, required = false, default = nil)
  if valid_594178 != nil:
    section.add "limit", valid_594178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594179: Call_RunNamespacesTriggersList_594157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list triggers.
  ## 
  let valid = call_594179.validator(path, query, header, formData, body)
  let scheme = call_594179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594179.url(scheme.get, call_594179.host, call_594179.base,
                         call_594179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594179, url, valid)

proc call*(call_594180: Call_RunNamespacesTriggersList_594157; parent: string;
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
  var path_594181 = newJObject()
  var query_594182 = newJObject()
  add(query_594182, "upload_protocol", newJString(uploadProtocol))
  add(query_594182, "fields", newJString(fields))
  add(query_594182, "quotaUser", newJString(quotaUser))
  add(query_594182, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594182, "alt", newJString(alt))
  add(query_594182, "continue", newJString(`continue`))
  add(query_594182, "oauth_token", newJString(oauthToken))
  add(query_594182, "callback", newJString(callback))
  add(query_594182, "access_token", newJString(accessToken))
  add(query_594182, "uploadType", newJString(uploadType))
  add(path_594181, "parent", newJString(parent))
  add(query_594182, "resourceVersion", newJString(resourceVersion))
  add(query_594182, "watch", newJBool(watch))
  add(query_594182, "key", newJString(key))
  add(query_594182, "$.xgafv", newJString(Xgafv))
  add(query_594182, "labelSelector", newJString(labelSelector))
  add(query_594182, "prettyPrint", newJBool(prettyPrint))
  add(query_594182, "fieldSelector", newJString(fieldSelector))
  add(query_594182, "limit", newJInt(limit))
  result = call_594180.call(path_594181, query_594182, nil, nil, nil)

var runNamespacesTriggersList* = Call_RunNamespacesTriggersList_594157(
    name: "runNamespacesTriggersList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/triggers",
    validator: validate_RunNamespacesTriggersList_594158, base: "/",
    url: url_RunNamespacesTriggersList_594159, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesReplaceService_594223 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesServicesReplaceService_594225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesServicesReplaceService_594224(path: JsonNode;
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
  var valid_594226 = path.getOrDefault("name")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "name", valid_594226
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
  var valid_594227 = query.getOrDefault("upload_protocol")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "upload_protocol", valid_594227
  var valid_594228 = query.getOrDefault("fields")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = nil)
  if valid_594228 != nil:
    section.add "fields", valid_594228
  var valid_594229 = query.getOrDefault("quotaUser")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "quotaUser", valid_594229
  var valid_594230 = query.getOrDefault("alt")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = newJString("json"))
  if valid_594230 != nil:
    section.add "alt", valid_594230
  var valid_594231 = query.getOrDefault("oauth_token")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "oauth_token", valid_594231
  var valid_594232 = query.getOrDefault("callback")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "callback", valid_594232
  var valid_594233 = query.getOrDefault("access_token")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "access_token", valid_594233
  var valid_594234 = query.getOrDefault("uploadType")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "uploadType", valid_594234
  var valid_594235 = query.getOrDefault("key")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "key", valid_594235
  var valid_594236 = query.getOrDefault("$.xgafv")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = newJString("1"))
  if valid_594236 != nil:
    section.add "$.xgafv", valid_594236
  var valid_594237 = query.getOrDefault("prettyPrint")
  valid_594237 = validateParameter(valid_594237, JBool, required = false,
                                 default = newJBool(true))
  if valid_594237 != nil:
    section.add "prettyPrint", valid_594237
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

proc call*(call_594239: Call_RunNamespacesServicesReplaceService_594223;
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
  let valid = call_594239.validator(path, query, header, formData, body)
  let scheme = call_594239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594239.url(scheme.get, call_594239.host, call_594239.base,
                         call_594239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594239, url, valid)

proc call*(call_594240: Call_RunNamespacesServicesReplaceService_594223;
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
  var path_594241 = newJObject()
  var query_594242 = newJObject()
  var body_594243 = newJObject()
  add(query_594242, "upload_protocol", newJString(uploadProtocol))
  add(query_594242, "fields", newJString(fields))
  add(query_594242, "quotaUser", newJString(quotaUser))
  add(path_594241, "name", newJString(name))
  add(query_594242, "alt", newJString(alt))
  add(query_594242, "oauth_token", newJString(oauthToken))
  add(query_594242, "callback", newJString(callback))
  add(query_594242, "access_token", newJString(accessToken))
  add(query_594242, "uploadType", newJString(uploadType))
  add(query_594242, "key", newJString(key))
  add(query_594242, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594243 = body
  add(query_594242, "prettyPrint", newJBool(prettyPrint))
  result = call_594240.call(path_594241, query_594242, nil, nil, body_594243)

var runNamespacesServicesReplaceService* = Call_RunNamespacesServicesReplaceService_594223(
    name: "runNamespacesServicesReplaceService", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesServicesReplaceService_594224, base: "/",
    url: url_RunNamespacesServicesReplaceService_594225, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsGet_594204 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesConfigurationsGet_594206(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesConfigurationsGet_594205(path: JsonNode;
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
  var valid_594207 = path.getOrDefault("name")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "name", valid_594207
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
  var valid_594208 = query.getOrDefault("upload_protocol")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "upload_protocol", valid_594208
  var valid_594209 = query.getOrDefault("fields")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "fields", valid_594209
  var valid_594210 = query.getOrDefault("quotaUser")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "quotaUser", valid_594210
  var valid_594211 = query.getOrDefault("alt")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = newJString("json"))
  if valid_594211 != nil:
    section.add "alt", valid_594211
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
  var valid_594216 = query.getOrDefault("key")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "key", valid_594216
  var valid_594217 = query.getOrDefault("$.xgafv")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = newJString("1"))
  if valid_594217 != nil:
    section.add "$.xgafv", valid_594217
  var valid_594218 = query.getOrDefault("prettyPrint")
  valid_594218 = validateParameter(valid_594218, JBool, required = false,
                                 default = newJBool(true))
  if valid_594218 != nil:
    section.add "prettyPrint", valid_594218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_RunNamespacesConfigurationsGet_594204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a configuration.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_RunNamespacesConfigurationsGet_594204; name: string;
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
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  add(query_594222, "upload_protocol", newJString(uploadProtocol))
  add(query_594222, "fields", newJString(fields))
  add(query_594222, "quotaUser", newJString(quotaUser))
  add(path_594221, "name", newJString(name))
  add(query_594222, "alt", newJString(alt))
  add(query_594222, "oauth_token", newJString(oauthToken))
  add(query_594222, "callback", newJString(callback))
  add(query_594222, "access_token", newJString(accessToken))
  add(query_594222, "uploadType", newJString(uploadType))
  add(query_594222, "key", newJString(key))
  add(query_594222, "$.xgafv", newJString(Xgafv))
  add(query_594222, "prettyPrint", newJBool(prettyPrint))
  result = call_594220.call(path_594221, query_594222, nil, nil, nil)

var runNamespacesConfigurationsGet* = Call_RunNamespacesConfigurationsGet_594204(
    name: "runNamespacesConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesConfigurationsGet_594205, base: "/",
    url: url_RunNamespacesConfigurationsGet_594206, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsDelete_594244 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesRevisionsDelete_594246(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesRevisionsDelete_594245(path: JsonNode; query: JsonNode;
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
  var valid_594247 = path.getOrDefault("name")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "name", valid_594247
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
  var valid_594248 = query.getOrDefault("upload_protocol")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "upload_protocol", valid_594248
  var valid_594249 = query.getOrDefault("fields")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "fields", valid_594249
  var valid_594250 = query.getOrDefault("orphanDependents")
  valid_594250 = validateParameter(valid_594250, JBool, required = false, default = nil)
  if valid_594250 != nil:
    section.add "orphanDependents", valid_594250
  var valid_594251 = query.getOrDefault("quotaUser")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "quotaUser", valid_594251
  var valid_594252 = query.getOrDefault("alt")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = newJString("json"))
  if valid_594252 != nil:
    section.add "alt", valid_594252
  var valid_594253 = query.getOrDefault("oauth_token")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "oauth_token", valid_594253
  var valid_594254 = query.getOrDefault("callback")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "callback", valid_594254
  var valid_594255 = query.getOrDefault("access_token")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "access_token", valid_594255
  var valid_594256 = query.getOrDefault("uploadType")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "uploadType", valid_594256
  var valid_594257 = query.getOrDefault("kind")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "kind", valid_594257
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
  var valid_594261 = query.getOrDefault("propagationPolicy")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "propagationPolicy", valid_594261
  var valid_594262 = query.getOrDefault("apiVersion")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "apiVersion", valid_594262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594263: Call_RunNamespacesRevisionsDelete_594244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to delete a revision.
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_RunNamespacesRevisionsDelete_594244; name: string;
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
  var path_594265 = newJObject()
  var query_594266 = newJObject()
  add(query_594266, "upload_protocol", newJString(uploadProtocol))
  add(query_594266, "fields", newJString(fields))
  add(query_594266, "orphanDependents", newJBool(orphanDependents))
  add(query_594266, "quotaUser", newJString(quotaUser))
  add(path_594265, "name", newJString(name))
  add(query_594266, "alt", newJString(alt))
  add(query_594266, "oauth_token", newJString(oauthToken))
  add(query_594266, "callback", newJString(callback))
  add(query_594266, "access_token", newJString(accessToken))
  add(query_594266, "uploadType", newJString(uploadType))
  add(query_594266, "kind", newJString(kind))
  add(query_594266, "key", newJString(key))
  add(query_594266, "$.xgafv", newJString(Xgafv))
  add(query_594266, "prettyPrint", newJBool(prettyPrint))
  add(query_594266, "propagationPolicy", newJString(propagationPolicy))
  add(query_594266, "apiVersion", newJString(apiVersion))
  result = call_594264.call(path_594265, query_594266, nil, nil, nil)

var runNamespacesRevisionsDelete* = Call_RunNamespacesRevisionsDelete_594244(
    name: "runNamespacesRevisionsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesRevisionsDelete_594245, base: "/",
    url: url_RunNamespacesRevisionsDelete_594246, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsList_594267 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesConfigurationsList_594269(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesConfigurationsList_594268(path: JsonNode;
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
  var valid_594270 = path.getOrDefault("parent")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "parent", valid_594270
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
  var valid_594274 = query.getOrDefault("includeUninitialized")
  valid_594274 = validateParameter(valid_594274, JBool, required = false, default = nil)
  if valid_594274 != nil:
    section.add "includeUninitialized", valid_594274
  var valid_594275 = query.getOrDefault("alt")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = newJString("json"))
  if valid_594275 != nil:
    section.add "alt", valid_594275
  var valid_594276 = query.getOrDefault("continue")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "continue", valid_594276
  var valid_594277 = query.getOrDefault("oauth_token")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "oauth_token", valid_594277
  var valid_594278 = query.getOrDefault("callback")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "callback", valid_594278
  var valid_594279 = query.getOrDefault("access_token")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "access_token", valid_594279
  var valid_594280 = query.getOrDefault("uploadType")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "uploadType", valid_594280
  var valid_594281 = query.getOrDefault("resourceVersion")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "resourceVersion", valid_594281
  var valid_594282 = query.getOrDefault("watch")
  valid_594282 = validateParameter(valid_594282, JBool, required = false, default = nil)
  if valid_594282 != nil:
    section.add "watch", valid_594282
  var valid_594283 = query.getOrDefault("key")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "key", valid_594283
  var valid_594284 = query.getOrDefault("$.xgafv")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = newJString("1"))
  if valid_594284 != nil:
    section.add "$.xgafv", valid_594284
  var valid_594285 = query.getOrDefault("labelSelector")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "labelSelector", valid_594285
  var valid_594286 = query.getOrDefault("prettyPrint")
  valid_594286 = validateParameter(valid_594286, JBool, required = false,
                                 default = newJBool(true))
  if valid_594286 != nil:
    section.add "prettyPrint", valid_594286
  var valid_594287 = query.getOrDefault("fieldSelector")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "fieldSelector", valid_594287
  var valid_594288 = query.getOrDefault("limit")
  valid_594288 = validateParameter(valid_594288, JInt, required = false, default = nil)
  if valid_594288 != nil:
    section.add "limit", valid_594288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594289: Call_RunNamespacesConfigurationsList_594267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list configurations.
  ## 
  let valid = call_594289.validator(path, query, header, formData, body)
  let scheme = call_594289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594289.url(scheme.get, call_594289.host, call_594289.base,
                         call_594289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594289, url, valid)

proc call*(call_594290: Call_RunNamespacesConfigurationsList_594267;
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
  var path_594291 = newJObject()
  var query_594292 = newJObject()
  add(query_594292, "upload_protocol", newJString(uploadProtocol))
  add(query_594292, "fields", newJString(fields))
  add(query_594292, "quotaUser", newJString(quotaUser))
  add(query_594292, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594292, "alt", newJString(alt))
  add(query_594292, "continue", newJString(`continue`))
  add(query_594292, "oauth_token", newJString(oauthToken))
  add(query_594292, "callback", newJString(callback))
  add(query_594292, "access_token", newJString(accessToken))
  add(query_594292, "uploadType", newJString(uploadType))
  add(path_594291, "parent", newJString(parent))
  add(query_594292, "resourceVersion", newJString(resourceVersion))
  add(query_594292, "watch", newJBool(watch))
  add(query_594292, "key", newJString(key))
  add(query_594292, "$.xgafv", newJString(Xgafv))
  add(query_594292, "labelSelector", newJString(labelSelector))
  add(query_594292, "prettyPrint", newJBool(prettyPrint))
  add(query_594292, "fieldSelector", newJString(fieldSelector))
  add(query_594292, "limit", newJInt(limit))
  result = call_594290.call(path_594291, query_594292, nil, nil, nil)

var runNamespacesConfigurationsList* = Call_RunNamespacesConfigurationsList_594267(
    name: "runNamespacesConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsList_594268, base: "/",
    url: url_RunNamespacesConfigurationsList_594269, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsList_594293 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesRevisionsList_594295(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesRevisionsList_594294(path: JsonNode; query: JsonNode;
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
  var valid_594296 = path.getOrDefault("parent")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "parent", valid_594296
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
  var valid_594297 = query.getOrDefault("upload_protocol")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "upload_protocol", valid_594297
  var valid_594298 = query.getOrDefault("fields")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "fields", valid_594298
  var valid_594299 = query.getOrDefault("quotaUser")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "quotaUser", valid_594299
  var valid_594300 = query.getOrDefault("includeUninitialized")
  valid_594300 = validateParameter(valid_594300, JBool, required = false, default = nil)
  if valid_594300 != nil:
    section.add "includeUninitialized", valid_594300
  var valid_594301 = query.getOrDefault("alt")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = newJString("json"))
  if valid_594301 != nil:
    section.add "alt", valid_594301
  var valid_594302 = query.getOrDefault("continue")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "continue", valid_594302
  var valid_594303 = query.getOrDefault("oauth_token")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "oauth_token", valid_594303
  var valid_594304 = query.getOrDefault("callback")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = nil)
  if valid_594304 != nil:
    section.add "callback", valid_594304
  var valid_594305 = query.getOrDefault("access_token")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "access_token", valid_594305
  var valid_594306 = query.getOrDefault("uploadType")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "uploadType", valid_594306
  var valid_594307 = query.getOrDefault("resourceVersion")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "resourceVersion", valid_594307
  var valid_594308 = query.getOrDefault("watch")
  valid_594308 = validateParameter(valid_594308, JBool, required = false, default = nil)
  if valid_594308 != nil:
    section.add "watch", valid_594308
  var valid_594309 = query.getOrDefault("key")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "key", valid_594309
  var valid_594310 = query.getOrDefault("$.xgafv")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = newJString("1"))
  if valid_594310 != nil:
    section.add "$.xgafv", valid_594310
  var valid_594311 = query.getOrDefault("labelSelector")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "labelSelector", valid_594311
  var valid_594312 = query.getOrDefault("prettyPrint")
  valid_594312 = validateParameter(valid_594312, JBool, required = false,
                                 default = newJBool(true))
  if valid_594312 != nil:
    section.add "prettyPrint", valid_594312
  var valid_594313 = query.getOrDefault("fieldSelector")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "fieldSelector", valid_594313
  var valid_594314 = query.getOrDefault("limit")
  valid_594314 = validateParameter(valid_594314, JInt, required = false, default = nil)
  if valid_594314 != nil:
    section.add "limit", valid_594314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594315: Call_RunNamespacesRevisionsList_594293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list revisions.
  ## 
  let valid = call_594315.validator(path, query, header, formData, body)
  let scheme = call_594315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594315.url(scheme.get, call_594315.host, call_594315.base,
                         call_594315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594315, url, valid)

proc call*(call_594316: Call_RunNamespacesRevisionsList_594293; parent: string;
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
  var path_594317 = newJObject()
  var query_594318 = newJObject()
  add(query_594318, "upload_protocol", newJString(uploadProtocol))
  add(query_594318, "fields", newJString(fields))
  add(query_594318, "quotaUser", newJString(quotaUser))
  add(query_594318, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594318, "alt", newJString(alt))
  add(query_594318, "continue", newJString(`continue`))
  add(query_594318, "oauth_token", newJString(oauthToken))
  add(query_594318, "callback", newJString(callback))
  add(query_594318, "access_token", newJString(accessToken))
  add(query_594318, "uploadType", newJString(uploadType))
  add(path_594317, "parent", newJString(parent))
  add(query_594318, "resourceVersion", newJString(resourceVersion))
  add(query_594318, "watch", newJBool(watch))
  add(query_594318, "key", newJString(key))
  add(query_594318, "$.xgafv", newJString(Xgafv))
  add(query_594318, "labelSelector", newJString(labelSelector))
  add(query_594318, "prettyPrint", newJBool(prettyPrint))
  add(query_594318, "fieldSelector", newJString(fieldSelector))
  add(query_594318, "limit", newJInt(limit))
  result = call_594316.call(path_594317, query_594318, nil, nil, nil)

var runNamespacesRevisionsList* = Call_RunNamespacesRevisionsList_594293(
    name: "runNamespacesRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/revisions",
    validator: validate_RunNamespacesRevisionsList_594294, base: "/",
    url: url_RunNamespacesRevisionsList_594295, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesList_594319 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesRoutesList_594321(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesRoutesList_594320(path: JsonNode; query: JsonNode;
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
  var valid_594322 = path.getOrDefault("parent")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "parent", valid_594322
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
  var valid_594323 = query.getOrDefault("upload_protocol")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "upload_protocol", valid_594323
  var valid_594324 = query.getOrDefault("fields")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "fields", valid_594324
  var valid_594325 = query.getOrDefault("quotaUser")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = nil)
  if valid_594325 != nil:
    section.add "quotaUser", valid_594325
  var valid_594326 = query.getOrDefault("includeUninitialized")
  valid_594326 = validateParameter(valid_594326, JBool, required = false, default = nil)
  if valid_594326 != nil:
    section.add "includeUninitialized", valid_594326
  var valid_594327 = query.getOrDefault("alt")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = newJString("json"))
  if valid_594327 != nil:
    section.add "alt", valid_594327
  var valid_594328 = query.getOrDefault("continue")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "continue", valid_594328
  var valid_594329 = query.getOrDefault("oauth_token")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "oauth_token", valid_594329
  var valid_594330 = query.getOrDefault("callback")
  valid_594330 = validateParameter(valid_594330, JString, required = false,
                                 default = nil)
  if valid_594330 != nil:
    section.add "callback", valid_594330
  var valid_594331 = query.getOrDefault("access_token")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = nil)
  if valid_594331 != nil:
    section.add "access_token", valid_594331
  var valid_594332 = query.getOrDefault("uploadType")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "uploadType", valid_594332
  var valid_594333 = query.getOrDefault("resourceVersion")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "resourceVersion", valid_594333
  var valid_594334 = query.getOrDefault("watch")
  valid_594334 = validateParameter(valid_594334, JBool, required = false, default = nil)
  if valid_594334 != nil:
    section.add "watch", valid_594334
  var valid_594335 = query.getOrDefault("key")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = nil)
  if valid_594335 != nil:
    section.add "key", valid_594335
  var valid_594336 = query.getOrDefault("$.xgafv")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = newJString("1"))
  if valid_594336 != nil:
    section.add "$.xgafv", valid_594336
  var valid_594337 = query.getOrDefault("labelSelector")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "labelSelector", valid_594337
  var valid_594338 = query.getOrDefault("prettyPrint")
  valid_594338 = validateParameter(valid_594338, JBool, required = false,
                                 default = newJBool(true))
  if valid_594338 != nil:
    section.add "prettyPrint", valid_594338
  var valid_594339 = query.getOrDefault("fieldSelector")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "fieldSelector", valid_594339
  var valid_594340 = query.getOrDefault("limit")
  valid_594340 = validateParameter(valid_594340, JInt, required = false, default = nil)
  if valid_594340 != nil:
    section.add "limit", valid_594340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594341: Call_RunNamespacesRoutesList_594319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list routes.
  ## 
  let valid = call_594341.validator(path, query, header, formData, body)
  let scheme = call_594341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594341.url(scheme.get, call_594341.host, call_594341.base,
                         call_594341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594341, url, valid)

proc call*(call_594342: Call_RunNamespacesRoutesList_594319; parent: string;
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
  var path_594343 = newJObject()
  var query_594344 = newJObject()
  add(query_594344, "upload_protocol", newJString(uploadProtocol))
  add(query_594344, "fields", newJString(fields))
  add(query_594344, "quotaUser", newJString(quotaUser))
  add(query_594344, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594344, "alt", newJString(alt))
  add(query_594344, "continue", newJString(`continue`))
  add(query_594344, "oauth_token", newJString(oauthToken))
  add(query_594344, "callback", newJString(callback))
  add(query_594344, "access_token", newJString(accessToken))
  add(query_594344, "uploadType", newJString(uploadType))
  add(path_594343, "parent", newJString(parent))
  add(query_594344, "resourceVersion", newJString(resourceVersion))
  add(query_594344, "watch", newJBool(watch))
  add(query_594344, "key", newJString(key))
  add(query_594344, "$.xgafv", newJString(Xgafv))
  add(query_594344, "labelSelector", newJString(labelSelector))
  add(query_594344, "prettyPrint", newJBool(prettyPrint))
  add(query_594344, "fieldSelector", newJString(fieldSelector))
  add(query_594344, "limit", newJInt(limit))
  result = call_594342.call(path_594343, query_594344, nil, nil, nil)

var runNamespacesRoutesList* = Call_RunNamespacesRoutesList_594319(
    name: "runNamespacesRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/routes",
    validator: validate_RunNamespacesRoutesList_594320, base: "/",
    url: url_RunNamespacesRoutesList_594321, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesCreate_594371 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesServicesCreate_594373(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesServicesCreate_594372(path: JsonNode; query: JsonNode;
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
  var valid_594374 = path.getOrDefault("parent")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "parent", valid_594374
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
  var valid_594375 = query.getOrDefault("upload_protocol")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = nil)
  if valid_594375 != nil:
    section.add "upload_protocol", valid_594375
  var valid_594376 = query.getOrDefault("fields")
  valid_594376 = validateParameter(valid_594376, JString, required = false,
                                 default = nil)
  if valid_594376 != nil:
    section.add "fields", valid_594376
  var valid_594377 = query.getOrDefault("quotaUser")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = nil)
  if valid_594377 != nil:
    section.add "quotaUser", valid_594377
  var valid_594378 = query.getOrDefault("alt")
  valid_594378 = validateParameter(valid_594378, JString, required = false,
                                 default = newJString("json"))
  if valid_594378 != nil:
    section.add "alt", valid_594378
  var valid_594379 = query.getOrDefault("oauth_token")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = nil)
  if valid_594379 != nil:
    section.add "oauth_token", valid_594379
  var valid_594380 = query.getOrDefault("callback")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = nil)
  if valid_594380 != nil:
    section.add "callback", valid_594380
  var valid_594381 = query.getOrDefault("access_token")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "access_token", valid_594381
  var valid_594382 = query.getOrDefault("uploadType")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "uploadType", valid_594382
  var valid_594383 = query.getOrDefault("key")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "key", valid_594383
  var valid_594384 = query.getOrDefault("$.xgafv")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = newJString("1"))
  if valid_594384 != nil:
    section.add "$.xgafv", valid_594384
  var valid_594385 = query.getOrDefault("prettyPrint")
  valid_594385 = validateParameter(valid_594385, JBool, required = false,
                                 default = newJBool(true))
  if valid_594385 != nil:
    section.add "prettyPrint", valid_594385
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

proc call*(call_594387: Call_RunNamespacesServicesCreate_594371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to create a service.
  ## 
  let valid = call_594387.validator(path, query, header, formData, body)
  let scheme = call_594387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594387.url(scheme.get, call_594387.host, call_594387.base,
                         call_594387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594387, url, valid)

proc call*(call_594388: Call_RunNamespacesServicesCreate_594371; parent: string;
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
  var path_594389 = newJObject()
  var query_594390 = newJObject()
  var body_594391 = newJObject()
  add(query_594390, "upload_protocol", newJString(uploadProtocol))
  add(query_594390, "fields", newJString(fields))
  add(query_594390, "quotaUser", newJString(quotaUser))
  add(query_594390, "alt", newJString(alt))
  add(query_594390, "oauth_token", newJString(oauthToken))
  add(query_594390, "callback", newJString(callback))
  add(query_594390, "access_token", newJString(accessToken))
  add(query_594390, "uploadType", newJString(uploadType))
  add(path_594389, "parent", newJString(parent))
  add(query_594390, "key", newJString(key))
  add(query_594390, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594391 = body
  add(query_594390, "prettyPrint", newJBool(prettyPrint))
  result = call_594388.call(path_594389, query_594390, nil, nil, body_594391)

var runNamespacesServicesCreate* = Call_RunNamespacesServicesCreate_594371(
    name: "runNamespacesServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/services",
    validator: validate_RunNamespacesServicesCreate_594372, base: "/",
    url: url_RunNamespacesServicesCreate_594373, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesList_594345 = ref object of OpenApiRestCall_593421
proc url_RunNamespacesServicesList_594347(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunNamespacesServicesList_594346(path: JsonNode; query: JsonNode;
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
  var valid_594348 = path.getOrDefault("parent")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "parent", valid_594348
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
  var valid_594349 = query.getOrDefault("upload_protocol")
  valid_594349 = validateParameter(valid_594349, JString, required = false,
                                 default = nil)
  if valid_594349 != nil:
    section.add "upload_protocol", valid_594349
  var valid_594350 = query.getOrDefault("fields")
  valid_594350 = validateParameter(valid_594350, JString, required = false,
                                 default = nil)
  if valid_594350 != nil:
    section.add "fields", valid_594350
  var valid_594351 = query.getOrDefault("quotaUser")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = nil)
  if valid_594351 != nil:
    section.add "quotaUser", valid_594351
  var valid_594352 = query.getOrDefault("includeUninitialized")
  valid_594352 = validateParameter(valid_594352, JBool, required = false, default = nil)
  if valid_594352 != nil:
    section.add "includeUninitialized", valid_594352
  var valid_594353 = query.getOrDefault("alt")
  valid_594353 = validateParameter(valid_594353, JString, required = false,
                                 default = newJString("json"))
  if valid_594353 != nil:
    section.add "alt", valid_594353
  var valid_594354 = query.getOrDefault("continue")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = nil)
  if valid_594354 != nil:
    section.add "continue", valid_594354
  var valid_594355 = query.getOrDefault("oauth_token")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "oauth_token", valid_594355
  var valid_594356 = query.getOrDefault("callback")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "callback", valid_594356
  var valid_594357 = query.getOrDefault("access_token")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = nil)
  if valid_594357 != nil:
    section.add "access_token", valid_594357
  var valid_594358 = query.getOrDefault("uploadType")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "uploadType", valid_594358
  var valid_594359 = query.getOrDefault("resourceVersion")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "resourceVersion", valid_594359
  var valid_594360 = query.getOrDefault("watch")
  valid_594360 = validateParameter(valid_594360, JBool, required = false, default = nil)
  if valid_594360 != nil:
    section.add "watch", valid_594360
  var valid_594361 = query.getOrDefault("key")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "key", valid_594361
  var valid_594362 = query.getOrDefault("$.xgafv")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = newJString("1"))
  if valid_594362 != nil:
    section.add "$.xgafv", valid_594362
  var valid_594363 = query.getOrDefault("labelSelector")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "labelSelector", valid_594363
  var valid_594364 = query.getOrDefault("prettyPrint")
  valid_594364 = validateParameter(valid_594364, JBool, required = false,
                                 default = newJBool(true))
  if valid_594364 != nil:
    section.add "prettyPrint", valid_594364
  var valid_594365 = query.getOrDefault("fieldSelector")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "fieldSelector", valid_594365
  var valid_594366 = query.getOrDefault("limit")
  valid_594366 = validateParameter(valid_594366, JInt, required = false, default = nil)
  if valid_594366 != nil:
    section.add "limit", valid_594366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594367: Call_RunNamespacesServicesList_594345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list services.
  ## 
  let valid = call_594367.validator(path, query, header, formData, body)
  let scheme = call_594367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594367.url(scheme.get, call_594367.host, call_594367.base,
                         call_594367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594367, url, valid)

proc call*(call_594368: Call_RunNamespacesServicesList_594345; parent: string;
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
  var path_594369 = newJObject()
  var query_594370 = newJObject()
  add(query_594370, "upload_protocol", newJString(uploadProtocol))
  add(query_594370, "fields", newJString(fields))
  add(query_594370, "quotaUser", newJString(quotaUser))
  add(query_594370, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594370, "alt", newJString(alt))
  add(query_594370, "continue", newJString(`continue`))
  add(query_594370, "oauth_token", newJString(oauthToken))
  add(query_594370, "callback", newJString(callback))
  add(query_594370, "access_token", newJString(accessToken))
  add(query_594370, "uploadType", newJString(uploadType))
  add(path_594369, "parent", newJString(parent))
  add(query_594370, "resourceVersion", newJString(resourceVersion))
  add(query_594370, "watch", newJBool(watch))
  add(query_594370, "key", newJString(key))
  add(query_594370, "$.xgafv", newJString(Xgafv))
  add(query_594370, "labelSelector", newJString(labelSelector))
  add(query_594370, "prettyPrint", newJBool(prettyPrint))
  add(query_594370, "fieldSelector", newJString(fieldSelector))
  add(query_594370, "limit", newJInt(limit))
  result = call_594368.call(path_594369, query_594370, nil, nil, nil)

var runNamespacesServicesList* = Call_RunNamespacesServicesList_594345(
    name: "runNamespacesServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/services",
    validator: validate_RunNamespacesServicesList_594346, base: "/",
    url: url_RunNamespacesServicesList_594347, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesReplaceService_594411 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsServicesReplaceService_594413(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesReplaceService_594412(path: JsonNode;
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
  var valid_594414 = path.getOrDefault("name")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "name", valid_594414
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
  var valid_594415 = query.getOrDefault("upload_protocol")
  valid_594415 = validateParameter(valid_594415, JString, required = false,
                                 default = nil)
  if valid_594415 != nil:
    section.add "upload_protocol", valid_594415
  var valid_594416 = query.getOrDefault("fields")
  valid_594416 = validateParameter(valid_594416, JString, required = false,
                                 default = nil)
  if valid_594416 != nil:
    section.add "fields", valid_594416
  var valid_594417 = query.getOrDefault("quotaUser")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "quotaUser", valid_594417
  var valid_594418 = query.getOrDefault("alt")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = newJString("json"))
  if valid_594418 != nil:
    section.add "alt", valid_594418
  var valid_594419 = query.getOrDefault("oauth_token")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = nil)
  if valid_594419 != nil:
    section.add "oauth_token", valid_594419
  var valid_594420 = query.getOrDefault("callback")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = nil)
  if valid_594420 != nil:
    section.add "callback", valid_594420
  var valid_594421 = query.getOrDefault("access_token")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "access_token", valid_594421
  var valid_594422 = query.getOrDefault("uploadType")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "uploadType", valid_594422
  var valid_594423 = query.getOrDefault("key")
  valid_594423 = validateParameter(valid_594423, JString, required = false,
                                 default = nil)
  if valid_594423 != nil:
    section.add "key", valid_594423
  var valid_594424 = query.getOrDefault("$.xgafv")
  valid_594424 = validateParameter(valid_594424, JString, required = false,
                                 default = newJString("1"))
  if valid_594424 != nil:
    section.add "$.xgafv", valid_594424
  var valid_594425 = query.getOrDefault("prettyPrint")
  valid_594425 = validateParameter(valid_594425, JBool, required = false,
                                 default = newJBool(true))
  if valid_594425 != nil:
    section.add "prettyPrint", valid_594425
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

proc call*(call_594427: Call_RunProjectsLocationsServicesReplaceService_594411;
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
  let valid = call_594427.validator(path, query, header, formData, body)
  let scheme = call_594427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594427.url(scheme.get, call_594427.host, call_594427.base,
                         call_594427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594427, url, valid)

proc call*(call_594428: Call_RunProjectsLocationsServicesReplaceService_594411;
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
  var path_594429 = newJObject()
  var query_594430 = newJObject()
  var body_594431 = newJObject()
  add(query_594430, "upload_protocol", newJString(uploadProtocol))
  add(query_594430, "fields", newJString(fields))
  add(query_594430, "quotaUser", newJString(quotaUser))
  add(path_594429, "name", newJString(name))
  add(query_594430, "alt", newJString(alt))
  add(query_594430, "oauth_token", newJString(oauthToken))
  add(query_594430, "callback", newJString(callback))
  add(query_594430, "access_token", newJString(accessToken))
  add(query_594430, "uploadType", newJString(uploadType))
  add(query_594430, "key", newJString(key))
  add(query_594430, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594431 = body
  add(query_594430, "prettyPrint", newJBool(prettyPrint))
  result = call_594428.call(path_594429, query_594430, nil, nil, body_594431)

var runProjectsLocationsServicesReplaceService* = Call_RunProjectsLocationsServicesReplaceService_594411(
    name: "runProjectsLocationsServicesReplaceService", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsServicesReplaceService_594412,
    base: "/", url: url_RunProjectsLocationsServicesReplaceService_594413,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsGet_594392 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsDomainmappingsGet_594394(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsGet_594393(path: JsonNode;
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
  var valid_594395 = path.getOrDefault("name")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "name", valid_594395
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
  var valid_594396 = query.getOrDefault("upload_protocol")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = nil)
  if valid_594396 != nil:
    section.add "upload_protocol", valid_594396
  var valid_594397 = query.getOrDefault("fields")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = nil)
  if valid_594397 != nil:
    section.add "fields", valid_594397
  var valid_594398 = query.getOrDefault("quotaUser")
  valid_594398 = validateParameter(valid_594398, JString, required = false,
                                 default = nil)
  if valid_594398 != nil:
    section.add "quotaUser", valid_594398
  var valid_594399 = query.getOrDefault("alt")
  valid_594399 = validateParameter(valid_594399, JString, required = false,
                                 default = newJString("json"))
  if valid_594399 != nil:
    section.add "alt", valid_594399
  var valid_594400 = query.getOrDefault("oauth_token")
  valid_594400 = validateParameter(valid_594400, JString, required = false,
                                 default = nil)
  if valid_594400 != nil:
    section.add "oauth_token", valid_594400
  var valid_594401 = query.getOrDefault("callback")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "callback", valid_594401
  var valid_594402 = query.getOrDefault("access_token")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "access_token", valid_594402
  var valid_594403 = query.getOrDefault("uploadType")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "uploadType", valid_594403
  var valid_594404 = query.getOrDefault("key")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = nil)
  if valid_594404 != nil:
    section.add "key", valid_594404
  var valid_594405 = query.getOrDefault("$.xgafv")
  valid_594405 = validateParameter(valid_594405, JString, required = false,
                                 default = newJString("1"))
  if valid_594405 != nil:
    section.add "$.xgafv", valid_594405
  var valid_594406 = query.getOrDefault("prettyPrint")
  valid_594406 = validateParameter(valid_594406, JBool, required = false,
                                 default = newJBool(true))
  if valid_594406 != nil:
    section.add "prettyPrint", valid_594406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594407: Call_RunProjectsLocationsDomainmappingsGet_594392;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to get information about a domain mapping.
  ## 
  let valid = call_594407.validator(path, query, header, formData, body)
  let scheme = call_594407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594407.url(scheme.get, call_594407.host, call_594407.base,
                         call_594407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594407, url, valid)

proc call*(call_594408: Call_RunProjectsLocationsDomainmappingsGet_594392;
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
  var path_594409 = newJObject()
  var query_594410 = newJObject()
  add(query_594410, "upload_protocol", newJString(uploadProtocol))
  add(query_594410, "fields", newJString(fields))
  add(query_594410, "quotaUser", newJString(quotaUser))
  add(path_594409, "name", newJString(name))
  add(query_594410, "alt", newJString(alt))
  add(query_594410, "oauth_token", newJString(oauthToken))
  add(query_594410, "callback", newJString(callback))
  add(query_594410, "access_token", newJString(accessToken))
  add(query_594410, "uploadType", newJString(uploadType))
  add(query_594410, "key", newJString(key))
  add(query_594410, "$.xgafv", newJString(Xgafv))
  add(query_594410, "prettyPrint", newJBool(prettyPrint))
  result = call_594408.call(path_594409, query_594410, nil, nil, nil)

var runProjectsLocationsDomainmappingsGet* = Call_RunProjectsLocationsDomainmappingsGet_594392(
    name: "runProjectsLocationsDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsGet_594393, base: "/",
    url: url_RunProjectsLocationsDomainmappingsGet_594394, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsDelete_594432 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsDomainmappingsDelete_594434(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsDelete_594433(path: JsonNode;
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
  var valid_594435 = path.getOrDefault("name")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "name", valid_594435
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
  var valid_594436 = query.getOrDefault("upload_protocol")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "upload_protocol", valid_594436
  var valid_594437 = query.getOrDefault("fields")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = nil)
  if valid_594437 != nil:
    section.add "fields", valid_594437
  var valid_594438 = query.getOrDefault("orphanDependents")
  valid_594438 = validateParameter(valid_594438, JBool, required = false, default = nil)
  if valid_594438 != nil:
    section.add "orphanDependents", valid_594438
  var valid_594439 = query.getOrDefault("quotaUser")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = nil)
  if valid_594439 != nil:
    section.add "quotaUser", valid_594439
  var valid_594440 = query.getOrDefault("alt")
  valid_594440 = validateParameter(valid_594440, JString, required = false,
                                 default = newJString("json"))
  if valid_594440 != nil:
    section.add "alt", valid_594440
  var valid_594441 = query.getOrDefault("oauth_token")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = nil)
  if valid_594441 != nil:
    section.add "oauth_token", valid_594441
  var valid_594442 = query.getOrDefault("callback")
  valid_594442 = validateParameter(valid_594442, JString, required = false,
                                 default = nil)
  if valid_594442 != nil:
    section.add "callback", valid_594442
  var valid_594443 = query.getOrDefault("access_token")
  valid_594443 = validateParameter(valid_594443, JString, required = false,
                                 default = nil)
  if valid_594443 != nil:
    section.add "access_token", valid_594443
  var valid_594444 = query.getOrDefault("uploadType")
  valid_594444 = validateParameter(valid_594444, JString, required = false,
                                 default = nil)
  if valid_594444 != nil:
    section.add "uploadType", valid_594444
  var valid_594445 = query.getOrDefault("kind")
  valid_594445 = validateParameter(valid_594445, JString, required = false,
                                 default = nil)
  if valid_594445 != nil:
    section.add "kind", valid_594445
  var valid_594446 = query.getOrDefault("key")
  valid_594446 = validateParameter(valid_594446, JString, required = false,
                                 default = nil)
  if valid_594446 != nil:
    section.add "key", valid_594446
  var valid_594447 = query.getOrDefault("$.xgafv")
  valid_594447 = validateParameter(valid_594447, JString, required = false,
                                 default = newJString("1"))
  if valid_594447 != nil:
    section.add "$.xgafv", valid_594447
  var valid_594448 = query.getOrDefault("prettyPrint")
  valid_594448 = validateParameter(valid_594448, JBool, required = false,
                                 default = newJBool(true))
  if valid_594448 != nil:
    section.add "prettyPrint", valid_594448
  var valid_594449 = query.getOrDefault("propagationPolicy")
  valid_594449 = validateParameter(valid_594449, JString, required = false,
                                 default = nil)
  if valid_594449 != nil:
    section.add "propagationPolicy", valid_594449
  var valid_594450 = query.getOrDefault("apiVersion")
  valid_594450 = validateParameter(valid_594450, JString, required = false,
                                 default = nil)
  if valid_594450 != nil:
    section.add "apiVersion", valid_594450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594451: Call_RunProjectsLocationsDomainmappingsDelete_594432;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to delete a domain mapping.
  ## 
  let valid = call_594451.validator(path, query, header, formData, body)
  let scheme = call_594451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594451.url(scheme.get, call_594451.host, call_594451.base,
                         call_594451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594451, url, valid)

proc call*(call_594452: Call_RunProjectsLocationsDomainmappingsDelete_594432;
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
  var path_594453 = newJObject()
  var query_594454 = newJObject()
  add(query_594454, "upload_protocol", newJString(uploadProtocol))
  add(query_594454, "fields", newJString(fields))
  add(query_594454, "orphanDependents", newJBool(orphanDependents))
  add(query_594454, "quotaUser", newJString(quotaUser))
  add(path_594453, "name", newJString(name))
  add(query_594454, "alt", newJString(alt))
  add(query_594454, "oauth_token", newJString(oauthToken))
  add(query_594454, "callback", newJString(callback))
  add(query_594454, "access_token", newJString(accessToken))
  add(query_594454, "uploadType", newJString(uploadType))
  add(query_594454, "kind", newJString(kind))
  add(query_594454, "key", newJString(key))
  add(query_594454, "$.xgafv", newJString(Xgafv))
  add(query_594454, "prettyPrint", newJBool(prettyPrint))
  add(query_594454, "propagationPolicy", newJString(propagationPolicy))
  add(query_594454, "apiVersion", newJString(apiVersion))
  result = call_594452.call(path_594453, query_594454, nil, nil, nil)

var runProjectsLocationsDomainmappingsDelete* = Call_RunProjectsLocationsDomainmappingsDelete_594432(
    name: "runProjectsLocationsDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsDelete_594433,
    base: "/", url: url_RunProjectsLocationsDomainmappingsDelete_594434,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsList_594455 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsList_594457(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsList_594456(path: JsonNode; query: JsonNode;
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
  var valid_594458 = path.getOrDefault("name")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "name", valid_594458
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
  var valid_594459 = query.getOrDefault("upload_protocol")
  valid_594459 = validateParameter(valid_594459, JString, required = false,
                                 default = nil)
  if valid_594459 != nil:
    section.add "upload_protocol", valid_594459
  var valid_594460 = query.getOrDefault("fields")
  valid_594460 = validateParameter(valid_594460, JString, required = false,
                                 default = nil)
  if valid_594460 != nil:
    section.add "fields", valid_594460
  var valid_594461 = query.getOrDefault("pageToken")
  valid_594461 = validateParameter(valid_594461, JString, required = false,
                                 default = nil)
  if valid_594461 != nil:
    section.add "pageToken", valid_594461
  var valid_594462 = query.getOrDefault("quotaUser")
  valid_594462 = validateParameter(valid_594462, JString, required = false,
                                 default = nil)
  if valid_594462 != nil:
    section.add "quotaUser", valid_594462
  var valid_594463 = query.getOrDefault("alt")
  valid_594463 = validateParameter(valid_594463, JString, required = false,
                                 default = newJString("json"))
  if valid_594463 != nil:
    section.add "alt", valid_594463
  var valid_594464 = query.getOrDefault("oauth_token")
  valid_594464 = validateParameter(valid_594464, JString, required = false,
                                 default = nil)
  if valid_594464 != nil:
    section.add "oauth_token", valid_594464
  var valid_594465 = query.getOrDefault("callback")
  valid_594465 = validateParameter(valid_594465, JString, required = false,
                                 default = nil)
  if valid_594465 != nil:
    section.add "callback", valid_594465
  var valid_594466 = query.getOrDefault("access_token")
  valid_594466 = validateParameter(valid_594466, JString, required = false,
                                 default = nil)
  if valid_594466 != nil:
    section.add "access_token", valid_594466
  var valid_594467 = query.getOrDefault("uploadType")
  valid_594467 = validateParameter(valid_594467, JString, required = false,
                                 default = nil)
  if valid_594467 != nil:
    section.add "uploadType", valid_594467
  var valid_594468 = query.getOrDefault("key")
  valid_594468 = validateParameter(valid_594468, JString, required = false,
                                 default = nil)
  if valid_594468 != nil:
    section.add "key", valid_594468
  var valid_594469 = query.getOrDefault("$.xgafv")
  valid_594469 = validateParameter(valid_594469, JString, required = false,
                                 default = newJString("1"))
  if valid_594469 != nil:
    section.add "$.xgafv", valid_594469
  var valid_594470 = query.getOrDefault("pageSize")
  valid_594470 = validateParameter(valid_594470, JInt, required = false, default = nil)
  if valid_594470 != nil:
    section.add "pageSize", valid_594470
  var valid_594471 = query.getOrDefault("prettyPrint")
  valid_594471 = validateParameter(valid_594471, JBool, required = false,
                                 default = newJBool(true))
  if valid_594471 != nil:
    section.add "prettyPrint", valid_594471
  var valid_594472 = query.getOrDefault("filter")
  valid_594472 = validateParameter(valid_594472, JString, required = false,
                                 default = nil)
  if valid_594472 != nil:
    section.add "filter", valid_594472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594473: Call_RunProjectsLocationsList_594455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_594473.validator(path, query, header, formData, body)
  let scheme = call_594473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594473.url(scheme.get, call_594473.host, call_594473.base,
                         call_594473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594473, url, valid)

proc call*(call_594474: Call_RunProjectsLocationsList_594455; name: string;
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
  var path_594475 = newJObject()
  var query_594476 = newJObject()
  add(query_594476, "upload_protocol", newJString(uploadProtocol))
  add(query_594476, "fields", newJString(fields))
  add(query_594476, "pageToken", newJString(pageToken))
  add(query_594476, "quotaUser", newJString(quotaUser))
  add(path_594475, "name", newJString(name))
  add(query_594476, "alt", newJString(alt))
  add(query_594476, "oauth_token", newJString(oauthToken))
  add(query_594476, "callback", newJString(callback))
  add(query_594476, "access_token", newJString(accessToken))
  add(query_594476, "uploadType", newJString(uploadType))
  add(query_594476, "key", newJString(key))
  add(query_594476, "$.xgafv", newJString(Xgafv))
  add(query_594476, "pageSize", newJInt(pageSize))
  add(query_594476, "prettyPrint", newJBool(prettyPrint))
  add(query_594476, "filter", newJString(filter))
  result = call_594474.call(path_594475, query_594476, nil, nil, nil)

var runProjectsLocationsList* = Call_RunProjectsLocationsList_594455(
    name: "runProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{name}/locations",
    validator: validate_RunProjectsLocationsList_594456, base: "/",
    url: url_RunProjectsLocationsList_594457, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAuthorizeddomainsList_594477 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsAuthorizeddomainsList_594479(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsAuthorizeddomainsList_594478(path: JsonNode;
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
  var valid_594480 = path.getOrDefault("parent")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "parent", valid_594480
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
  var valid_594481 = query.getOrDefault("upload_protocol")
  valid_594481 = validateParameter(valid_594481, JString, required = false,
                                 default = nil)
  if valid_594481 != nil:
    section.add "upload_protocol", valid_594481
  var valid_594482 = query.getOrDefault("fields")
  valid_594482 = validateParameter(valid_594482, JString, required = false,
                                 default = nil)
  if valid_594482 != nil:
    section.add "fields", valid_594482
  var valid_594483 = query.getOrDefault("pageToken")
  valid_594483 = validateParameter(valid_594483, JString, required = false,
                                 default = nil)
  if valid_594483 != nil:
    section.add "pageToken", valid_594483
  var valid_594484 = query.getOrDefault("quotaUser")
  valid_594484 = validateParameter(valid_594484, JString, required = false,
                                 default = nil)
  if valid_594484 != nil:
    section.add "quotaUser", valid_594484
  var valid_594485 = query.getOrDefault("alt")
  valid_594485 = validateParameter(valid_594485, JString, required = false,
                                 default = newJString("json"))
  if valid_594485 != nil:
    section.add "alt", valid_594485
  var valid_594486 = query.getOrDefault("oauth_token")
  valid_594486 = validateParameter(valid_594486, JString, required = false,
                                 default = nil)
  if valid_594486 != nil:
    section.add "oauth_token", valid_594486
  var valid_594487 = query.getOrDefault("callback")
  valid_594487 = validateParameter(valid_594487, JString, required = false,
                                 default = nil)
  if valid_594487 != nil:
    section.add "callback", valid_594487
  var valid_594488 = query.getOrDefault("access_token")
  valid_594488 = validateParameter(valid_594488, JString, required = false,
                                 default = nil)
  if valid_594488 != nil:
    section.add "access_token", valid_594488
  var valid_594489 = query.getOrDefault("uploadType")
  valid_594489 = validateParameter(valid_594489, JString, required = false,
                                 default = nil)
  if valid_594489 != nil:
    section.add "uploadType", valid_594489
  var valid_594490 = query.getOrDefault("key")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = nil)
  if valid_594490 != nil:
    section.add "key", valid_594490
  var valid_594491 = query.getOrDefault("$.xgafv")
  valid_594491 = validateParameter(valid_594491, JString, required = false,
                                 default = newJString("1"))
  if valid_594491 != nil:
    section.add "$.xgafv", valid_594491
  var valid_594492 = query.getOrDefault("pageSize")
  valid_594492 = validateParameter(valid_594492, JInt, required = false, default = nil)
  if valid_594492 != nil:
    section.add "pageSize", valid_594492
  var valid_594493 = query.getOrDefault("prettyPrint")
  valid_594493 = validateParameter(valid_594493, JBool, required = false,
                                 default = newJBool(true))
  if valid_594493 != nil:
    section.add "prettyPrint", valid_594493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594494: Call_RunProjectsLocationsAuthorizeddomainsList_594477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RPC to list authorized domains.
  ## 
  let valid = call_594494.validator(path, query, header, formData, body)
  let scheme = call_594494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594494.url(scheme.get, call_594494.host, call_594494.base,
                         call_594494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594494, url, valid)

proc call*(call_594495: Call_RunProjectsLocationsAuthorizeddomainsList_594477;
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
  var path_594496 = newJObject()
  var query_594497 = newJObject()
  add(query_594497, "upload_protocol", newJString(uploadProtocol))
  add(query_594497, "fields", newJString(fields))
  add(query_594497, "pageToken", newJString(pageToken))
  add(query_594497, "quotaUser", newJString(quotaUser))
  add(query_594497, "alt", newJString(alt))
  add(query_594497, "oauth_token", newJString(oauthToken))
  add(query_594497, "callback", newJString(callback))
  add(query_594497, "access_token", newJString(accessToken))
  add(query_594497, "uploadType", newJString(uploadType))
  add(path_594496, "parent", newJString(parent))
  add(query_594497, "key", newJString(key))
  add(query_594497, "$.xgafv", newJString(Xgafv))
  add(query_594497, "pageSize", newJInt(pageSize))
  add(query_594497, "prettyPrint", newJBool(prettyPrint))
  result = call_594495.call(path_594496, query_594497, nil, nil, nil)

var runProjectsLocationsAuthorizeddomainsList* = Call_RunProjectsLocationsAuthorizeddomainsList_594477(
    name: "runProjectsLocationsAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/authorizeddomains",
    validator: validate_RunProjectsLocationsAuthorizeddomainsList_594478,
    base: "/", url: url_RunProjectsLocationsAuthorizeddomainsList_594479,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsList_594498 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsConfigurationsList_594500(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsConfigurationsList_594499(path: JsonNode;
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
  var valid_594501 = path.getOrDefault("parent")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "parent", valid_594501
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
  var valid_594502 = query.getOrDefault("upload_protocol")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = nil)
  if valid_594502 != nil:
    section.add "upload_protocol", valid_594502
  var valid_594503 = query.getOrDefault("fields")
  valid_594503 = validateParameter(valid_594503, JString, required = false,
                                 default = nil)
  if valid_594503 != nil:
    section.add "fields", valid_594503
  var valid_594504 = query.getOrDefault("quotaUser")
  valid_594504 = validateParameter(valid_594504, JString, required = false,
                                 default = nil)
  if valid_594504 != nil:
    section.add "quotaUser", valid_594504
  var valid_594505 = query.getOrDefault("includeUninitialized")
  valid_594505 = validateParameter(valid_594505, JBool, required = false, default = nil)
  if valid_594505 != nil:
    section.add "includeUninitialized", valid_594505
  var valid_594506 = query.getOrDefault("alt")
  valid_594506 = validateParameter(valid_594506, JString, required = false,
                                 default = newJString("json"))
  if valid_594506 != nil:
    section.add "alt", valid_594506
  var valid_594507 = query.getOrDefault("continue")
  valid_594507 = validateParameter(valid_594507, JString, required = false,
                                 default = nil)
  if valid_594507 != nil:
    section.add "continue", valid_594507
  var valid_594508 = query.getOrDefault("oauth_token")
  valid_594508 = validateParameter(valid_594508, JString, required = false,
                                 default = nil)
  if valid_594508 != nil:
    section.add "oauth_token", valid_594508
  var valid_594509 = query.getOrDefault("callback")
  valid_594509 = validateParameter(valid_594509, JString, required = false,
                                 default = nil)
  if valid_594509 != nil:
    section.add "callback", valid_594509
  var valid_594510 = query.getOrDefault("access_token")
  valid_594510 = validateParameter(valid_594510, JString, required = false,
                                 default = nil)
  if valid_594510 != nil:
    section.add "access_token", valid_594510
  var valid_594511 = query.getOrDefault("uploadType")
  valid_594511 = validateParameter(valid_594511, JString, required = false,
                                 default = nil)
  if valid_594511 != nil:
    section.add "uploadType", valid_594511
  var valid_594512 = query.getOrDefault("resourceVersion")
  valid_594512 = validateParameter(valid_594512, JString, required = false,
                                 default = nil)
  if valid_594512 != nil:
    section.add "resourceVersion", valid_594512
  var valid_594513 = query.getOrDefault("watch")
  valid_594513 = validateParameter(valid_594513, JBool, required = false, default = nil)
  if valid_594513 != nil:
    section.add "watch", valid_594513
  var valid_594514 = query.getOrDefault("key")
  valid_594514 = validateParameter(valid_594514, JString, required = false,
                                 default = nil)
  if valid_594514 != nil:
    section.add "key", valid_594514
  var valid_594515 = query.getOrDefault("$.xgafv")
  valid_594515 = validateParameter(valid_594515, JString, required = false,
                                 default = newJString("1"))
  if valid_594515 != nil:
    section.add "$.xgafv", valid_594515
  var valid_594516 = query.getOrDefault("labelSelector")
  valid_594516 = validateParameter(valid_594516, JString, required = false,
                                 default = nil)
  if valid_594516 != nil:
    section.add "labelSelector", valid_594516
  var valid_594517 = query.getOrDefault("prettyPrint")
  valid_594517 = validateParameter(valid_594517, JBool, required = false,
                                 default = newJBool(true))
  if valid_594517 != nil:
    section.add "prettyPrint", valid_594517
  var valid_594518 = query.getOrDefault("fieldSelector")
  valid_594518 = validateParameter(valid_594518, JString, required = false,
                                 default = nil)
  if valid_594518 != nil:
    section.add "fieldSelector", valid_594518
  var valid_594519 = query.getOrDefault("limit")
  valid_594519 = validateParameter(valid_594519, JInt, required = false, default = nil)
  if valid_594519 != nil:
    section.add "limit", valid_594519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594520: Call_RunProjectsLocationsConfigurationsList_594498;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list configurations.
  ## 
  let valid = call_594520.validator(path, query, header, formData, body)
  let scheme = call_594520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594520.url(scheme.get, call_594520.host, call_594520.base,
                         call_594520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594520, url, valid)

proc call*(call_594521: Call_RunProjectsLocationsConfigurationsList_594498;
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
  var path_594522 = newJObject()
  var query_594523 = newJObject()
  add(query_594523, "upload_protocol", newJString(uploadProtocol))
  add(query_594523, "fields", newJString(fields))
  add(query_594523, "quotaUser", newJString(quotaUser))
  add(query_594523, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594523, "alt", newJString(alt))
  add(query_594523, "continue", newJString(`continue`))
  add(query_594523, "oauth_token", newJString(oauthToken))
  add(query_594523, "callback", newJString(callback))
  add(query_594523, "access_token", newJString(accessToken))
  add(query_594523, "uploadType", newJString(uploadType))
  add(path_594522, "parent", newJString(parent))
  add(query_594523, "resourceVersion", newJString(resourceVersion))
  add(query_594523, "watch", newJBool(watch))
  add(query_594523, "key", newJString(key))
  add(query_594523, "$.xgafv", newJString(Xgafv))
  add(query_594523, "labelSelector", newJString(labelSelector))
  add(query_594523, "prettyPrint", newJBool(prettyPrint))
  add(query_594523, "fieldSelector", newJString(fieldSelector))
  add(query_594523, "limit", newJInt(limit))
  result = call_594521.call(path_594522, query_594523, nil, nil, nil)

var runProjectsLocationsConfigurationsList* = Call_RunProjectsLocationsConfigurationsList_594498(
    name: "runProjectsLocationsConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsList_594499, base: "/",
    url: url_RunProjectsLocationsConfigurationsList_594500,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsCreate_594550 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsDomainmappingsCreate_594552(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsDomainmappingsCreate_594551(path: JsonNode;
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
  var valid_594553 = path.getOrDefault("parent")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "parent", valid_594553
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
  var valid_594554 = query.getOrDefault("upload_protocol")
  valid_594554 = validateParameter(valid_594554, JString, required = false,
                                 default = nil)
  if valid_594554 != nil:
    section.add "upload_protocol", valid_594554
  var valid_594555 = query.getOrDefault("fields")
  valid_594555 = validateParameter(valid_594555, JString, required = false,
                                 default = nil)
  if valid_594555 != nil:
    section.add "fields", valid_594555
  var valid_594556 = query.getOrDefault("quotaUser")
  valid_594556 = validateParameter(valid_594556, JString, required = false,
                                 default = nil)
  if valid_594556 != nil:
    section.add "quotaUser", valid_594556
  var valid_594557 = query.getOrDefault("alt")
  valid_594557 = validateParameter(valid_594557, JString, required = false,
                                 default = newJString("json"))
  if valid_594557 != nil:
    section.add "alt", valid_594557
  var valid_594558 = query.getOrDefault("oauth_token")
  valid_594558 = validateParameter(valid_594558, JString, required = false,
                                 default = nil)
  if valid_594558 != nil:
    section.add "oauth_token", valid_594558
  var valid_594559 = query.getOrDefault("callback")
  valid_594559 = validateParameter(valid_594559, JString, required = false,
                                 default = nil)
  if valid_594559 != nil:
    section.add "callback", valid_594559
  var valid_594560 = query.getOrDefault("access_token")
  valid_594560 = validateParameter(valid_594560, JString, required = false,
                                 default = nil)
  if valid_594560 != nil:
    section.add "access_token", valid_594560
  var valid_594561 = query.getOrDefault("uploadType")
  valid_594561 = validateParameter(valid_594561, JString, required = false,
                                 default = nil)
  if valid_594561 != nil:
    section.add "uploadType", valid_594561
  var valid_594562 = query.getOrDefault("key")
  valid_594562 = validateParameter(valid_594562, JString, required = false,
                                 default = nil)
  if valid_594562 != nil:
    section.add "key", valid_594562
  var valid_594563 = query.getOrDefault("$.xgafv")
  valid_594563 = validateParameter(valid_594563, JString, required = false,
                                 default = newJString("1"))
  if valid_594563 != nil:
    section.add "$.xgafv", valid_594563
  var valid_594564 = query.getOrDefault("prettyPrint")
  valid_594564 = validateParameter(valid_594564, JBool, required = false,
                                 default = newJBool(true))
  if valid_594564 != nil:
    section.add "prettyPrint", valid_594564
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

proc call*(call_594566: Call_RunProjectsLocationsDomainmappingsCreate_594550;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new domain mapping.
  ## 
  let valid = call_594566.validator(path, query, header, formData, body)
  let scheme = call_594566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594566.url(scheme.get, call_594566.host, call_594566.base,
                         call_594566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594566, url, valid)

proc call*(call_594567: Call_RunProjectsLocationsDomainmappingsCreate_594550;
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
  var path_594568 = newJObject()
  var query_594569 = newJObject()
  var body_594570 = newJObject()
  add(query_594569, "upload_protocol", newJString(uploadProtocol))
  add(query_594569, "fields", newJString(fields))
  add(query_594569, "quotaUser", newJString(quotaUser))
  add(query_594569, "alt", newJString(alt))
  add(query_594569, "oauth_token", newJString(oauthToken))
  add(query_594569, "callback", newJString(callback))
  add(query_594569, "access_token", newJString(accessToken))
  add(query_594569, "uploadType", newJString(uploadType))
  add(path_594568, "parent", newJString(parent))
  add(query_594569, "key", newJString(key))
  add(query_594569, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594570 = body
  add(query_594569, "prettyPrint", newJBool(prettyPrint))
  result = call_594567.call(path_594568, query_594569, nil, nil, body_594570)

var runProjectsLocationsDomainmappingsCreate* = Call_RunProjectsLocationsDomainmappingsCreate_594550(
    name: "runProjectsLocationsDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsCreate_594551,
    base: "/", url: url_RunProjectsLocationsDomainmappingsCreate_594552,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsList_594524 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsDomainmappingsList_594526(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsDomainmappingsList_594525(path: JsonNode;
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
  var valid_594527 = path.getOrDefault("parent")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "parent", valid_594527
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
  var valid_594528 = query.getOrDefault("upload_protocol")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = nil)
  if valid_594528 != nil:
    section.add "upload_protocol", valid_594528
  var valid_594529 = query.getOrDefault("fields")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = nil)
  if valid_594529 != nil:
    section.add "fields", valid_594529
  var valid_594530 = query.getOrDefault("quotaUser")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = nil)
  if valid_594530 != nil:
    section.add "quotaUser", valid_594530
  var valid_594531 = query.getOrDefault("includeUninitialized")
  valid_594531 = validateParameter(valid_594531, JBool, required = false, default = nil)
  if valid_594531 != nil:
    section.add "includeUninitialized", valid_594531
  var valid_594532 = query.getOrDefault("alt")
  valid_594532 = validateParameter(valid_594532, JString, required = false,
                                 default = newJString("json"))
  if valid_594532 != nil:
    section.add "alt", valid_594532
  var valid_594533 = query.getOrDefault("continue")
  valid_594533 = validateParameter(valid_594533, JString, required = false,
                                 default = nil)
  if valid_594533 != nil:
    section.add "continue", valid_594533
  var valid_594534 = query.getOrDefault("oauth_token")
  valid_594534 = validateParameter(valid_594534, JString, required = false,
                                 default = nil)
  if valid_594534 != nil:
    section.add "oauth_token", valid_594534
  var valid_594535 = query.getOrDefault("callback")
  valid_594535 = validateParameter(valid_594535, JString, required = false,
                                 default = nil)
  if valid_594535 != nil:
    section.add "callback", valid_594535
  var valid_594536 = query.getOrDefault("access_token")
  valid_594536 = validateParameter(valid_594536, JString, required = false,
                                 default = nil)
  if valid_594536 != nil:
    section.add "access_token", valid_594536
  var valid_594537 = query.getOrDefault("uploadType")
  valid_594537 = validateParameter(valid_594537, JString, required = false,
                                 default = nil)
  if valid_594537 != nil:
    section.add "uploadType", valid_594537
  var valid_594538 = query.getOrDefault("resourceVersion")
  valid_594538 = validateParameter(valid_594538, JString, required = false,
                                 default = nil)
  if valid_594538 != nil:
    section.add "resourceVersion", valid_594538
  var valid_594539 = query.getOrDefault("watch")
  valid_594539 = validateParameter(valid_594539, JBool, required = false, default = nil)
  if valid_594539 != nil:
    section.add "watch", valid_594539
  var valid_594540 = query.getOrDefault("key")
  valid_594540 = validateParameter(valid_594540, JString, required = false,
                                 default = nil)
  if valid_594540 != nil:
    section.add "key", valid_594540
  var valid_594541 = query.getOrDefault("$.xgafv")
  valid_594541 = validateParameter(valid_594541, JString, required = false,
                                 default = newJString("1"))
  if valid_594541 != nil:
    section.add "$.xgafv", valid_594541
  var valid_594542 = query.getOrDefault("labelSelector")
  valid_594542 = validateParameter(valid_594542, JString, required = false,
                                 default = nil)
  if valid_594542 != nil:
    section.add "labelSelector", valid_594542
  var valid_594543 = query.getOrDefault("prettyPrint")
  valid_594543 = validateParameter(valid_594543, JBool, required = false,
                                 default = newJBool(true))
  if valid_594543 != nil:
    section.add "prettyPrint", valid_594543
  var valid_594544 = query.getOrDefault("fieldSelector")
  valid_594544 = validateParameter(valid_594544, JString, required = false,
                                 default = nil)
  if valid_594544 != nil:
    section.add "fieldSelector", valid_594544
  var valid_594545 = query.getOrDefault("limit")
  valid_594545 = validateParameter(valid_594545, JInt, required = false, default = nil)
  if valid_594545 != nil:
    section.add "limit", valid_594545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594546: Call_RunProjectsLocationsDomainmappingsList_594524;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list domain mappings.
  ## 
  let valid = call_594546.validator(path, query, header, formData, body)
  let scheme = call_594546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594546.url(scheme.get, call_594546.host, call_594546.base,
                         call_594546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594546, url, valid)

proc call*(call_594547: Call_RunProjectsLocationsDomainmappingsList_594524;
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
  var path_594548 = newJObject()
  var query_594549 = newJObject()
  add(query_594549, "upload_protocol", newJString(uploadProtocol))
  add(query_594549, "fields", newJString(fields))
  add(query_594549, "quotaUser", newJString(quotaUser))
  add(query_594549, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594549, "alt", newJString(alt))
  add(query_594549, "continue", newJString(`continue`))
  add(query_594549, "oauth_token", newJString(oauthToken))
  add(query_594549, "callback", newJString(callback))
  add(query_594549, "access_token", newJString(accessToken))
  add(query_594549, "uploadType", newJString(uploadType))
  add(path_594548, "parent", newJString(parent))
  add(query_594549, "resourceVersion", newJString(resourceVersion))
  add(query_594549, "watch", newJBool(watch))
  add(query_594549, "key", newJString(key))
  add(query_594549, "$.xgafv", newJString(Xgafv))
  add(query_594549, "labelSelector", newJString(labelSelector))
  add(query_594549, "prettyPrint", newJBool(prettyPrint))
  add(query_594549, "fieldSelector", newJString(fieldSelector))
  add(query_594549, "limit", newJInt(limit))
  result = call_594547.call(path_594548, query_594549, nil, nil, nil)

var runProjectsLocationsDomainmappingsList* = Call_RunProjectsLocationsDomainmappingsList_594524(
    name: "runProjectsLocationsDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsList_594525, base: "/",
    url: url_RunProjectsLocationsDomainmappingsList_594526,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsEventtypesList_594571 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsEventtypesList_594573(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsEventtypesList_594572(path: JsonNode;
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
  var valid_594574 = path.getOrDefault("parent")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "parent", valid_594574
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
  var valid_594575 = query.getOrDefault("upload_protocol")
  valid_594575 = validateParameter(valid_594575, JString, required = false,
                                 default = nil)
  if valid_594575 != nil:
    section.add "upload_protocol", valid_594575
  var valid_594576 = query.getOrDefault("fields")
  valid_594576 = validateParameter(valid_594576, JString, required = false,
                                 default = nil)
  if valid_594576 != nil:
    section.add "fields", valid_594576
  var valid_594577 = query.getOrDefault("quotaUser")
  valid_594577 = validateParameter(valid_594577, JString, required = false,
                                 default = nil)
  if valid_594577 != nil:
    section.add "quotaUser", valid_594577
  var valid_594578 = query.getOrDefault("includeUninitialized")
  valid_594578 = validateParameter(valid_594578, JBool, required = false, default = nil)
  if valid_594578 != nil:
    section.add "includeUninitialized", valid_594578
  var valid_594579 = query.getOrDefault("alt")
  valid_594579 = validateParameter(valid_594579, JString, required = false,
                                 default = newJString("json"))
  if valid_594579 != nil:
    section.add "alt", valid_594579
  var valid_594580 = query.getOrDefault("continue")
  valid_594580 = validateParameter(valid_594580, JString, required = false,
                                 default = nil)
  if valid_594580 != nil:
    section.add "continue", valid_594580
  var valid_594581 = query.getOrDefault("oauth_token")
  valid_594581 = validateParameter(valid_594581, JString, required = false,
                                 default = nil)
  if valid_594581 != nil:
    section.add "oauth_token", valid_594581
  var valid_594582 = query.getOrDefault("callback")
  valid_594582 = validateParameter(valid_594582, JString, required = false,
                                 default = nil)
  if valid_594582 != nil:
    section.add "callback", valid_594582
  var valid_594583 = query.getOrDefault("access_token")
  valid_594583 = validateParameter(valid_594583, JString, required = false,
                                 default = nil)
  if valid_594583 != nil:
    section.add "access_token", valid_594583
  var valid_594584 = query.getOrDefault("uploadType")
  valid_594584 = validateParameter(valid_594584, JString, required = false,
                                 default = nil)
  if valid_594584 != nil:
    section.add "uploadType", valid_594584
  var valid_594585 = query.getOrDefault("resourceVersion")
  valid_594585 = validateParameter(valid_594585, JString, required = false,
                                 default = nil)
  if valid_594585 != nil:
    section.add "resourceVersion", valid_594585
  var valid_594586 = query.getOrDefault("watch")
  valid_594586 = validateParameter(valid_594586, JBool, required = false, default = nil)
  if valid_594586 != nil:
    section.add "watch", valid_594586
  var valid_594587 = query.getOrDefault("key")
  valid_594587 = validateParameter(valid_594587, JString, required = false,
                                 default = nil)
  if valid_594587 != nil:
    section.add "key", valid_594587
  var valid_594588 = query.getOrDefault("$.xgafv")
  valid_594588 = validateParameter(valid_594588, JString, required = false,
                                 default = newJString("1"))
  if valid_594588 != nil:
    section.add "$.xgafv", valid_594588
  var valid_594589 = query.getOrDefault("labelSelector")
  valid_594589 = validateParameter(valid_594589, JString, required = false,
                                 default = nil)
  if valid_594589 != nil:
    section.add "labelSelector", valid_594589
  var valid_594590 = query.getOrDefault("prettyPrint")
  valid_594590 = validateParameter(valid_594590, JBool, required = false,
                                 default = newJBool(true))
  if valid_594590 != nil:
    section.add "prettyPrint", valid_594590
  var valid_594591 = query.getOrDefault("fieldSelector")
  valid_594591 = validateParameter(valid_594591, JString, required = false,
                                 default = nil)
  if valid_594591 != nil:
    section.add "fieldSelector", valid_594591
  var valid_594592 = query.getOrDefault("limit")
  valid_594592 = validateParameter(valid_594592, JInt, required = false, default = nil)
  if valid_594592 != nil:
    section.add "limit", valid_594592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594593: Call_RunProjectsLocationsEventtypesList_594571;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list EventTypes.
  ## 
  let valid = call_594593.validator(path, query, header, formData, body)
  let scheme = call_594593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594593.url(scheme.get, call_594593.host, call_594593.base,
                         call_594593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594593, url, valid)

proc call*(call_594594: Call_RunProjectsLocationsEventtypesList_594571;
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
  var path_594595 = newJObject()
  var query_594596 = newJObject()
  add(query_594596, "upload_protocol", newJString(uploadProtocol))
  add(query_594596, "fields", newJString(fields))
  add(query_594596, "quotaUser", newJString(quotaUser))
  add(query_594596, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594596, "alt", newJString(alt))
  add(query_594596, "continue", newJString(`continue`))
  add(query_594596, "oauth_token", newJString(oauthToken))
  add(query_594596, "callback", newJString(callback))
  add(query_594596, "access_token", newJString(accessToken))
  add(query_594596, "uploadType", newJString(uploadType))
  add(path_594595, "parent", newJString(parent))
  add(query_594596, "resourceVersion", newJString(resourceVersion))
  add(query_594596, "watch", newJBool(watch))
  add(query_594596, "key", newJString(key))
  add(query_594596, "$.xgafv", newJString(Xgafv))
  add(query_594596, "labelSelector", newJString(labelSelector))
  add(query_594596, "prettyPrint", newJBool(prettyPrint))
  add(query_594596, "fieldSelector", newJString(fieldSelector))
  add(query_594596, "limit", newJInt(limit))
  result = call_594594.call(path_594595, query_594596, nil, nil, nil)

var runProjectsLocationsEventtypesList* = Call_RunProjectsLocationsEventtypesList_594571(
    name: "runProjectsLocationsEventtypesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/eventtypes",
    validator: validate_RunProjectsLocationsEventtypesList_594572, base: "/",
    url: url_RunProjectsLocationsEventtypesList_594573, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRevisionsList_594597 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsRevisionsList_594599(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsRevisionsList_594598(path: JsonNode;
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
  var valid_594600 = path.getOrDefault("parent")
  valid_594600 = validateParameter(valid_594600, JString, required = true,
                                 default = nil)
  if valid_594600 != nil:
    section.add "parent", valid_594600
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
  var valid_594601 = query.getOrDefault("upload_protocol")
  valid_594601 = validateParameter(valid_594601, JString, required = false,
                                 default = nil)
  if valid_594601 != nil:
    section.add "upload_protocol", valid_594601
  var valid_594602 = query.getOrDefault("fields")
  valid_594602 = validateParameter(valid_594602, JString, required = false,
                                 default = nil)
  if valid_594602 != nil:
    section.add "fields", valid_594602
  var valid_594603 = query.getOrDefault("quotaUser")
  valid_594603 = validateParameter(valid_594603, JString, required = false,
                                 default = nil)
  if valid_594603 != nil:
    section.add "quotaUser", valid_594603
  var valid_594604 = query.getOrDefault("includeUninitialized")
  valid_594604 = validateParameter(valid_594604, JBool, required = false, default = nil)
  if valid_594604 != nil:
    section.add "includeUninitialized", valid_594604
  var valid_594605 = query.getOrDefault("alt")
  valid_594605 = validateParameter(valid_594605, JString, required = false,
                                 default = newJString("json"))
  if valid_594605 != nil:
    section.add "alt", valid_594605
  var valid_594606 = query.getOrDefault("continue")
  valid_594606 = validateParameter(valid_594606, JString, required = false,
                                 default = nil)
  if valid_594606 != nil:
    section.add "continue", valid_594606
  var valid_594607 = query.getOrDefault("oauth_token")
  valid_594607 = validateParameter(valid_594607, JString, required = false,
                                 default = nil)
  if valid_594607 != nil:
    section.add "oauth_token", valid_594607
  var valid_594608 = query.getOrDefault("callback")
  valid_594608 = validateParameter(valid_594608, JString, required = false,
                                 default = nil)
  if valid_594608 != nil:
    section.add "callback", valid_594608
  var valid_594609 = query.getOrDefault("access_token")
  valid_594609 = validateParameter(valid_594609, JString, required = false,
                                 default = nil)
  if valid_594609 != nil:
    section.add "access_token", valid_594609
  var valid_594610 = query.getOrDefault("uploadType")
  valid_594610 = validateParameter(valid_594610, JString, required = false,
                                 default = nil)
  if valid_594610 != nil:
    section.add "uploadType", valid_594610
  var valid_594611 = query.getOrDefault("resourceVersion")
  valid_594611 = validateParameter(valid_594611, JString, required = false,
                                 default = nil)
  if valid_594611 != nil:
    section.add "resourceVersion", valid_594611
  var valid_594612 = query.getOrDefault("watch")
  valid_594612 = validateParameter(valid_594612, JBool, required = false, default = nil)
  if valid_594612 != nil:
    section.add "watch", valid_594612
  var valid_594613 = query.getOrDefault("key")
  valid_594613 = validateParameter(valid_594613, JString, required = false,
                                 default = nil)
  if valid_594613 != nil:
    section.add "key", valid_594613
  var valid_594614 = query.getOrDefault("$.xgafv")
  valid_594614 = validateParameter(valid_594614, JString, required = false,
                                 default = newJString("1"))
  if valid_594614 != nil:
    section.add "$.xgafv", valid_594614
  var valid_594615 = query.getOrDefault("labelSelector")
  valid_594615 = validateParameter(valid_594615, JString, required = false,
                                 default = nil)
  if valid_594615 != nil:
    section.add "labelSelector", valid_594615
  var valid_594616 = query.getOrDefault("prettyPrint")
  valid_594616 = validateParameter(valid_594616, JBool, required = false,
                                 default = newJBool(true))
  if valid_594616 != nil:
    section.add "prettyPrint", valid_594616
  var valid_594617 = query.getOrDefault("fieldSelector")
  valid_594617 = validateParameter(valid_594617, JString, required = false,
                                 default = nil)
  if valid_594617 != nil:
    section.add "fieldSelector", valid_594617
  var valid_594618 = query.getOrDefault("limit")
  valid_594618 = validateParameter(valid_594618, JInt, required = false, default = nil)
  if valid_594618 != nil:
    section.add "limit", valid_594618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594619: Call_RunProjectsLocationsRevisionsList_594597;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list revisions.
  ## 
  let valid = call_594619.validator(path, query, header, formData, body)
  let scheme = call_594619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594619.url(scheme.get, call_594619.host, call_594619.base,
                         call_594619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594619, url, valid)

proc call*(call_594620: Call_RunProjectsLocationsRevisionsList_594597;
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
  var path_594621 = newJObject()
  var query_594622 = newJObject()
  add(query_594622, "upload_protocol", newJString(uploadProtocol))
  add(query_594622, "fields", newJString(fields))
  add(query_594622, "quotaUser", newJString(quotaUser))
  add(query_594622, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594622, "alt", newJString(alt))
  add(query_594622, "continue", newJString(`continue`))
  add(query_594622, "oauth_token", newJString(oauthToken))
  add(query_594622, "callback", newJString(callback))
  add(query_594622, "access_token", newJString(accessToken))
  add(query_594622, "uploadType", newJString(uploadType))
  add(path_594621, "parent", newJString(parent))
  add(query_594622, "resourceVersion", newJString(resourceVersion))
  add(query_594622, "watch", newJBool(watch))
  add(query_594622, "key", newJString(key))
  add(query_594622, "$.xgafv", newJString(Xgafv))
  add(query_594622, "labelSelector", newJString(labelSelector))
  add(query_594622, "prettyPrint", newJBool(prettyPrint))
  add(query_594622, "fieldSelector", newJString(fieldSelector))
  add(query_594622, "limit", newJInt(limit))
  result = call_594620.call(path_594621, query_594622, nil, nil, nil)

var runProjectsLocationsRevisionsList* = Call_RunProjectsLocationsRevisionsList_594597(
    name: "runProjectsLocationsRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/revisions",
    validator: validate_RunProjectsLocationsRevisionsList_594598, base: "/",
    url: url_RunProjectsLocationsRevisionsList_594599, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesList_594623 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsRoutesList_594625(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsRoutesList_594624(path: JsonNode;
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
  var valid_594626 = path.getOrDefault("parent")
  valid_594626 = validateParameter(valid_594626, JString, required = true,
                                 default = nil)
  if valid_594626 != nil:
    section.add "parent", valid_594626
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
  var valid_594627 = query.getOrDefault("upload_protocol")
  valid_594627 = validateParameter(valid_594627, JString, required = false,
                                 default = nil)
  if valid_594627 != nil:
    section.add "upload_protocol", valid_594627
  var valid_594628 = query.getOrDefault("fields")
  valid_594628 = validateParameter(valid_594628, JString, required = false,
                                 default = nil)
  if valid_594628 != nil:
    section.add "fields", valid_594628
  var valid_594629 = query.getOrDefault("quotaUser")
  valid_594629 = validateParameter(valid_594629, JString, required = false,
                                 default = nil)
  if valid_594629 != nil:
    section.add "quotaUser", valid_594629
  var valid_594630 = query.getOrDefault("includeUninitialized")
  valid_594630 = validateParameter(valid_594630, JBool, required = false, default = nil)
  if valid_594630 != nil:
    section.add "includeUninitialized", valid_594630
  var valid_594631 = query.getOrDefault("alt")
  valid_594631 = validateParameter(valid_594631, JString, required = false,
                                 default = newJString("json"))
  if valid_594631 != nil:
    section.add "alt", valid_594631
  var valid_594632 = query.getOrDefault("continue")
  valid_594632 = validateParameter(valid_594632, JString, required = false,
                                 default = nil)
  if valid_594632 != nil:
    section.add "continue", valid_594632
  var valid_594633 = query.getOrDefault("oauth_token")
  valid_594633 = validateParameter(valid_594633, JString, required = false,
                                 default = nil)
  if valid_594633 != nil:
    section.add "oauth_token", valid_594633
  var valid_594634 = query.getOrDefault("callback")
  valid_594634 = validateParameter(valid_594634, JString, required = false,
                                 default = nil)
  if valid_594634 != nil:
    section.add "callback", valid_594634
  var valid_594635 = query.getOrDefault("access_token")
  valid_594635 = validateParameter(valid_594635, JString, required = false,
                                 default = nil)
  if valid_594635 != nil:
    section.add "access_token", valid_594635
  var valid_594636 = query.getOrDefault("uploadType")
  valid_594636 = validateParameter(valid_594636, JString, required = false,
                                 default = nil)
  if valid_594636 != nil:
    section.add "uploadType", valid_594636
  var valid_594637 = query.getOrDefault("resourceVersion")
  valid_594637 = validateParameter(valid_594637, JString, required = false,
                                 default = nil)
  if valid_594637 != nil:
    section.add "resourceVersion", valid_594637
  var valid_594638 = query.getOrDefault("watch")
  valid_594638 = validateParameter(valid_594638, JBool, required = false, default = nil)
  if valid_594638 != nil:
    section.add "watch", valid_594638
  var valid_594639 = query.getOrDefault("key")
  valid_594639 = validateParameter(valid_594639, JString, required = false,
                                 default = nil)
  if valid_594639 != nil:
    section.add "key", valid_594639
  var valid_594640 = query.getOrDefault("$.xgafv")
  valid_594640 = validateParameter(valid_594640, JString, required = false,
                                 default = newJString("1"))
  if valid_594640 != nil:
    section.add "$.xgafv", valid_594640
  var valid_594641 = query.getOrDefault("labelSelector")
  valid_594641 = validateParameter(valid_594641, JString, required = false,
                                 default = nil)
  if valid_594641 != nil:
    section.add "labelSelector", valid_594641
  var valid_594642 = query.getOrDefault("prettyPrint")
  valid_594642 = validateParameter(valid_594642, JBool, required = false,
                                 default = newJBool(true))
  if valid_594642 != nil:
    section.add "prettyPrint", valid_594642
  var valid_594643 = query.getOrDefault("fieldSelector")
  valid_594643 = validateParameter(valid_594643, JString, required = false,
                                 default = nil)
  if valid_594643 != nil:
    section.add "fieldSelector", valid_594643
  var valid_594644 = query.getOrDefault("limit")
  valid_594644 = validateParameter(valid_594644, JInt, required = false, default = nil)
  if valid_594644 != nil:
    section.add "limit", valid_594644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594645: Call_RunProjectsLocationsRoutesList_594623; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list routes.
  ## 
  let valid = call_594645.validator(path, query, header, formData, body)
  let scheme = call_594645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594645.url(scheme.get, call_594645.host, call_594645.base,
                         call_594645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594645, url, valid)

proc call*(call_594646: Call_RunProjectsLocationsRoutesList_594623; parent: string;
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
  var path_594647 = newJObject()
  var query_594648 = newJObject()
  add(query_594648, "upload_protocol", newJString(uploadProtocol))
  add(query_594648, "fields", newJString(fields))
  add(query_594648, "quotaUser", newJString(quotaUser))
  add(query_594648, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594648, "alt", newJString(alt))
  add(query_594648, "continue", newJString(`continue`))
  add(query_594648, "oauth_token", newJString(oauthToken))
  add(query_594648, "callback", newJString(callback))
  add(query_594648, "access_token", newJString(accessToken))
  add(query_594648, "uploadType", newJString(uploadType))
  add(path_594647, "parent", newJString(parent))
  add(query_594648, "resourceVersion", newJString(resourceVersion))
  add(query_594648, "watch", newJBool(watch))
  add(query_594648, "key", newJString(key))
  add(query_594648, "$.xgafv", newJString(Xgafv))
  add(query_594648, "labelSelector", newJString(labelSelector))
  add(query_594648, "prettyPrint", newJBool(prettyPrint))
  add(query_594648, "fieldSelector", newJString(fieldSelector))
  add(query_594648, "limit", newJInt(limit))
  result = call_594646.call(path_594647, query_594648, nil, nil, nil)

var runProjectsLocationsRoutesList* = Call_RunProjectsLocationsRoutesList_594623(
    name: "runProjectsLocationsRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesList_594624, base: "/",
    url: url_RunProjectsLocationsRoutesList_594625, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesCreate_594675 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsServicesCreate_594677(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsServicesCreate_594676(path: JsonNode;
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
  var valid_594678 = path.getOrDefault("parent")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "parent", valid_594678
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
  var valid_594679 = query.getOrDefault("upload_protocol")
  valid_594679 = validateParameter(valid_594679, JString, required = false,
                                 default = nil)
  if valid_594679 != nil:
    section.add "upload_protocol", valid_594679
  var valid_594680 = query.getOrDefault("fields")
  valid_594680 = validateParameter(valid_594680, JString, required = false,
                                 default = nil)
  if valid_594680 != nil:
    section.add "fields", valid_594680
  var valid_594681 = query.getOrDefault("quotaUser")
  valid_594681 = validateParameter(valid_594681, JString, required = false,
                                 default = nil)
  if valid_594681 != nil:
    section.add "quotaUser", valid_594681
  var valid_594682 = query.getOrDefault("alt")
  valid_594682 = validateParameter(valid_594682, JString, required = false,
                                 default = newJString("json"))
  if valid_594682 != nil:
    section.add "alt", valid_594682
  var valid_594683 = query.getOrDefault("oauth_token")
  valid_594683 = validateParameter(valid_594683, JString, required = false,
                                 default = nil)
  if valid_594683 != nil:
    section.add "oauth_token", valid_594683
  var valid_594684 = query.getOrDefault("callback")
  valid_594684 = validateParameter(valid_594684, JString, required = false,
                                 default = nil)
  if valid_594684 != nil:
    section.add "callback", valid_594684
  var valid_594685 = query.getOrDefault("access_token")
  valid_594685 = validateParameter(valid_594685, JString, required = false,
                                 default = nil)
  if valid_594685 != nil:
    section.add "access_token", valid_594685
  var valid_594686 = query.getOrDefault("uploadType")
  valid_594686 = validateParameter(valid_594686, JString, required = false,
                                 default = nil)
  if valid_594686 != nil:
    section.add "uploadType", valid_594686
  var valid_594687 = query.getOrDefault("key")
  valid_594687 = validateParameter(valid_594687, JString, required = false,
                                 default = nil)
  if valid_594687 != nil:
    section.add "key", valid_594687
  var valid_594688 = query.getOrDefault("$.xgafv")
  valid_594688 = validateParameter(valid_594688, JString, required = false,
                                 default = newJString("1"))
  if valid_594688 != nil:
    section.add "$.xgafv", valid_594688
  var valid_594689 = query.getOrDefault("prettyPrint")
  valid_594689 = validateParameter(valid_594689, JBool, required = false,
                                 default = newJBool(true))
  if valid_594689 != nil:
    section.add "prettyPrint", valid_594689
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

proc call*(call_594691: Call_RunProjectsLocationsServicesCreate_594675;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to create a service.
  ## 
  let valid = call_594691.validator(path, query, header, formData, body)
  let scheme = call_594691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594691.url(scheme.get, call_594691.host, call_594691.base,
                         call_594691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594691, url, valid)

proc call*(call_594692: Call_RunProjectsLocationsServicesCreate_594675;
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
  var path_594693 = newJObject()
  var query_594694 = newJObject()
  var body_594695 = newJObject()
  add(query_594694, "upload_protocol", newJString(uploadProtocol))
  add(query_594694, "fields", newJString(fields))
  add(query_594694, "quotaUser", newJString(quotaUser))
  add(query_594694, "alt", newJString(alt))
  add(query_594694, "oauth_token", newJString(oauthToken))
  add(query_594694, "callback", newJString(callback))
  add(query_594694, "access_token", newJString(accessToken))
  add(query_594694, "uploadType", newJString(uploadType))
  add(path_594693, "parent", newJString(parent))
  add(query_594694, "key", newJString(key))
  add(query_594694, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594695 = body
  add(query_594694, "prettyPrint", newJBool(prettyPrint))
  result = call_594692.call(path_594693, query_594694, nil, nil, body_594695)

var runProjectsLocationsServicesCreate* = Call_RunProjectsLocationsServicesCreate_594675(
    name: "runProjectsLocationsServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesCreate_594676, base: "/",
    url: url_RunProjectsLocationsServicesCreate_594677, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesList_594649 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsServicesList_594651(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsServicesList_594650(path: JsonNode;
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
  var valid_594652 = path.getOrDefault("parent")
  valid_594652 = validateParameter(valid_594652, JString, required = true,
                                 default = nil)
  if valid_594652 != nil:
    section.add "parent", valid_594652
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
  var valid_594653 = query.getOrDefault("upload_protocol")
  valid_594653 = validateParameter(valid_594653, JString, required = false,
                                 default = nil)
  if valid_594653 != nil:
    section.add "upload_protocol", valid_594653
  var valid_594654 = query.getOrDefault("fields")
  valid_594654 = validateParameter(valid_594654, JString, required = false,
                                 default = nil)
  if valid_594654 != nil:
    section.add "fields", valid_594654
  var valid_594655 = query.getOrDefault("quotaUser")
  valid_594655 = validateParameter(valid_594655, JString, required = false,
                                 default = nil)
  if valid_594655 != nil:
    section.add "quotaUser", valid_594655
  var valid_594656 = query.getOrDefault("includeUninitialized")
  valid_594656 = validateParameter(valid_594656, JBool, required = false, default = nil)
  if valid_594656 != nil:
    section.add "includeUninitialized", valid_594656
  var valid_594657 = query.getOrDefault("alt")
  valid_594657 = validateParameter(valid_594657, JString, required = false,
                                 default = newJString("json"))
  if valid_594657 != nil:
    section.add "alt", valid_594657
  var valid_594658 = query.getOrDefault("continue")
  valid_594658 = validateParameter(valid_594658, JString, required = false,
                                 default = nil)
  if valid_594658 != nil:
    section.add "continue", valid_594658
  var valid_594659 = query.getOrDefault("oauth_token")
  valid_594659 = validateParameter(valid_594659, JString, required = false,
                                 default = nil)
  if valid_594659 != nil:
    section.add "oauth_token", valid_594659
  var valid_594660 = query.getOrDefault("callback")
  valid_594660 = validateParameter(valid_594660, JString, required = false,
                                 default = nil)
  if valid_594660 != nil:
    section.add "callback", valid_594660
  var valid_594661 = query.getOrDefault("access_token")
  valid_594661 = validateParameter(valid_594661, JString, required = false,
                                 default = nil)
  if valid_594661 != nil:
    section.add "access_token", valid_594661
  var valid_594662 = query.getOrDefault("uploadType")
  valid_594662 = validateParameter(valid_594662, JString, required = false,
                                 default = nil)
  if valid_594662 != nil:
    section.add "uploadType", valid_594662
  var valid_594663 = query.getOrDefault("resourceVersion")
  valid_594663 = validateParameter(valid_594663, JString, required = false,
                                 default = nil)
  if valid_594663 != nil:
    section.add "resourceVersion", valid_594663
  var valid_594664 = query.getOrDefault("watch")
  valid_594664 = validateParameter(valid_594664, JBool, required = false, default = nil)
  if valid_594664 != nil:
    section.add "watch", valid_594664
  var valid_594665 = query.getOrDefault("key")
  valid_594665 = validateParameter(valid_594665, JString, required = false,
                                 default = nil)
  if valid_594665 != nil:
    section.add "key", valid_594665
  var valid_594666 = query.getOrDefault("$.xgafv")
  valid_594666 = validateParameter(valid_594666, JString, required = false,
                                 default = newJString("1"))
  if valid_594666 != nil:
    section.add "$.xgafv", valid_594666
  var valid_594667 = query.getOrDefault("labelSelector")
  valid_594667 = validateParameter(valid_594667, JString, required = false,
                                 default = nil)
  if valid_594667 != nil:
    section.add "labelSelector", valid_594667
  var valid_594668 = query.getOrDefault("prettyPrint")
  valid_594668 = validateParameter(valid_594668, JBool, required = false,
                                 default = newJBool(true))
  if valid_594668 != nil:
    section.add "prettyPrint", valid_594668
  var valid_594669 = query.getOrDefault("fieldSelector")
  valid_594669 = validateParameter(valid_594669, JString, required = false,
                                 default = nil)
  if valid_594669 != nil:
    section.add "fieldSelector", valid_594669
  var valid_594670 = query.getOrDefault("limit")
  valid_594670 = validateParameter(valid_594670, JInt, required = false, default = nil)
  if valid_594670 != nil:
    section.add "limit", valid_594670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594671: Call_RunProjectsLocationsServicesList_594649;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list services.
  ## 
  let valid = call_594671.validator(path, query, header, formData, body)
  let scheme = call_594671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594671.url(scheme.get, call_594671.host, call_594671.base,
                         call_594671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594671, url, valid)

proc call*(call_594672: Call_RunProjectsLocationsServicesList_594649;
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
  var path_594673 = newJObject()
  var query_594674 = newJObject()
  add(query_594674, "upload_protocol", newJString(uploadProtocol))
  add(query_594674, "fields", newJString(fields))
  add(query_594674, "quotaUser", newJString(quotaUser))
  add(query_594674, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594674, "alt", newJString(alt))
  add(query_594674, "continue", newJString(`continue`))
  add(query_594674, "oauth_token", newJString(oauthToken))
  add(query_594674, "callback", newJString(callback))
  add(query_594674, "access_token", newJString(accessToken))
  add(query_594674, "uploadType", newJString(uploadType))
  add(path_594673, "parent", newJString(parent))
  add(query_594674, "resourceVersion", newJString(resourceVersion))
  add(query_594674, "watch", newJBool(watch))
  add(query_594674, "key", newJString(key))
  add(query_594674, "$.xgafv", newJString(Xgafv))
  add(query_594674, "labelSelector", newJString(labelSelector))
  add(query_594674, "prettyPrint", newJBool(prettyPrint))
  add(query_594674, "fieldSelector", newJString(fieldSelector))
  add(query_594674, "limit", newJInt(limit))
  result = call_594672.call(path_594673, query_594674, nil, nil, nil)

var runProjectsLocationsServicesList* = Call_RunProjectsLocationsServicesList_594649(
    name: "runProjectsLocationsServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesList_594650, base: "/",
    url: url_RunProjectsLocationsServicesList_594651, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsTriggersCreate_594722 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsTriggersCreate_594724(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsTriggersCreate_594723(path: JsonNode;
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
  var valid_594725 = path.getOrDefault("parent")
  valid_594725 = validateParameter(valid_594725, JString, required = true,
                                 default = nil)
  if valid_594725 != nil:
    section.add "parent", valid_594725
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
  var valid_594726 = query.getOrDefault("upload_protocol")
  valid_594726 = validateParameter(valid_594726, JString, required = false,
                                 default = nil)
  if valid_594726 != nil:
    section.add "upload_protocol", valid_594726
  var valid_594727 = query.getOrDefault("fields")
  valid_594727 = validateParameter(valid_594727, JString, required = false,
                                 default = nil)
  if valid_594727 != nil:
    section.add "fields", valid_594727
  var valid_594728 = query.getOrDefault("quotaUser")
  valid_594728 = validateParameter(valid_594728, JString, required = false,
                                 default = nil)
  if valid_594728 != nil:
    section.add "quotaUser", valid_594728
  var valid_594729 = query.getOrDefault("alt")
  valid_594729 = validateParameter(valid_594729, JString, required = false,
                                 default = newJString("json"))
  if valid_594729 != nil:
    section.add "alt", valid_594729
  var valid_594730 = query.getOrDefault("oauth_token")
  valid_594730 = validateParameter(valid_594730, JString, required = false,
                                 default = nil)
  if valid_594730 != nil:
    section.add "oauth_token", valid_594730
  var valid_594731 = query.getOrDefault("callback")
  valid_594731 = validateParameter(valid_594731, JString, required = false,
                                 default = nil)
  if valid_594731 != nil:
    section.add "callback", valid_594731
  var valid_594732 = query.getOrDefault("access_token")
  valid_594732 = validateParameter(valid_594732, JString, required = false,
                                 default = nil)
  if valid_594732 != nil:
    section.add "access_token", valid_594732
  var valid_594733 = query.getOrDefault("uploadType")
  valid_594733 = validateParameter(valid_594733, JString, required = false,
                                 default = nil)
  if valid_594733 != nil:
    section.add "uploadType", valid_594733
  var valid_594734 = query.getOrDefault("key")
  valid_594734 = validateParameter(valid_594734, JString, required = false,
                                 default = nil)
  if valid_594734 != nil:
    section.add "key", valid_594734
  var valid_594735 = query.getOrDefault("$.xgafv")
  valid_594735 = validateParameter(valid_594735, JString, required = false,
                                 default = newJString("1"))
  if valid_594735 != nil:
    section.add "$.xgafv", valid_594735
  var valid_594736 = query.getOrDefault("prettyPrint")
  valid_594736 = validateParameter(valid_594736, JBool, required = false,
                                 default = newJBool(true))
  if valid_594736 != nil:
    section.add "prettyPrint", valid_594736
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

proc call*(call_594738: Call_RunProjectsLocationsTriggersCreate_594722;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new trigger.
  ## 
  let valid = call_594738.validator(path, query, header, formData, body)
  let scheme = call_594738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594738.url(scheme.get, call_594738.host, call_594738.base,
                         call_594738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594738, url, valid)

proc call*(call_594739: Call_RunProjectsLocationsTriggersCreate_594722;
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
  var path_594740 = newJObject()
  var query_594741 = newJObject()
  var body_594742 = newJObject()
  add(query_594741, "upload_protocol", newJString(uploadProtocol))
  add(query_594741, "fields", newJString(fields))
  add(query_594741, "quotaUser", newJString(quotaUser))
  add(query_594741, "alt", newJString(alt))
  add(query_594741, "oauth_token", newJString(oauthToken))
  add(query_594741, "callback", newJString(callback))
  add(query_594741, "access_token", newJString(accessToken))
  add(query_594741, "uploadType", newJString(uploadType))
  add(path_594740, "parent", newJString(parent))
  add(query_594741, "key", newJString(key))
  add(query_594741, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594742 = body
  add(query_594741, "prettyPrint", newJBool(prettyPrint))
  result = call_594739.call(path_594740, query_594741, nil, nil, body_594742)

var runProjectsLocationsTriggersCreate* = Call_RunProjectsLocationsTriggersCreate_594722(
    name: "runProjectsLocationsTriggersCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/triggers",
    validator: validate_RunProjectsLocationsTriggersCreate_594723, base: "/",
    url: url_RunProjectsLocationsTriggersCreate_594724, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsTriggersList_594696 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsTriggersList_594698(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsTriggersList_594697(path: JsonNode;
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
  var valid_594699 = path.getOrDefault("parent")
  valid_594699 = validateParameter(valid_594699, JString, required = true,
                                 default = nil)
  if valid_594699 != nil:
    section.add "parent", valid_594699
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
  var valid_594700 = query.getOrDefault("upload_protocol")
  valid_594700 = validateParameter(valid_594700, JString, required = false,
                                 default = nil)
  if valid_594700 != nil:
    section.add "upload_protocol", valid_594700
  var valid_594701 = query.getOrDefault("fields")
  valid_594701 = validateParameter(valid_594701, JString, required = false,
                                 default = nil)
  if valid_594701 != nil:
    section.add "fields", valid_594701
  var valid_594702 = query.getOrDefault("quotaUser")
  valid_594702 = validateParameter(valid_594702, JString, required = false,
                                 default = nil)
  if valid_594702 != nil:
    section.add "quotaUser", valid_594702
  var valid_594703 = query.getOrDefault("includeUninitialized")
  valid_594703 = validateParameter(valid_594703, JBool, required = false, default = nil)
  if valid_594703 != nil:
    section.add "includeUninitialized", valid_594703
  var valid_594704 = query.getOrDefault("alt")
  valid_594704 = validateParameter(valid_594704, JString, required = false,
                                 default = newJString("json"))
  if valid_594704 != nil:
    section.add "alt", valid_594704
  var valid_594705 = query.getOrDefault("continue")
  valid_594705 = validateParameter(valid_594705, JString, required = false,
                                 default = nil)
  if valid_594705 != nil:
    section.add "continue", valid_594705
  var valid_594706 = query.getOrDefault("oauth_token")
  valid_594706 = validateParameter(valid_594706, JString, required = false,
                                 default = nil)
  if valid_594706 != nil:
    section.add "oauth_token", valid_594706
  var valid_594707 = query.getOrDefault("callback")
  valid_594707 = validateParameter(valid_594707, JString, required = false,
                                 default = nil)
  if valid_594707 != nil:
    section.add "callback", valid_594707
  var valid_594708 = query.getOrDefault("access_token")
  valid_594708 = validateParameter(valid_594708, JString, required = false,
                                 default = nil)
  if valid_594708 != nil:
    section.add "access_token", valid_594708
  var valid_594709 = query.getOrDefault("uploadType")
  valid_594709 = validateParameter(valid_594709, JString, required = false,
                                 default = nil)
  if valid_594709 != nil:
    section.add "uploadType", valid_594709
  var valid_594710 = query.getOrDefault("resourceVersion")
  valid_594710 = validateParameter(valid_594710, JString, required = false,
                                 default = nil)
  if valid_594710 != nil:
    section.add "resourceVersion", valid_594710
  var valid_594711 = query.getOrDefault("watch")
  valid_594711 = validateParameter(valid_594711, JBool, required = false, default = nil)
  if valid_594711 != nil:
    section.add "watch", valid_594711
  var valid_594712 = query.getOrDefault("key")
  valid_594712 = validateParameter(valid_594712, JString, required = false,
                                 default = nil)
  if valid_594712 != nil:
    section.add "key", valid_594712
  var valid_594713 = query.getOrDefault("$.xgafv")
  valid_594713 = validateParameter(valid_594713, JString, required = false,
                                 default = newJString("1"))
  if valid_594713 != nil:
    section.add "$.xgafv", valid_594713
  var valid_594714 = query.getOrDefault("labelSelector")
  valid_594714 = validateParameter(valid_594714, JString, required = false,
                                 default = nil)
  if valid_594714 != nil:
    section.add "labelSelector", valid_594714
  var valid_594715 = query.getOrDefault("prettyPrint")
  valid_594715 = validateParameter(valid_594715, JBool, required = false,
                                 default = newJBool(true))
  if valid_594715 != nil:
    section.add "prettyPrint", valid_594715
  var valid_594716 = query.getOrDefault("fieldSelector")
  valid_594716 = validateParameter(valid_594716, JString, required = false,
                                 default = nil)
  if valid_594716 != nil:
    section.add "fieldSelector", valid_594716
  var valid_594717 = query.getOrDefault("limit")
  valid_594717 = validateParameter(valid_594717, JInt, required = false, default = nil)
  if valid_594717 != nil:
    section.add "limit", valid_594717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594718: Call_RunProjectsLocationsTriggersList_594696;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list triggers.
  ## 
  let valid = call_594718.validator(path, query, header, formData, body)
  let scheme = call_594718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594718.url(scheme.get, call_594718.host, call_594718.base,
                         call_594718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594718, url, valid)

proc call*(call_594719: Call_RunProjectsLocationsTriggersList_594696;
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
  var path_594720 = newJObject()
  var query_594721 = newJObject()
  add(query_594721, "upload_protocol", newJString(uploadProtocol))
  add(query_594721, "fields", newJString(fields))
  add(query_594721, "quotaUser", newJString(quotaUser))
  add(query_594721, "includeUninitialized", newJBool(includeUninitialized))
  add(query_594721, "alt", newJString(alt))
  add(query_594721, "continue", newJString(`continue`))
  add(query_594721, "oauth_token", newJString(oauthToken))
  add(query_594721, "callback", newJString(callback))
  add(query_594721, "access_token", newJString(accessToken))
  add(query_594721, "uploadType", newJString(uploadType))
  add(path_594720, "parent", newJString(parent))
  add(query_594721, "resourceVersion", newJString(resourceVersion))
  add(query_594721, "watch", newJBool(watch))
  add(query_594721, "key", newJString(key))
  add(query_594721, "$.xgafv", newJString(Xgafv))
  add(query_594721, "labelSelector", newJString(labelSelector))
  add(query_594721, "prettyPrint", newJBool(prettyPrint))
  add(query_594721, "fieldSelector", newJString(fieldSelector))
  add(query_594721, "limit", newJInt(limit))
  result = call_594719.call(path_594720, query_594721, nil, nil, nil)

var runProjectsLocationsTriggersList* = Call_RunProjectsLocationsTriggersList_594696(
    name: "runProjectsLocationsTriggersList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/triggers",
    validator: validate_RunProjectsLocationsTriggersList_594697, base: "/",
    url: url_RunProjectsLocationsTriggersList_594698, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesGetIamPolicy_594743 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsServicesGetIamPolicy_594745(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsServicesGetIamPolicy_594744(path: JsonNode;
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
  var valid_594746 = path.getOrDefault("resource")
  valid_594746 = validateParameter(valid_594746, JString, required = true,
                                 default = nil)
  if valid_594746 != nil:
    section.add "resource", valid_594746
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
  var valid_594747 = query.getOrDefault("upload_protocol")
  valid_594747 = validateParameter(valid_594747, JString, required = false,
                                 default = nil)
  if valid_594747 != nil:
    section.add "upload_protocol", valid_594747
  var valid_594748 = query.getOrDefault("fields")
  valid_594748 = validateParameter(valid_594748, JString, required = false,
                                 default = nil)
  if valid_594748 != nil:
    section.add "fields", valid_594748
  var valid_594749 = query.getOrDefault("quotaUser")
  valid_594749 = validateParameter(valid_594749, JString, required = false,
                                 default = nil)
  if valid_594749 != nil:
    section.add "quotaUser", valid_594749
  var valid_594750 = query.getOrDefault("alt")
  valid_594750 = validateParameter(valid_594750, JString, required = false,
                                 default = newJString("json"))
  if valid_594750 != nil:
    section.add "alt", valid_594750
  var valid_594751 = query.getOrDefault("oauth_token")
  valid_594751 = validateParameter(valid_594751, JString, required = false,
                                 default = nil)
  if valid_594751 != nil:
    section.add "oauth_token", valid_594751
  var valid_594752 = query.getOrDefault("callback")
  valid_594752 = validateParameter(valid_594752, JString, required = false,
                                 default = nil)
  if valid_594752 != nil:
    section.add "callback", valid_594752
  var valid_594753 = query.getOrDefault("access_token")
  valid_594753 = validateParameter(valid_594753, JString, required = false,
                                 default = nil)
  if valid_594753 != nil:
    section.add "access_token", valid_594753
  var valid_594754 = query.getOrDefault("uploadType")
  valid_594754 = validateParameter(valid_594754, JString, required = false,
                                 default = nil)
  if valid_594754 != nil:
    section.add "uploadType", valid_594754
  var valid_594755 = query.getOrDefault("options.requestedPolicyVersion")
  valid_594755 = validateParameter(valid_594755, JInt, required = false, default = nil)
  if valid_594755 != nil:
    section.add "options.requestedPolicyVersion", valid_594755
  var valid_594756 = query.getOrDefault("key")
  valid_594756 = validateParameter(valid_594756, JString, required = false,
                                 default = nil)
  if valid_594756 != nil:
    section.add "key", valid_594756
  var valid_594757 = query.getOrDefault("$.xgafv")
  valid_594757 = validateParameter(valid_594757, JString, required = false,
                                 default = newJString("1"))
  if valid_594757 != nil:
    section.add "$.xgafv", valid_594757
  var valid_594758 = query.getOrDefault("prettyPrint")
  valid_594758 = validateParameter(valid_594758, JBool, required = false,
                                 default = newJBool(true))
  if valid_594758 != nil:
    section.add "prettyPrint", valid_594758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594759: Call_RunProjectsLocationsServicesGetIamPolicy_594743;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  let valid = call_594759.validator(path, query, header, formData, body)
  let scheme = call_594759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594759.url(scheme.get, call_594759.host, call_594759.base,
                         call_594759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594759, url, valid)

proc call*(call_594760: Call_RunProjectsLocationsServicesGetIamPolicy_594743;
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
  var path_594761 = newJObject()
  var query_594762 = newJObject()
  add(query_594762, "upload_protocol", newJString(uploadProtocol))
  add(query_594762, "fields", newJString(fields))
  add(query_594762, "quotaUser", newJString(quotaUser))
  add(query_594762, "alt", newJString(alt))
  add(query_594762, "oauth_token", newJString(oauthToken))
  add(query_594762, "callback", newJString(callback))
  add(query_594762, "access_token", newJString(accessToken))
  add(query_594762, "uploadType", newJString(uploadType))
  add(query_594762, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_594762, "key", newJString(key))
  add(query_594762, "$.xgafv", newJString(Xgafv))
  add(path_594761, "resource", newJString(resource))
  add(query_594762, "prettyPrint", newJBool(prettyPrint))
  result = call_594760.call(path_594761, query_594762, nil, nil, nil)

var runProjectsLocationsServicesGetIamPolicy* = Call_RunProjectsLocationsServicesGetIamPolicy_594743(
    name: "runProjectsLocationsServicesGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_RunProjectsLocationsServicesGetIamPolicy_594744,
    base: "/", url: url_RunProjectsLocationsServicesGetIamPolicy_594745,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesSetIamPolicy_594763 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsServicesSetIamPolicy_594765(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsServicesSetIamPolicy_594764(path: JsonNode;
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
  var valid_594766 = path.getOrDefault("resource")
  valid_594766 = validateParameter(valid_594766, JString, required = true,
                                 default = nil)
  if valid_594766 != nil:
    section.add "resource", valid_594766
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
  var valid_594767 = query.getOrDefault("upload_protocol")
  valid_594767 = validateParameter(valid_594767, JString, required = false,
                                 default = nil)
  if valid_594767 != nil:
    section.add "upload_protocol", valid_594767
  var valid_594768 = query.getOrDefault("fields")
  valid_594768 = validateParameter(valid_594768, JString, required = false,
                                 default = nil)
  if valid_594768 != nil:
    section.add "fields", valid_594768
  var valid_594769 = query.getOrDefault("quotaUser")
  valid_594769 = validateParameter(valid_594769, JString, required = false,
                                 default = nil)
  if valid_594769 != nil:
    section.add "quotaUser", valid_594769
  var valid_594770 = query.getOrDefault("alt")
  valid_594770 = validateParameter(valid_594770, JString, required = false,
                                 default = newJString("json"))
  if valid_594770 != nil:
    section.add "alt", valid_594770
  var valid_594771 = query.getOrDefault("oauth_token")
  valid_594771 = validateParameter(valid_594771, JString, required = false,
                                 default = nil)
  if valid_594771 != nil:
    section.add "oauth_token", valid_594771
  var valid_594772 = query.getOrDefault("callback")
  valid_594772 = validateParameter(valid_594772, JString, required = false,
                                 default = nil)
  if valid_594772 != nil:
    section.add "callback", valid_594772
  var valid_594773 = query.getOrDefault("access_token")
  valid_594773 = validateParameter(valid_594773, JString, required = false,
                                 default = nil)
  if valid_594773 != nil:
    section.add "access_token", valid_594773
  var valid_594774 = query.getOrDefault("uploadType")
  valid_594774 = validateParameter(valid_594774, JString, required = false,
                                 default = nil)
  if valid_594774 != nil:
    section.add "uploadType", valid_594774
  var valid_594775 = query.getOrDefault("key")
  valid_594775 = validateParameter(valid_594775, JString, required = false,
                                 default = nil)
  if valid_594775 != nil:
    section.add "key", valid_594775
  var valid_594776 = query.getOrDefault("$.xgafv")
  valid_594776 = validateParameter(valid_594776, JString, required = false,
                                 default = newJString("1"))
  if valid_594776 != nil:
    section.add "$.xgafv", valid_594776
  var valid_594777 = query.getOrDefault("prettyPrint")
  valid_594777 = validateParameter(valid_594777, JBool, required = false,
                                 default = newJBool(true))
  if valid_594777 != nil:
    section.add "prettyPrint", valid_594777
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

proc call*(call_594779: Call_RunProjectsLocationsServicesSetIamPolicy_594763;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  let valid = call_594779.validator(path, query, header, formData, body)
  let scheme = call_594779.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594779.url(scheme.get, call_594779.host, call_594779.base,
                         call_594779.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594779, url, valid)

proc call*(call_594780: Call_RunProjectsLocationsServicesSetIamPolicy_594763;
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
  var path_594781 = newJObject()
  var query_594782 = newJObject()
  var body_594783 = newJObject()
  add(query_594782, "upload_protocol", newJString(uploadProtocol))
  add(query_594782, "fields", newJString(fields))
  add(query_594782, "quotaUser", newJString(quotaUser))
  add(query_594782, "alt", newJString(alt))
  add(query_594782, "oauth_token", newJString(oauthToken))
  add(query_594782, "callback", newJString(callback))
  add(query_594782, "access_token", newJString(accessToken))
  add(query_594782, "uploadType", newJString(uploadType))
  add(query_594782, "key", newJString(key))
  add(query_594782, "$.xgafv", newJString(Xgafv))
  add(path_594781, "resource", newJString(resource))
  if body != nil:
    body_594783 = body
  add(query_594782, "prettyPrint", newJBool(prettyPrint))
  result = call_594780.call(path_594781, query_594782, nil, nil, body_594783)

var runProjectsLocationsServicesSetIamPolicy* = Call_RunProjectsLocationsServicesSetIamPolicy_594763(
    name: "runProjectsLocationsServicesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_RunProjectsLocationsServicesSetIamPolicy_594764,
    base: "/", url: url_RunProjectsLocationsServicesSetIamPolicy_594765,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesTestIamPermissions_594784 = ref object of OpenApiRestCall_593421
proc url_RunProjectsLocationsServicesTestIamPermissions_594786(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_RunProjectsLocationsServicesTestIamPermissions_594785(
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
  var valid_594787 = path.getOrDefault("resource")
  valid_594787 = validateParameter(valid_594787, JString, required = true,
                                 default = nil)
  if valid_594787 != nil:
    section.add "resource", valid_594787
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
  var valid_594788 = query.getOrDefault("upload_protocol")
  valid_594788 = validateParameter(valid_594788, JString, required = false,
                                 default = nil)
  if valid_594788 != nil:
    section.add "upload_protocol", valid_594788
  var valid_594789 = query.getOrDefault("fields")
  valid_594789 = validateParameter(valid_594789, JString, required = false,
                                 default = nil)
  if valid_594789 != nil:
    section.add "fields", valid_594789
  var valid_594790 = query.getOrDefault("quotaUser")
  valid_594790 = validateParameter(valid_594790, JString, required = false,
                                 default = nil)
  if valid_594790 != nil:
    section.add "quotaUser", valid_594790
  var valid_594791 = query.getOrDefault("alt")
  valid_594791 = validateParameter(valid_594791, JString, required = false,
                                 default = newJString("json"))
  if valid_594791 != nil:
    section.add "alt", valid_594791
  var valid_594792 = query.getOrDefault("oauth_token")
  valid_594792 = validateParameter(valid_594792, JString, required = false,
                                 default = nil)
  if valid_594792 != nil:
    section.add "oauth_token", valid_594792
  var valid_594793 = query.getOrDefault("callback")
  valid_594793 = validateParameter(valid_594793, JString, required = false,
                                 default = nil)
  if valid_594793 != nil:
    section.add "callback", valid_594793
  var valid_594794 = query.getOrDefault("access_token")
  valid_594794 = validateParameter(valid_594794, JString, required = false,
                                 default = nil)
  if valid_594794 != nil:
    section.add "access_token", valid_594794
  var valid_594795 = query.getOrDefault("uploadType")
  valid_594795 = validateParameter(valid_594795, JString, required = false,
                                 default = nil)
  if valid_594795 != nil:
    section.add "uploadType", valid_594795
  var valid_594796 = query.getOrDefault("key")
  valid_594796 = validateParameter(valid_594796, JString, required = false,
                                 default = nil)
  if valid_594796 != nil:
    section.add "key", valid_594796
  var valid_594797 = query.getOrDefault("$.xgafv")
  valid_594797 = validateParameter(valid_594797, JString, required = false,
                                 default = newJString("1"))
  if valid_594797 != nil:
    section.add "$.xgafv", valid_594797
  var valid_594798 = query.getOrDefault("prettyPrint")
  valid_594798 = validateParameter(valid_594798, JBool, required = false,
                                 default = newJBool(true))
  if valid_594798 != nil:
    section.add "prettyPrint", valid_594798
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

proc call*(call_594800: Call_RunProjectsLocationsServicesTestIamPermissions_594784;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_594800.validator(path, query, header, formData, body)
  let scheme = call_594800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594800.url(scheme.get, call_594800.host, call_594800.base,
                         call_594800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594800, url, valid)

proc call*(call_594801: Call_RunProjectsLocationsServicesTestIamPermissions_594784;
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
  var path_594802 = newJObject()
  var query_594803 = newJObject()
  var body_594804 = newJObject()
  add(query_594803, "upload_protocol", newJString(uploadProtocol))
  add(query_594803, "fields", newJString(fields))
  add(query_594803, "quotaUser", newJString(quotaUser))
  add(query_594803, "alt", newJString(alt))
  add(query_594803, "oauth_token", newJString(oauthToken))
  add(query_594803, "callback", newJString(callback))
  add(query_594803, "access_token", newJString(accessToken))
  add(query_594803, "uploadType", newJString(uploadType))
  add(query_594803, "key", newJString(key))
  add(query_594803, "$.xgafv", newJString(Xgafv))
  add(path_594802, "resource", newJString(resource))
  if body != nil:
    body_594804 = body
  add(query_594803, "prettyPrint", newJBool(prettyPrint))
  result = call_594801.call(path_594802, query_594803, nil, nil, body_594804)

var runProjectsLocationsServicesTestIamPermissions* = Call_RunProjectsLocationsServicesTestIamPermissions_594784(
    name: "runProjectsLocationsServicesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_RunProjectsLocationsServicesTestIamPermissions_594785,
    base: "/", url: url_RunProjectsLocationsServicesTestIamPermissions_594786,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
