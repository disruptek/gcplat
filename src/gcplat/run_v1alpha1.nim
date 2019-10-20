
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
  gcpServiceName = "run"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RunNamespacesDomainmappingsGet_578619 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesDomainmappingsGet_578621(protocol: Scheme; host: string;
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

proc validate_RunNamespacesDomainmappingsGet_578620(path: JsonNode;
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

proc call*(call_578794: Call_RunNamespacesDomainmappingsGet_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a domain mapping.
  ## 
  let valid = call_578794.validator(path, query, header, formData, body)
  let scheme = call_578794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578794.url(scheme.get, call_578794.host, call_578794.base,
                         call_578794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578794, url, valid)

proc call*(call_578865: Call_RunNamespacesDomainmappingsGet_578619; name: string;
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

var runNamespacesDomainmappingsGet* = Call_RunNamespacesDomainmappingsGet_578619(
    name: "runNamespacesDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{name}",
    validator: validate_RunNamespacesDomainmappingsGet_578620, base: "/",
    url: url_RunNamespacesDomainmappingsGet_578621, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsDelete_578907 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesDomainmappingsDelete_578909(protocol: Scheme; host: string;
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

proc validate_RunNamespacesDomainmappingsDelete_578908(path: JsonNode;
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
  var valid_578918 = query.getOrDefault("propagationPolicy")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "propagationPolicy", valid_578918
  var valid_578919 = query.getOrDefault("callback")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "callback", valid_578919
  var valid_578920 = query.getOrDefault("apiVersion")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "apiVersion", valid_578920
  var valid_578921 = query.getOrDefault("orphanDependents")
  valid_578921 = validateParameter(valid_578921, JBool, required = false, default = nil)
  if valid_578921 != nil:
    section.add "orphanDependents", valid_578921
  var valid_578922 = query.getOrDefault("kind")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "kind", valid_578922
  var valid_578923 = query.getOrDefault("fields")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "fields", valid_578923
  var valid_578924 = query.getOrDefault("access_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "access_token", valid_578924
  var valid_578925 = query.getOrDefault("upload_protocol")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "upload_protocol", valid_578925
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578926: Call_RunNamespacesDomainmappingsDelete_578907;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to delete a domain mapping.
  ## 
  let valid = call_578926.validator(path, query, header, formData, body)
  let scheme = call_578926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578926.url(scheme.get, call_578926.host, call_578926.base,
                         call_578926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578926, url, valid)

proc call*(call_578927: Call_RunNamespacesDomainmappingsDelete_578907;
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
  var path_578928 = newJObject()
  var query_578929 = newJObject()
  add(query_578929, "key", newJString(key))
  add(query_578929, "prettyPrint", newJBool(prettyPrint))
  add(query_578929, "oauth_token", newJString(oauthToken))
  add(query_578929, "$.xgafv", newJString(Xgafv))
  add(query_578929, "alt", newJString(alt))
  add(query_578929, "uploadType", newJString(uploadType))
  add(query_578929, "quotaUser", newJString(quotaUser))
  add(path_578928, "name", newJString(name))
  add(query_578929, "propagationPolicy", newJString(propagationPolicy))
  add(query_578929, "callback", newJString(callback))
  add(query_578929, "apiVersion", newJString(apiVersion))
  add(query_578929, "orphanDependents", newJBool(orphanDependents))
  add(query_578929, "kind", newJString(kind))
  add(query_578929, "fields", newJString(fields))
  add(query_578929, "access_token", newJString(accessToken))
  add(query_578929, "upload_protocol", newJString(uploadProtocol))
  result = call_578927.call(path_578928, query_578929, nil, nil, nil)

var runNamespacesDomainmappingsDelete* = Call_RunNamespacesDomainmappingsDelete_578907(
    name: "runNamespacesDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{name}",
    validator: validate_RunNamespacesDomainmappingsDelete_578908, base: "/",
    url: url_RunNamespacesDomainmappingsDelete_578909, schemes: {Scheme.Https})
type
  Call_RunNamespacesAuthorizeddomainsList_578930 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesAuthorizeddomainsList_578932(protocol: Scheme; host: string;
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

proc validate_RunNamespacesAuthorizeddomainsList_578931(path: JsonNode;
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
  var valid_578933 = path.getOrDefault("parent")
  valid_578933 = validateParameter(valid_578933, JString, required = true,
                                 default = nil)
  if valid_578933 != nil:
    section.add "parent", valid_578933
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
  var valid_578934 = query.getOrDefault("key")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "key", valid_578934
  var valid_578935 = query.getOrDefault("prettyPrint")
  valid_578935 = validateParameter(valid_578935, JBool, required = false,
                                 default = newJBool(true))
  if valid_578935 != nil:
    section.add "prettyPrint", valid_578935
  var valid_578936 = query.getOrDefault("oauth_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "oauth_token", valid_578936
  var valid_578937 = query.getOrDefault("$.xgafv")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("1"))
  if valid_578937 != nil:
    section.add "$.xgafv", valid_578937
  var valid_578938 = query.getOrDefault("pageSize")
  valid_578938 = validateParameter(valid_578938, JInt, required = false, default = nil)
  if valid_578938 != nil:
    section.add "pageSize", valid_578938
  var valid_578939 = query.getOrDefault("alt")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = newJString("json"))
  if valid_578939 != nil:
    section.add "alt", valid_578939
  var valid_578940 = query.getOrDefault("uploadType")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "uploadType", valid_578940
  var valid_578941 = query.getOrDefault("quotaUser")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "quotaUser", valid_578941
  var valid_578942 = query.getOrDefault("pageToken")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "pageToken", valid_578942
  var valid_578943 = query.getOrDefault("callback")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "callback", valid_578943
  var valid_578944 = query.getOrDefault("fields")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "fields", valid_578944
  var valid_578945 = query.getOrDefault("access_token")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "access_token", valid_578945
  var valid_578946 = query.getOrDefault("upload_protocol")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "upload_protocol", valid_578946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578947: Call_RunNamespacesAuthorizeddomainsList_578930;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RPC to list authorized domains.
  ## 
  let valid = call_578947.validator(path, query, header, formData, body)
  let scheme = call_578947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578947.url(scheme.get, call_578947.host, call_578947.base,
                         call_578947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578947, url, valid)

proc call*(call_578948: Call_RunNamespacesAuthorizeddomainsList_578930;
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
  var path_578949 = newJObject()
  var query_578950 = newJObject()
  add(query_578950, "key", newJString(key))
  add(query_578950, "prettyPrint", newJBool(prettyPrint))
  add(query_578950, "oauth_token", newJString(oauthToken))
  add(query_578950, "$.xgafv", newJString(Xgafv))
  add(query_578950, "pageSize", newJInt(pageSize))
  add(query_578950, "alt", newJString(alt))
  add(query_578950, "uploadType", newJString(uploadType))
  add(query_578950, "quotaUser", newJString(quotaUser))
  add(query_578950, "pageToken", newJString(pageToken))
  add(query_578950, "callback", newJString(callback))
  add(path_578949, "parent", newJString(parent))
  add(query_578950, "fields", newJString(fields))
  add(query_578950, "access_token", newJString(accessToken))
  add(query_578950, "upload_protocol", newJString(uploadProtocol))
  result = call_578948.call(path_578949, query_578950, nil, nil, nil)

var runNamespacesAuthorizeddomainsList* = Call_RunNamespacesAuthorizeddomainsList_578930(
    name: "runNamespacesAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/authorizeddomains",
    validator: validate_RunNamespacesAuthorizeddomainsList_578931, base: "/",
    url: url_RunNamespacesAuthorizeddomainsList_578932, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsCreate_578977 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesDomainmappingsCreate_578979(protocol: Scheme; host: string;
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

proc validate_RunNamespacesDomainmappingsCreate_578978(path: JsonNode;
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
  var valid_578980 = path.getOrDefault("parent")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "parent", valid_578980
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
  var valid_578981 = query.getOrDefault("key")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "key", valid_578981
  var valid_578982 = query.getOrDefault("prettyPrint")
  valid_578982 = validateParameter(valid_578982, JBool, required = false,
                                 default = newJBool(true))
  if valid_578982 != nil:
    section.add "prettyPrint", valid_578982
  var valid_578983 = query.getOrDefault("oauth_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "oauth_token", valid_578983
  var valid_578984 = query.getOrDefault("$.xgafv")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = newJString("1"))
  if valid_578984 != nil:
    section.add "$.xgafv", valid_578984
  var valid_578985 = query.getOrDefault("alt")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = newJString("json"))
  if valid_578985 != nil:
    section.add "alt", valid_578985
  var valid_578986 = query.getOrDefault("uploadType")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "uploadType", valid_578986
  var valid_578987 = query.getOrDefault("quotaUser")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "quotaUser", valid_578987
  var valid_578988 = query.getOrDefault("callback")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "callback", valid_578988
  var valid_578989 = query.getOrDefault("fields")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "fields", valid_578989
  var valid_578990 = query.getOrDefault("access_token")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "access_token", valid_578990
  var valid_578991 = query.getOrDefault("upload_protocol")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "upload_protocol", valid_578991
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

proc call*(call_578993: Call_RunNamespacesDomainmappingsCreate_578977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new domain mapping.
  ## 
  let valid = call_578993.validator(path, query, header, formData, body)
  let scheme = call_578993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578993.url(scheme.get, call_578993.host, call_578993.base,
                         call_578993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578993, url, valid)

proc call*(call_578994: Call_RunNamespacesDomainmappingsCreate_578977;
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
  var path_578995 = newJObject()
  var query_578996 = newJObject()
  var body_578997 = newJObject()
  add(query_578996, "key", newJString(key))
  add(query_578996, "prettyPrint", newJBool(prettyPrint))
  add(query_578996, "oauth_token", newJString(oauthToken))
  add(query_578996, "$.xgafv", newJString(Xgafv))
  add(query_578996, "alt", newJString(alt))
  add(query_578996, "uploadType", newJString(uploadType))
  add(query_578996, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578997 = body
  add(query_578996, "callback", newJString(callback))
  add(path_578995, "parent", newJString(parent))
  add(query_578996, "fields", newJString(fields))
  add(query_578996, "access_token", newJString(accessToken))
  add(query_578996, "upload_protocol", newJString(uploadProtocol))
  result = call_578994.call(path_578995, query_578996, nil, nil, body_578997)

var runNamespacesDomainmappingsCreate* = Call_RunNamespacesDomainmappingsCreate_578977(
    name: "runNamespacesDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsCreate_578978, base: "/",
    url: url_RunNamespacesDomainmappingsCreate_578979, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsList_578951 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesDomainmappingsList_578953(protocol: Scheme; host: string;
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

proc validate_RunNamespacesDomainmappingsList_578952(path: JsonNode;
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
  var valid_578954 = path.getOrDefault("parent")
  valid_578954 = validateParameter(valid_578954, JString, required = true,
                                 default = nil)
  if valid_578954 != nil:
    section.add "parent", valid_578954
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
  var valid_578955 = query.getOrDefault("key")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "key", valid_578955
  var valid_578956 = query.getOrDefault("includeUninitialized")
  valid_578956 = validateParameter(valid_578956, JBool, required = false, default = nil)
  if valid_578956 != nil:
    section.add "includeUninitialized", valid_578956
  var valid_578957 = query.getOrDefault("prettyPrint")
  valid_578957 = validateParameter(valid_578957, JBool, required = false,
                                 default = newJBool(true))
  if valid_578957 != nil:
    section.add "prettyPrint", valid_578957
  var valid_578958 = query.getOrDefault("oauth_token")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "oauth_token", valid_578958
  var valid_578959 = query.getOrDefault("fieldSelector")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "fieldSelector", valid_578959
  var valid_578960 = query.getOrDefault("labelSelector")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "labelSelector", valid_578960
  var valid_578961 = query.getOrDefault("$.xgafv")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = newJString("1"))
  if valid_578961 != nil:
    section.add "$.xgafv", valid_578961
  var valid_578962 = query.getOrDefault("limit")
  valid_578962 = validateParameter(valid_578962, JInt, required = false, default = nil)
  if valid_578962 != nil:
    section.add "limit", valid_578962
  var valid_578963 = query.getOrDefault("alt")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("json"))
  if valid_578963 != nil:
    section.add "alt", valid_578963
  var valid_578964 = query.getOrDefault("uploadType")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "uploadType", valid_578964
  var valid_578965 = query.getOrDefault("quotaUser")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "quotaUser", valid_578965
  var valid_578966 = query.getOrDefault("watch")
  valid_578966 = validateParameter(valid_578966, JBool, required = false, default = nil)
  if valid_578966 != nil:
    section.add "watch", valid_578966
  var valid_578967 = query.getOrDefault("callback")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "callback", valid_578967
  var valid_578968 = query.getOrDefault("resourceVersion")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "resourceVersion", valid_578968
  var valid_578969 = query.getOrDefault("fields")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "fields", valid_578969
  var valid_578970 = query.getOrDefault("access_token")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "access_token", valid_578970
  var valid_578971 = query.getOrDefault("upload_protocol")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "upload_protocol", valid_578971
  var valid_578972 = query.getOrDefault("continue")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "continue", valid_578972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578973: Call_RunNamespacesDomainmappingsList_578951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list domain mappings.
  ## 
  let valid = call_578973.validator(path, query, header, formData, body)
  let scheme = call_578973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578973.url(scheme.get, call_578973.host, call_578973.base,
                         call_578973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578973, url, valid)

proc call*(call_578974: Call_RunNamespacesDomainmappingsList_578951;
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
  var path_578975 = newJObject()
  var query_578976 = newJObject()
  add(query_578976, "key", newJString(key))
  add(query_578976, "includeUninitialized", newJBool(includeUninitialized))
  add(query_578976, "prettyPrint", newJBool(prettyPrint))
  add(query_578976, "oauth_token", newJString(oauthToken))
  add(query_578976, "fieldSelector", newJString(fieldSelector))
  add(query_578976, "labelSelector", newJString(labelSelector))
  add(query_578976, "$.xgafv", newJString(Xgafv))
  add(query_578976, "limit", newJInt(limit))
  add(query_578976, "alt", newJString(alt))
  add(query_578976, "uploadType", newJString(uploadType))
  add(query_578976, "quotaUser", newJString(quotaUser))
  add(query_578976, "watch", newJBool(watch))
  add(query_578976, "callback", newJString(callback))
  add(path_578975, "parent", newJString(parent))
  add(query_578976, "resourceVersion", newJString(resourceVersion))
  add(query_578976, "fields", newJString(fields))
  add(query_578976, "access_token", newJString(accessToken))
  add(query_578976, "upload_protocol", newJString(uploadProtocol))
  add(query_578976, "continue", newJString(`continue`))
  result = call_578974.call(path_578975, query_578976, nil, nil, nil)

var runNamespacesDomainmappingsList* = Call_RunNamespacesDomainmappingsList_578951(
    name: "runNamespacesDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsList_578952, base: "/",
    url: url_RunNamespacesDomainmappingsList_578953, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersReplaceTrigger_579017 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesTriggersReplaceTrigger_579019(protocol: Scheme; host: string;
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

proc validate_RunNamespacesTriggersReplaceTrigger_579018(path: JsonNode;
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
  var valid_579020 = path.getOrDefault("name")
  valid_579020 = validateParameter(valid_579020, JString, required = true,
                                 default = nil)
  if valid_579020 != nil:
    section.add "name", valid_579020
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
  var valid_579021 = query.getOrDefault("key")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "key", valid_579021
  var valid_579022 = query.getOrDefault("prettyPrint")
  valid_579022 = validateParameter(valid_579022, JBool, required = false,
                                 default = newJBool(true))
  if valid_579022 != nil:
    section.add "prettyPrint", valid_579022
  var valid_579023 = query.getOrDefault("oauth_token")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "oauth_token", valid_579023
  var valid_579024 = query.getOrDefault("$.xgafv")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = newJString("1"))
  if valid_579024 != nil:
    section.add "$.xgafv", valid_579024
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
  var valid_579027 = query.getOrDefault("quotaUser")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "quotaUser", valid_579027
  var valid_579028 = query.getOrDefault("callback")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "callback", valid_579028
  var valid_579029 = query.getOrDefault("fields")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "fields", valid_579029
  var valid_579030 = query.getOrDefault("access_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "access_token", valid_579030
  var valid_579031 = query.getOrDefault("upload_protocol")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "upload_protocol", valid_579031
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

proc call*(call_579033: Call_RunNamespacesTriggersReplaceTrigger_579017;
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
  let valid = call_579033.validator(path, query, header, formData, body)
  let scheme = call_579033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579033.url(scheme.get, call_579033.host, call_579033.base,
                         call_579033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579033, url, valid)

proc call*(call_579034: Call_RunNamespacesTriggersReplaceTrigger_579017;
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
  var path_579035 = newJObject()
  var query_579036 = newJObject()
  var body_579037 = newJObject()
  add(query_579036, "key", newJString(key))
  add(query_579036, "prettyPrint", newJBool(prettyPrint))
  add(query_579036, "oauth_token", newJString(oauthToken))
  add(query_579036, "$.xgafv", newJString(Xgafv))
  add(query_579036, "alt", newJString(alt))
  add(query_579036, "uploadType", newJString(uploadType))
  add(query_579036, "quotaUser", newJString(quotaUser))
  add(path_579035, "name", newJString(name))
  if body != nil:
    body_579037 = body
  add(query_579036, "callback", newJString(callback))
  add(query_579036, "fields", newJString(fields))
  add(query_579036, "access_token", newJString(accessToken))
  add(query_579036, "upload_protocol", newJString(uploadProtocol))
  result = call_579034.call(path_579035, query_579036, nil, nil, body_579037)

var runNamespacesTriggersReplaceTrigger* = Call_RunNamespacesTriggersReplaceTrigger_579017(
    name: "runNamespacesTriggersReplaceTrigger", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersReplaceTrigger_579018, base: "/",
    url: url_RunNamespacesTriggersReplaceTrigger_579019, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersGet_578998 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesTriggersGet_579000(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_RunNamespacesTriggersGet_578999(path: JsonNode; query: JsonNode;
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
  var valid_579001 = path.getOrDefault("name")
  valid_579001 = validateParameter(valid_579001, JString, required = true,
                                 default = nil)
  if valid_579001 != nil:
    section.add "name", valid_579001
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
  var valid_579002 = query.getOrDefault("key")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "key", valid_579002
  var valid_579003 = query.getOrDefault("prettyPrint")
  valid_579003 = validateParameter(valid_579003, JBool, required = false,
                                 default = newJBool(true))
  if valid_579003 != nil:
    section.add "prettyPrint", valid_579003
  var valid_579004 = query.getOrDefault("oauth_token")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "oauth_token", valid_579004
  var valid_579005 = query.getOrDefault("$.xgafv")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = newJString("1"))
  if valid_579005 != nil:
    section.add "$.xgafv", valid_579005
  var valid_579006 = query.getOrDefault("alt")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = newJString("json"))
  if valid_579006 != nil:
    section.add "alt", valid_579006
  var valid_579007 = query.getOrDefault("uploadType")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "uploadType", valid_579007
  var valid_579008 = query.getOrDefault("quotaUser")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "quotaUser", valid_579008
  var valid_579009 = query.getOrDefault("callback")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "callback", valid_579009
  var valid_579010 = query.getOrDefault("fields")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "fields", valid_579010
  var valid_579011 = query.getOrDefault("access_token")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "access_token", valid_579011
  var valid_579012 = query.getOrDefault("upload_protocol")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "upload_protocol", valid_579012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579013: Call_RunNamespacesTriggersGet_578998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a trigger.
  ## 
  let valid = call_579013.validator(path, query, header, formData, body)
  let scheme = call_579013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579013.url(scheme.get, call_579013.host, call_579013.base,
                         call_579013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579013, url, valid)

proc call*(call_579014: Call_RunNamespacesTriggersGet_578998; name: string;
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
  var path_579015 = newJObject()
  var query_579016 = newJObject()
  add(query_579016, "key", newJString(key))
  add(query_579016, "prettyPrint", newJBool(prettyPrint))
  add(query_579016, "oauth_token", newJString(oauthToken))
  add(query_579016, "$.xgafv", newJString(Xgafv))
  add(query_579016, "alt", newJString(alt))
  add(query_579016, "uploadType", newJString(uploadType))
  add(query_579016, "quotaUser", newJString(quotaUser))
  add(path_579015, "name", newJString(name))
  add(query_579016, "callback", newJString(callback))
  add(query_579016, "fields", newJString(fields))
  add(query_579016, "access_token", newJString(accessToken))
  add(query_579016, "upload_protocol", newJString(uploadProtocol))
  result = call_579014.call(path_579015, query_579016, nil, nil, nil)

var runNamespacesTriggersGet* = Call_RunNamespacesTriggersGet_578998(
    name: "runNamespacesTriggersGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersGet_578999, base: "/",
    url: url_RunNamespacesTriggersGet_579000, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersDelete_579038 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesTriggersDelete_579040(protocol: Scheme; host: string;
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

proc validate_RunNamespacesTriggersDelete_579039(path: JsonNode; query: JsonNode;
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
  var valid_579041 = path.getOrDefault("name")
  valid_579041 = validateParameter(valid_579041, JString, required = true,
                                 default = nil)
  if valid_579041 != nil:
    section.add "name", valid_579041
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
  var valid_579042 = query.getOrDefault("key")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "key", valid_579042
  var valid_579043 = query.getOrDefault("prettyPrint")
  valid_579043 = validateParameter(valid_579043, JBool, required = false,
                                 default = newJBool(true))
  if valid_579043 != nil:
    section.add "prettyPrint", valid_579043
  var valid_579044 = query.getOrDefault("oauth_token")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "oauth_token", valid_579044
  var valid_579045 = query.getOrDefault("$.xgafv")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = newJString("1"))
  if valid_579045 != nil:
    section.add "$.xgafv", valid_579045
  var valid_579046 = query.getOrDefault("alt")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("json"))
  if valid_579046 != nil:
    section.add "alt", valid_579046
  var valid_579047 = query.getOrDefault("uploadType")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "uploadType", valid_579047
  var valid_579048 = query.getOrDefault("quotaUser")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "quotaUser", valid_579048
  var valid_579049 = query.getOrDefault("propagationPolicy")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "propagationPolicy", valid_579049
  var valid_579050 = query.getOrDefault("callback")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "callback", valid_579050
  var valid_579051 = query.getOrDefault("apiVersion")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "apiVersion", valid_579051
  var valid_579052 = query.getOrDefault("kind")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "kind", valid_579052
  var valid_579053 = query.getOrDefault("fields")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "fields", valid_579053
  var valid_579054 = query.getOrDefault("access_token")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "access_token", valid_579054
  var valid_579055 = query.getOrDefault("upload_protocol")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "upload_protocol", valid_579055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579056: Call_RunNamespacesTriggersDelete_579038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to delete a trigger.
  ## 
  let valid = call_579056.validator(path, query, header, formData, body)
  let scheme = call_579056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579056.url(scheme.get, call_579056.host, call_579056.base,
                         call_579056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579056, url, valid)

proc call*(call_579057: Call_RunNamespacesTriggersDelete_579038; name: string;
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
  var path_579058 = newJObject()
  var query_579059 = newJObject()
  add(query_579059, "key", newJString(key))
  add(query_579059, "prettyPrint", newJBool(prettyPrint))
  add(query_579059, "oauth_token", newJString(oauthToken))
  add(query_579059, "$.xgafv", newJString(Xgafv))
  add(query_579059, "alt", newJString(alt))
  add(query_579059, "uploadType", newJString(uploadType))
  add(query_579059, "quotaUser", newJString(quotaUser))
  add(path_579058, "name", newJString(name))
  add(query_579059, "propagationPolicy", newJString(propagationPolicy))
  add(query_579059, "callback", newJString(callback))
  add(query_579059, "apiVersion", newJString(apiVersion))
  add(query_579059, "kind", newJString(kind))
  add(query_579059, "fields", newJString(fields))
  add(query_579059, "access_token", newJString(accessToken))
  add(query_579059, "upload_protocol", newJString(uploadProtocol))
  result = call_579057.call(path_579058, query_579059, nil, nil, nil)

var runNamespacesTriggersDelete* = Call_RunNamespacesTriggersDelete_579038(
    name: "runNamespacesTriggersDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersDelete_579039, base: "/",
    url: url_RunNamespacesTriggersDelete_579040, schemes: {Scheme.Https})
type
  Call_RunNamespacesEventtypesList_579060 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesEventtypesList_579062(protocol: Scheme; host: string;
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

proc validate_RunNamespacesEventtypesList_579061(path: JsonNode; query: JsonNode;
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
  var valid_579063 = path.getOrDefault("parent")
  valid_579063 = validateParameter(valid_579063, JString, required = true,
                                 default = nil)
  if valid_579063 != nil:
    section.add "parent", valid_579063
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
  var valid_579064 = query.getOrDefault("key")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "key", valid_579064
  var valid_579065 = query.getOrDefault("includeUninitialized")
  valid_579065 = validateParameter(valid_579065, JBool, required = false, default = nil)
  if valid_579065 != nil:
    section.add "includeUninitialized", valid_579065
  var valid_579066 = query.getOrDefault("prettyPrint")
  valid_579066 = validateParameter(valid_579066, JBool, required = false,
                                 default = newJBool(true))
  if valid_579066 != nil:
    section.add "prettyPrint", valid_579066
  var valid_579067 = query.getOrDefault("oauth_token")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "oauth_token", valid_579067
  var valid_579068 = query.getOrDefault("fieldSelector")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "fieldSelector", valid_579068
  var valid_579069 = query.getOrDefault("labelSelector")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "labelSelector", valid_579069
  var valid_579070 = query.getOrDefault("$.xgafv")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("1"))
  if valid_579070 != nil:
    section.add "$.xgafv", valid_579070
  var valid_579071 = query.getOrDefault("limit")
  valid_579071 = validateParameter(valid_579071, JInt, required = false, default = nil)
  if valid_579071 != nil:
    section.add "limit", valid_579071
  var valid_579072 = query.getOrDefault("alt")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = newJString("json"))
  if valid_579072 != nil:
    section.add "alt", valid_579072
  var valid_579073 = query.getOrDefault("uploadType")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "uploadType", valid_579073
  var valid_579074 = query.getOrDefault("quotaUser")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "quotaUser", valid_579074
  var valid_579075 = query.getOrDefault("watch")
  valid_579075 = validateParameter(valid_579075, JBool, required = false, default = nil)
  if valid_579075 != nil:
    section.add "watch", valid_579075
  var valid_579076 = query.getOrDefault("callback")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "callback", valid_579076
  var valid_579077 = query.getOrDefault("resourceVersion")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "resourceVersion", valid_579077
  var valid_579078 = query.getOrDefault("fields")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "fields", valid_579078
  var valid_579079 = query.getOrDefault("access_token")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "access_token", valid_579079
  var valid_579080 = query.getOrDefault("upload_protocol")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "upload_protocol", valid_579080
  var valid_579081 = query.getOrDefault("continue")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "continue", valid_579081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579082: Call_RunNamespacesEventtypesList_579060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list EventTypes.
  ## 
  let valid = call_579082.validator(path, query, header, formData, body)
  let scheme = call_579082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579082.url(scheme.get, call_579082.host, call_579082.base,
                         call_579082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579082, url, valid)

proc call*(call_579083: Call_RunNamespacesEventtypesList_579060; parent: string;
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
  var path_579084 = newJObject()
  var query_579085 = newJObject()
  add(query_579085, "key", newJString(key))
  add(query_579085, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579085, "prettyPrint", newJBool(prettyPrint))
  add(query_579085, "oauth_token", newJString(oauthToken))
  add(query_579085, "fieldSelector", newJString(fieldSelector))
  add(query_579085, "labelSelector", newJString(labelSelector))
  add(query_579085, "$.xgafv", newJString(Xgafv))
  add(query_579085, "limit", newJInt(limit))
  add(query_579085, "alt", newJString(alt))
  add(query_579085, "uploadType", newJString(uploadType))
  add(query_579085, "quotaUser", newJString(quotaUser))
  add(query_579085, "watch", newJBool(watch))
  add(query_579085, "callback", newJString(callback))
  add(path_579084, "parent", newJString(parent))
  add(query_579085, "resourceVersion", newJString(resourceVersion))
  add(query_579085, "fields", newJString(fields))
  add(query_579085, "access_token", newJString(accessToken))
  add(query_579085, "upload_protocol", newJString(uploadProtocol))
  add(query_579085, "continue", newJString(`continue`))
  result = call_579083.call(path_579084, query_579085, nil, nil, nil)

var runNamespacesEventtypesList* = Call_RunNamespacesEventtypesList_579060(
    name: "runNamespacesEventtypesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/eventtypes",
    validator: validate_RunNamespacesEventtypesList_579061, base: "/",
    url: url_RunNamespacesEventtypesList_579062, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersCreate_579112 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesTriggersCreate_579114(protocol: Scheme; host: string;
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

proc validate_RunNamespacesTriggersCreate_579113(path: JsonNode; query: JsonNode;
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
  var valid_579115 = path.getOrDefault("parent")
  valid_579115 = validateParameter(valid_579115, JString, required = true,
                                 default = nil)
  if valid_579115 != nil:
    section.add "parent", valid_579115
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
  var valid_579116 = query.getOrDefault("key")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "key", valid_579116
  var valid_579117 = query.getOrDefault("prettyPrint")
  valid_579117 = validateParameter(valid_579117, JBool, required = false,
                                 default = newJBool(true))
  if valid_579117 != nil:
    section.add "prettyPrint", valid_579117
  var valid_579118 = query.getOrDefault("oauth_token")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "oauth_token", valid_579118
  var valid_579119 = query.getOrDefault("$.xgafv")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = newJString("1"))
  if valid_579119 != nil:
    section.add "$.xgafv", valid_579119
  var valid_579120 = query.getOrDefault("alt")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = newJString("json"))
  if valid_579120 != nil:
    section.add "alt", valid_579120
  var valid_579121 = query.getOrDefault("uploadType")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "uploadType", valid_579121
  var valid_579122 = query.getOrDefault("quotaUser")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "quotaUser", valid_579122
  var valid_579123 = query.getOrDefault("callback")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "callback", valid_579123
  var valid_579124 = query.getOrDefault("fields")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "fields", valid_579124
  var valid_579125 = query.getOrDefault("access_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "access_token", valid_579125
  var valid_579126 = query.getOrDefault("upload_protocol")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "upload_protocol", valid_579126
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

proc call*(call_579128: Call_RunNamespacesTriggersCreate_579112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new trigger.
  ## 
  let valid = call_579128.validator(path, query, header, formData, body)
  let scheme = call_579128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579128.url(scheme.get, call_579128.host, call_579128.base,
                         call_579128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579128, url, valid)

proc call*(call_579129: Call_RunNamespacesTriggersCreate_579112; parent: string;
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
  var path_579130 = newJObject()
  var query_579131 = newJObject()
  var body_579132 = newJObject()
  add(query_579131, "key", newJString(key))
  add(query_579131, "prettyPrint", newJBool(prettyPrint))
  add(query_579131, "oauth_token", newJString(oauthToken))
  add(query_579131, "$.xgafv", newJString(Xgafv))
  add(query_579131, "alt", newJString(alt))
  add(query_579131, "uploadType", newJString(uploadType))
  add(query_579131, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579132 = body
  add(query_579131, "callback", newJString(callback))
  add(path_579130, "parent", newJString(parent))
  add(query_579131, "fields", newJString(fields))
  add(query_579131, "access_token", newJString(accessToken))
  add(query_579131, "upload_protocol", newJString(uploadProtocol))
  result = call_579129.call(path_579130, query_579131, nil, nil, body_579132)

var runNamespacesTriggersCreate* = Call_RunNamespacesTriggersCreate_579112(
    name: "runNamespacesTriggersCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/triggers",
    validator: validate_RunNamespacesTriggersCreate_579113, base: "/",
    url: url_RunNamespacesTriggersCreate_579114, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersList_579086 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesTriggersList_579088(protocol: Scheme; host: string;
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

proc validate_RunNamespacesTriggersList_579087(path: JsonNode; query: JsonNode;
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
  var valid_579089 = path.getOrDefault("parent")
  valid_579089 = validateParameter(valid_579089, JString, required = true,
                                 default = nil)
  if valid_579089 != nil:
    section.add "parent", valid_579089
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
  var valid_579090 = query.getOrDefault("key")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "key", valid_579090
  var valid_579091 = query.getOrDefault("includeUninitialized")
  valid_579091 = validateParameter(valid_579091, JBool, required = false, default = nil)
  if valid_579091 != nil:
    section.add "includeUninitialized", valid_579091
  var valid_579092 = query.getOrDefault("prettyPrint")
  valid_579092 = validateParameter(valid_579092, JBool, required = false,
                                 default = newJBool(true))
  if valid_579092 != nil:
    section.add "prettyPrint", valid_579092
  var valid_579093 = query.getOrDefault("oauth_token")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "oauth_token", valid_579093
  var valid_579094 = query.getOrDefault("fieldSelector")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "fieldSelector", valid_579094
  var valid_579095 = query.getOrDefault("labelSelector")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "labelSelector", valid_579095
  var valid_579096 = query.getOrDefault("$.xgafv")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("1"))
  if valid_579096 != nil:
    section.add "$.xgafv", valid_579096
  var valid_579097 = query.getOrDefault("limit")
  valid_579097 = validateParameter(valid_579097, JInt, required = false, default = nil)
  if valid_579097 != nil:
    section.add "limit", valid_579097
  var valid_579098 = query.getOrDefault("alt")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = newJString("json"))
  if valid_579098 != nil:
    section.add "alt", valid_579098
  var valid_579099 = query.getOrDefault("uploadType")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "uploadType", valid_579099
  var valid_579100 = query.getOrDefault("quotaUser")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "quotaUser", valid_579100
  var valid_579101 = query.getOrDefault("watch")
  valid_579101 = validateParameter(valid_579101, JBool, required = false, default = nil)
  if valid_579101 != nil:
    section.add "watch", valid_579101
  var valid_579102 = query.getOrDefault("callback")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "callback", valid_579102
  var valid_579103 = query.getOrDefault("resourceVersion")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "resourceVersion", valid_579103
  var valid_579104 = query.getOrDefault("fields")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "fields", valid_579104
  var valid_579105 = query.getOrDefault("access_token")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "access_token", valid_579105
  var valid_579106 = query.getOrDefault("upload_protocol")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "upload_protocol", valid_579106
  var valid_579107 = query.getOrDefault("continue")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "continue", valid_579107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579108: Call_RunNamespacesTriggersList_579086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list triggers.
  ## 
  let valid = call_579108.validator(path, query, header, formData, body)
  let scheme = call_579108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579108.url(scheme.get, call_579108.host, call_579108.base,
                         call_579108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579108, url, valid)

proc call*(call_579109: Call_RunNamespacesTriggersList_579086; parent: string;
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
  var path_579110 = newJObject()
  var query_579111 = newJObject()
  add(query_579111, "key", newJString(key))
  add(query_579111, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579111, "prettyPrint", newJBool(prettyPrint))
  add(query_579111, "oauth_token", newJString(oauthToken))
  add(query_579111, "fieldSelector", newJString(fieldSelector))
  add(query_579111, "labelSelector", newJString(labelSelector))
  add(query_579111, "$.xgafv", newJString(Xgafv))
  add(query_579111, "limit", newJInt(limit))
  add(query_579111, "alt", newJString(alt))
  add(query_579111, "uploadType", newJString(uploadType))
  add(query_579111, "quotaUser", newJString(quotaUser))
  add(query_579111, "watch", newJBool(watch))
  add(query_579111, "callback", newJString(callback))
  add(path_579110, "parent", newJString(parent))
  add(query_579111, "resourceVersion", newJString(resourceVersion))
  add(query_579111, "fields", newJString(fields))
  add(query_579111, "access_token", newJString(accessToken))
  add(query_579111, "upload_protocol", newJString(uploadProtocol))
  add(query_579111, "continue", newJString(`continue`))
  result = call_579109.call(path_579110, query_579111, nil, nil, nil)

var runNamespacesTriggersList* = Call_RunNamespacesTriggersList_579086(
    name: "runNamespacesTriggersList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/triggers",
    validator: validate_RunNamespacesTriggersList_579087, base: "/",
    url: url_RunNamespacesTriggersList_579088, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesReplaceService_579152 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesServicesReplaceService_579154(protocol: Scheme; host: string;
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

proc validate_RunNamespacesServicesReplaceService_579153(path: JsonNode;
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
  var valid_579155 = path.getOrDefault("name")
  valid_579155 = validateParameter(valid_579155, JString, required = true,
                                 default = nil)
  if valid_579155 != nil:
    section.add "name", valid_579155
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
  var valid_579156 = query.getOrDefault("key")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "key", valid_579156
  var valid_579157 = query.getOrDefault("prettyPrint")
  valid_579157 = validateParameter(valid_579157, JBool, required = false,
                                 default = newJBool(true))
  if valid_579157 != nil:
    section.add "prettyPrint", valid_579157
  var valid_579158 = query.getOrDefault("oauth_token")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "oauth_token", valid_579158
  var valid_579159 = query.getOrDefault("$.xgafv")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = newJString("1"))
  if valid_579159 != nil:
    section.add "$.xgafv", valid_579159
  var valid_579160 = query.getOrDefault("alt")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = newJString("json"))
  if valid_579160 != nil:
    section.add "alt", valid_579160
  var valid_579161 = query.getOrDefault("uploadType")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "uploadType", valid_579161
  var valid_579162 = query.getOrDefault("quotaUser")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "quotaUser", valid_579162
  var valid_579163 = query.getOrDefault("callback")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "callback", valid_579163
  var valid_579164 = query.getOrDefault("fields")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "fields", valid_579164
  var valid_579165 = query.getOrDefault("access_token")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "access_token", valid_579165
  var valid_579166 = query.getOrDefault("upload_protocol")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "upload_protocol", valid_579166
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

proc call*(call_579168: Call_RunNamespacesServicesReplaceService_579152;
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
  let valid = call_579168.validator(path, query, header, formData, body)
  let scheme = call_579168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579168.url(scheme.get, call_579168.host, call_579168.base,
                         call_579168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579168, url, valid)

proc call*(call_579169: Call_RunNamespacesServicesReplaceService_579152;
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
  var path_579170 = newJObject()
  var query_579171 = newJObject()
  var body_579172 = newJObject()
  add(query_579171, "key", newJString(key))
  add(query_579171, "prettyPrint", newJBool(prettyPrint))
  add(query_579171, "oauth_token", newJString(oauthToken))
  add(query_579171, "$.xgafv", newJString(Xgafv))
  add(query_579171, "alt", newJString(alt))
  add(query_579171, "uploadType", newJString(uploadType))
  add(query_579171, "quotaUser", newJString(quotaUser))
  add(path_579170, "name", newJString(name))
  if body != nil:
    body_579172 = body
  add(query_579171, "callback", newJString(callback))
  add(query_579171, "fields", newJString(fields))
  add(query_579171, "access_token", newJString(accessToken))
  add(query_579171, "upload_protocol", newJString(uploadProtocol))
  result = call_579169.call(path_579170, query_579171, nil, nil, body_579172)

var runNamespacesServicesReplaceService* = Call_RunNamespacesServicesReplaceService_579152(
    name: "runNamespacesServicesReplaceService", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesServicesReplaceService_579153, base: "/",
    url: url_RunNamespacesServicesReplaceService_579154, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesGet_579133 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesServicesGet_579135(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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

proc validate_RunNamespacesServicesGet_579134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to get information about a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the service being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579136 = path.getOrDefault("name")
  valid_579136 = validateParameter(valid_579136, JString, required = true,
                                 default = nil)
  if valid_579136 != nil:
    section.add "name", valid_579136
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
  var valid_579137 = query.getOrDefault("key")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "key", valid_579137
  var valid_579138 = query.getOrDefault("prettyPrint")
  valid_579138 = validateParameter(valid_579138, JBool, required = false,
                                 default = newJBool(true))
  if valid_579138 != nil:
    section.add "prettyPrint", valid_579138
  var valid_579139 = query.getOrDefault("oauth_token")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "oauth_token", valid_579139
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
  var valid_579144 = query.getOrDefault("callback")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "callback", valid_579144
  var valid_579145 = query.getOrDefault("fields")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "fields", valid_579145
  var valid_579146 = query.getOrDefault("access_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "access_token", valid_579146
  var valid_579147 = query.getOrDefault("upload_protocol")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "upload_protocol", valid_579147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579148: Call_RunNamespacesServicesGet_579133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a service.
  ## 
  let valid = call_579148.validator(path, query, header, formData, body)
  let scheme = call_579148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579148.url(scheme.get, call_579148.host, call_579148.base,
                         call_579148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579148, url, valid)

proc call*(call_579149: Call_RunNamespacesServicesGet_579133; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesServicesGet
  ## Rpc to get information about a service.
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
  ##       : The name of the service being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579150 = newJObject()
  var query_579151 = newJObject()
  add(query_579151, "key", newJString(key))
  add(query_579151, "prettyPrint", newJBool(prettyPrint))
  add(query_579151, "oauth_token", newJString(oauthToken))
  add(query_579151, "$.xgafv", newJString(Xgafv))
  add(query_579151, "alt", newJString(alt))
  add(query_579151, "uploadType", newJString(uploadType))
  add(query_579151, "quotaUser", newJString(quotaUser))
  add(path_579150, "name", newJString(name))
  add(query_579151, "callback", newJString(callback))
  add(query_579151, "fields", newJString(fields))
  add(query_579151, "access_token", newJString(accessToken))
  add(query_579151, "upload_protocol", newJString(uploadProtocol))
  result = call_579149.call(path_579150, query_579151, nil, nil, nil)

var runNamespacesServicesGet* = Call_RunNamespacesServicesGet_579133(
    name: "runNamespacesServicesGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesServicesGet_579134, base: "/",
    url: url_RunNamespacesServicesGet_579135, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesDelete_579173 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesServicesDelete_579175(protocol: Scheme; host: string;
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

proc validate_RunNamespacesServicesDelete_579174(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to delete a service.
  ## This will cause the Service to stop serving traffic and will delete the
  ## child entities like Routes, Configurations and Revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the service being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579176 = path.getOrDefault("name")
  valid_579176 = validateParameter(valid_579176, JString, required = true,
                                 default = nil)
  if valid_579176 != nil:
    section.add "name", valid_579176
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
  var valid_579177 = query.getOrDefault("key")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "key", valid_579177
  var valid_579178 = query.getOrDefault("prettyPrint")
  valid_579178 = validateParameter(valid_579178, JBool, required = false,
                                 default = newJBool(true))
  if valid_579178 != nil:
    section.add "prettyPrint", valid_579178
  var valid_579179 = query.getOrDefault("oauth_token")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "oauth_token", valid_579179
  var valid_579180 = query.getOrDefault("$.xgafv")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = newJString("1"))
  if valid_579180 != nil:
    section.add "$.xgafv", valid_579180
  var valid_579181 = query.getOrDefault("alt")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = newJString("json"))
  if valid_579181 != nil:
    section.add "alt", valid_579181
  var valid_579182 = query.getOrDefault("uploadType")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "uploadType", valid_579182
  var valid_579183 = query.getOrDefault("quotaUser")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "quotaUser", valid_579183
  var valid_579184 = query.getOrDefault("propagationPolicy")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "propagationPolicy", valid_579184
  var valid_579185 = query.getOrDefault("callback")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "callback", valid_579185
  var valid_579186 = query.getOrDefault("apiVersion")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "apiVersion", valid_579186
  var valid_579187 = query.getOrDefault("orphanDependents")
  valid_579187 = validateParameter(valid_579187, JBool, required = false, default = nil)
  if valid_579187 != nil:
    section.add "orphanDependents", valid_579187
  var valid_579188 = query.getOrDefault("kind")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "kind", valid_579188
  var valid_579189 = query.getOrDefault("fields")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "fields", valid_579189
  var valid_579190 = query.getOrDefault("access_token")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "access_token", valid_579190
  var valid_579191 = query.getOrDefault("upload_protocol")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "upload_protocol", valid_579191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579192: Call_RunNamespacesServicesDelete_579173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to delete a service.
  ## This will cause the Service to stop serving traffic and will delete the
  ## child entities like Routes, Configurations and Revisions.
  ## 
  let valid = call_579192.validator(path, query, header, formData, body)
  let scheme = call_579192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579192.url(scheme.get, call_579192.host, call_579192.base,
                         call_579192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579192, url, valid)

proc call*(call_579193: Call_RunNamespacesServicesDelete_579173; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; propagationPolicy: string = ""; callback: string = "";
          apiVersion: string = ""; orphanDependents: bool = false; kind: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesServicesDelete
  ## Rpc to delete a service.
  ## This will cause the Service to stop serving traffic and will delete the
  ## child entities like Routes, Configurations and Revisions.
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
  ##       : The name of the service being deleted. If needed, replace
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
  var path_579194 = newJObject()
  var query_579195 = newJObject()
  add(query_579195, "key", newJString(key))
  add(query_579195, "prettyPrint", newJBool(prettyPrint))
  add(query_579195, "oauth_token", newJString(oauthToken))
  add(query_579195, "$.xgafv", newJString(Xgafv))
  add(query_579195, "alt", newJString(alt))
  add(query_579195, "uploadType", newJString(uploadType))
  add(query_579195, "quotaUser", newJString(quotaUser))
  add(path_579194, "name", newJString(name))
  add(query_579195, "propagationPolicy", newJString(propagationPolicy))
  add(query_579195, "callback", newJString(callback))
  add(query_579195, "apiVersion", newJString(apiVersion))
  add(query_579195, "orphanDependents", newJBool(orphanDependents))
  add(query_579195, "kind", newJString(kind))
  add(query_579195, "fields", newJString(fields))
  add(query_579195, "access_token", newJString(accessToken))
  add(query_579195, "upload_protocol", newJString(uploadProtocol))
  result = call_579193.call(path_579194, query_579195, nil, nil, nil)

var runNamespacesServicesDelete* = Call_RunNamespacesServicesDelete_579173(
    name: "runNamespacesServicesDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesServicesDelete_579174, base: "/",
    url: url_RunNamespacesServicesDelete_579175, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsList_579196 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesConfigurationsList_579198(protocol: Scheme; host: string;
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

proc validate_RunNamespacesConfigurationsList_579197(path: JsonNode;
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
  var valid_579199 = path.getOrDefault("parent")
  valid_579199 = validateParameter(valid_579199, JString, required = true,
                                 default = nil)
  if valid_579199 != nil:
    section.add "parent", valid_579199
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
  var valid_579200 = query.getOrDefault("key")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "key", valid_579200
  var valid_579201 = query.getOrDefault("includeUninitialized")
  valid_579201 = validateParameter(valid_579201, JBool, required = false, default = nil)
  if valid_579201 != nil:
    section.add "includeUninitialized", valid_579201
  var valid_579202 = query.getOrDefault("prettyPrint")
  valid_579202 = validateParameter(valid_579202, JBool, required = false,
                                 default = newJBool(true))
  if valid_579202 != nil:
    section.add "prettyPrint", valid_579202
  var valid_579203 = query.getOrDefault("oauth_token")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "oauth_token", valid_579203
  var valid_579204 = query.getOrDefault("fieldSelector")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "fieldSelector", valid_579204
  var valid_579205 = query.getOrDefault("labelSelector")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "labelSelector", valid_579205
  var valid_579206 = query.getOrDefault("$.xgafv")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = newJString("1"))
  if valid_579206 != nil:
    section.add "$.xgafv", valid_579206
  var valid_579207 = query.getOrDefault("limit")
  valid_579207 = validateParameter(valid_579207, JInt, required = false, default = nil)
  if valid_579207 != nil:
    section.add "limit", valid_579207
  var valid_579208 = query.getOrDefault("alt")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = newJString("json"))
  if valid_579208 != nil:
    section.add "alt", valid_579208
  var valid_579209 = query.getOrDefault("uploadType")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "uploadType", valid_579209
  var valid_579210 = query.getOrDefault("quotaUser")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "quotaUser", valid_579210
  var valid_579211 = query.getOrDefault("watch")
  valid_579211 = validateParameter(valid_579211, JBool, required = false, default = nil)
  if valid_579211 != nil:
    section.add "watch", valid_579211
  var valid_579212 = query.getOrDefault("callback")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "callback", valid_579212
  var valid_579213 = query.getOrDefault("resourceVersion")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "resourceVersion", valid_579213
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
  var valid_579217 = query.getOrDefault("continue")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "continue", valid_579217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579218: Call_RunNamespacesConfigurationsList_579196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list configurations.
  ## 
  let valid = call_579218.validator(path, query, header, formData, body)
  let scheme = call_579218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579218.url(scheme.get, call_579218.host, call_579218.base,
                         call_579218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579218, url, valid)

proc call*(call_579219: Call_RunNamespacesConfigurationsList_579196;
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
  var path_579220 = newJObject()
  var query_579221 = newJObject()
  add(query_579221, "key", newJString(key))
  add(query_579221, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579221, "prettyPrint", newJBool(prettyPrint))
  add(query_579221, "oauth_token", newJString(oauthToken))
  add(query_579221, "fieldSelector", newJString(fieldSelector))
  add(query_579221, "labelSelector", newJString(labelSelector))
  add(query_579221, "$.xgafv", newJString(Xgafv))
  add(query_579221, "limit", newJInt(limit))
  add(query_579221, "alt", newJString(alt))
  add(query_579221, "uploadType", newJString(uploadType))
  add(query_579221, "quotaUser", newJString(quotaUser))
  add(query_579221, "watch", newJBool(watch))
  add(query_579221, "callback", newJString(callback))
  add(path_579220, "parent", newJString(parent))
  add(query_579221, "resourceVersion", newJString(resourceVersion))
  add(query_579221, "fields", newJString(fields))
  add(query_579221, "access_token", newJString(accessToken))
  add(query_579221, "upload_protocol", newJString(uploadProtocol))
  add(query_579221, "continue", newJString(`continue`))
  result = call_579219.call(path_579220, query_579221, nil, nil, nil)

var runNamespacesConfigurationsList* = Call_RunNamespacesConfigurationsList_579196(
    name: "runNamespacesConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsList_579197, base: "/",
    url: url_RunNamespacesConfigurationsList_579198, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsList_579222 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesRevisionsList_579224(protocol: Scheme; host: string;
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

proc validate_RunNamespacesRevisionsList_579223(path: JsonNode; query: JsonNode;
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
  var valid_579225 = path.getOrDefault("parent")
  valid_579225 = validateParameter(valid_579225, JString, required = true,
                                 default = nil)
  if valid_579225 != nil:
    section.add "parent", valid_579225
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
  var valid_579226 = query.getOrDefault("key")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "key", valid_579226
  var valid_579227 = query.getOrDefault("includeUninitialized")
  valid_579227 = validateParameter(valid_579227, JBool, required = false, default = nil)
  if valid_579227 != nil:
    section.add "includeUninitialized", valid_579227
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
  var valid_579230 = query.getOrDefault("fieldSelector")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "fieldSelector", valid_579230
  var valid_579231 = query.getOrDefault("labelSelector")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "labelSelector", valid_579231
  var valid_579232 = query.getOrDefault("$.xgafv")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = newJString("1"))
  if valid_579232 != nil:
    section.add "$.xgafv", valid_579232
  var valid_579233 = query.getOrDefault("limit")
  valid_579233 = validateParameter(valid_579233, JInt, required = false, default = nil)
  if valid_579233 != nil:
    section.add "limit", valid_579233
  var valid_579234 = query.getOrDefault("alt")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = newJString("json"))
  if valid_579234 != nil:
    section.add "alt", valid_579234
  var valid_579235 = query.getOrDefault("uploadType")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "uploadType", valid_579235
  var valid_579236 = query.getOrDefault("quotaUser")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "quotaUser", valid_579236
  var valid_579237 = query.getOrDefault("watch")
  valid_579237 = validateParameter(valid_579237, JBool, required = false, default = nil)
  if valid_579237 != nil:
    section.add "watch", valid_579237
  var valid_579238 = query.getOrDefault("callback")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "callback", valid_579238
  var valid_579239 = query.getOrDefault("resourceVersion")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "resourceVersion", valid_579239
  var valid_579240 = query.getOrDefault("fields")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "fields", valid_579240
  var valid_579241 = query.getOrDefault("access_token")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "access_token", valid_579241
  var valid_579242 = query.getOrDefault("upload_protocol")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "upload_protocol", valid_579242
  var valid_579243 = query.getOrDefault("continue")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "continue", valid_579243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579244: Call_RunNamespacesRevisionsList_579222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list revisions.
  ## 
  let valid = call_579244.validator(path, query, header, formData, body)
  let scheme = call_579244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579244.url(scheme.get, call_579244.host, call_579244.base,
                         call_579244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579244, url, valid)

proc call*(call_579245: Call_RunNamespacesRevisionsList_579222; parent: string;
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
  var path_579246 = newJObject()
  var query_579247 = newJObject()
  add(query_579247, "key", newJString(key))
  add(query_579247, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579247, "prettyPrint", newJBool(prettyPrint))
  add(query_579247, "oauth_token", newJString(oauthToken))
  add(query_579247, "fieldSelector", newJString(fieldSelector))
  add(query_579247, "labelSelector", newJString(labelSelector))
  add(query_579247, "$.xgafv", newJString(Xgafv))
  add(query_579247, "limit", newJInt(limit))
  add(query_579247, "alt", newJString(alt))
  add(query_579247, "uploadType", newJString(uploadType))
  add(query_579247, "quotaUser", newJString(quotaUser))
  add(query_579247, "watch", newJBool(watch))
  add(query_579247, "callback", newJString(callback))
  add(path_579246, "parent", newJString(parent))
  add(query_579247, "resourceVersion", newJString(resourceVersion))
  add(query_579247, "fields", newJString(fields))
  add(query_579247, "access_token", newJString(accessToken))
  add(query_579247, "upload_protocol", newJString(uploadProtocol))
  add(query_579247, "continue", newJString(`continue`))
  result = call_579245.call(path_579246, query_579247, nil, nil, nil)

var runNamespacesRevisionsList* = Call_RunNamespacesRevisionsList_579222(
    name: "runNamespacesRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/revisions",
    validator: validate_RunNamespacesRevisionsList_579223, base: "/",
    url: url_RunNamespacesRevisionsList_579224, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesList_579248 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesRoutesList_579250(protocol: Scheme; host: string; base: string;
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

proc validate_RunNamespacesRoutesList_579249(path: JsonNode; query: JsonNode;
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
  var valid_579251 = path.getOrDefault("parent")
  valid_579251 = validateParameter(valid_579251, JString, required = true,
                                 default = nil)
  if valid_579251 != nil:
    section.add "parent", valid_579251
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
  var valid_579252 = query.getOrDefault("key")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "key", valid_579252
  var valid_579253 = query.getOrDefault("includeUninitialized")
  valid_579253 = validateParameter(valid_579253, JBool, required = false, default = nil)
  if valid_579253 != nil:
    section.add "includeUninitialized", valid_579253
  var valid_579254 = query.getOrDefault("prettyPrint")
  valid_579254 = validateParameter(valid_579254, JBool, required = false,
                                 default = newJBool(true))
  if valid_579254 != nil:
    section.add "prettyPrint", valid_579254
  var valid_579255 = query.getOrDefault("oauth_token")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "oauth_token", valid_579255
  var valid_579256 = query.getOrDefault("fieldSelector")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "fieldSelector", valid_579256
  var valid_579257 = query.getOrDefault("labelSelector")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "labelSelector", valid_579257
  var valid_579258 = query.getOrDefault("$.xgafv")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = newJString("1"))
  if valid_579258 != nil:
    section.add "$.xgafv", valid_579258
  var valid_579259 = query.getOrDefault("limit")
  valid_579259 = validateParameter(valid_579259, JInt, required = false, default = nil)
  if valid_579259 != nil:
    section.add "limit", valid_579259
  var valid_579260 = query.getOrDefault("alt")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = newJString("json"))
  if valid_579260 != nil:
    section.add "alt", valid_579260
  var valid_579261 = query.getOrDefault("uploadType")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "uploadType", valid_579261
  var valid_579262 = query.getOrDefault("quotaUser")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "quotaUser", valid_579262
  var valid_579263 = query.getOrDefault("watch")
  valid_579263 = validateParameter(valid_579263, JBool, required = false, default = nil)
  if valid_579263 != nil:
    section.add "watch", valid_579263
  var valid_579264 = query.getOrDefault("callback")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "callback", valid_579264
  var valid_579265 = query.getOrDefault("resourceVersion")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "resourceVersion", valid_579265
  var valid_579266 = query.getOrDefault("fields")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "fields", valid_579266
  var valid_579267 = query.getOrDefault("access_token")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "access_token", valid_579267
  var valid_579268 = query.getOrDefault("upload_protocol")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "upload_protocol", valid_579268
  var valid_579269 = query.getOrDefault("continue")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "continue", valid_579269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579270: Call_RunNamespacesRoutesList_579248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list routes.
  ## 
  let valid = call_579270.validator(path, query, header, formData, body)
  let scheme = call_579270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579270.url(scheme.get, call_579270.host, call_579270.base,
                         call_579270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579270, url, valid)

proc call*(call_579271: Call_RunNamespacesRoutesList_579248; parent: string;
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
  var path_579272 = newJObject()
  var query_579273 = newJObject()
  add(query_579273, "key", newJString(key))
  add(query_579273, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579273, "prettyPrint", newJBool(prettyPrint))
  add(query_579273, "oauth_token", newJString(oauthToken))
  add(query_579273, "fieldSelector", newJString(fieldSelector))
  add(query_579273, "labelSelector", newJString(labelSelector))
  add(query_579273, "$.xgafv", newJString(Xgafv))
  add(query_579273, "limit", newJInt(limit))
  add(query_579273, "alt", newJString(alt))
  add(query_579273, "uploadType", newJString(uploadType))
  add(query_579273, "quotaUser", newJString(quotaUser))
  add(query_579273, "watch", newJBool(watch))
  add(query_579273, "callback", newJString(callback))
  add(path_579272, "parent", newJString(parent))
  add(query_579273, "resourceVersion", newJString(resourceVersion))
  add(query_579273, "fields", newJString(fields))
  add(query_579273, "access_token", newJString(accessToken))
  add(query_579273, "upload_protocol", newJString(uploadProtocol))
  add(query_579273, "continue", newJString(`continue`))
  result = call_579271.call(path_579272, query_579273, nil, nil, nil)

var runNamespacesRoutesList* = Call_RunNamespacesRoutesList_579248(
    name: "runNamespacesRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/routes",
    validator: validate_RunNamespacesRoutesList_579249, base: "/",
    url: url_RunNamespacesRoutesList_579250, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesCreate_579300 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesServicesCreate_579302(protocol: Scheme; host: string;
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

proc validate_RunNamespacesServicesCreate_579301(path: JsonNode; query: JsonNode;
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
  var valid_579303 = path.getOrDefault("parent")
  valid_579303 = validateParameter(valid_579303, JString, required = true,
                                 default = nil)
  if valid_579303 != nil:
    section.add "parent", valid_579303
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
  var valid_579304 = query.getOrDefault("key")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "key", valid_579304
  var valid_579305 = query.getOrDefault("prettyPrint")
  valid_579305 = validateParameter(valid_579305, JBool, required = false,
                                 default = newJBool(true))
  if valid_579305 != nil:
    section.add "prettyPrint", valid_579305
  var valid_579306 = query.getOrDefault("oauth_token")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "oauth_token", valid_579306
  var valid_579307 = query.getOrDefault("$.xgafv")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = newJString("1"))
  if valid_579307 != nil:
    section.add "$.xgafv", valid_579307
  var valid_579308 = query.getOrDefault("alt")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = newJString("json"))
  if valid_579308 != nil:
    section.add "alt", valid_579308
  var valid_579309 = query.getOrDefault("uploadType")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "uploadType", valid_579309
  var valid_579310 = query.getOrDefault("quotaUser")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "quotaUser", valid_579310
  var valid_579311 = query.getOrDefault("callback")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "callback", valid_579311
  var valid_579312 = query.getOrDefault("fields")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "fields", valid_579312
  var valid_579313 = query.getOrDefault("access_token")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "access_token", valid_579313
  var valid_579314 = query.getOrDefault("upload_protocol")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "upload_protocol", valid_579314
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

proc call*(call_579316: Call_RunNamespacesServicesCreate_579300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to create a service.
  ## 
  let valid = call_579316.validator(path, query, header, formData, body)
  let scheme = call_579316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579316.url(scheme.get, call_579316.host, call_579316.base,
                         call_579316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579316, url, valid)

proc call*(call_579317: Call_RunNamespacesServicesCreate_579300; parent: string;
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
  var path_579318 = newJObject()
  var query_579319 = newJObject()
  var body_579320 = newJObject()
  add(query_579319, "key", newJString(key))
  add(query_579319, "prettyPrint", newJBool(prettyPrint))
  add(query_579319, "oauth_token", newJString(oauthToken))
  add(query_579319, "$.xgafv", newJString(Xgafv))
  add(query_579319, "alt", newJString(alt))
  add(query_579319, "uploadType", newJString(uploadType))
  add(query_579319, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579320 = body
  add(query_579319, "callback", newJString(callback))
  add(path_579318, "parent", newJString(parent))
  add(query_579319, "fields", newJString(fields))
  add(query_579319, "access_token", newJString(accessToken))
  add(query_579319, "upload_protocol", newJString(uploadProtocol))
  result = call_579317.call(path_579318, query_579319, nil, nil, body_579320)

var runNamespacesServicesCreate* = Call_RunNamespacesServicesCreate_579300(
    name: "runNamespacesServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/services",
    validator: validate_RunNamespacesServicesCreate_579301, base: "/",
    url: url_RunNamespacesServicesCreate_579302, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesList_579274 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesServicesList_579276(protocol: Scheme; host: string;
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

proc validate_RunNamespacesServicesList_579275(path: JsonNode; query: JsonNode;
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
  var valid_579277 = path.getOrDefault("parent")
  valid_579277 = validateParameter(valid_579277, JString, required = true,
                                 default = nil)
  if valid_579277 != nil:
    section.add "parent", valid_579277
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
  var valid_579278 = query.getOrDefault("key")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "key", valid_579278
  var valid_579279 = query.getOrDefault("includeUninitialized")
  valid_579279 = validateParameter(valid_579279, JBool, required = false, default = nil)
  if valid_579279 != nil:
    section.add "includeUninitialized", valid_579279
  var valid_579280 = query.getOrDefault("prettyPrint")
  valid_579280 = validateParameter(valid_579280, JBool, required = false,
                                 default = newJBool(true))
  if valid_579280 != nil:
    section.add "prettyPrint", valid_579280
  var valid_579281 = query.getOrDefault("oauth_token")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "oauth_token", valid_579281
  var valid_579282 = query.getOrDefault("fieldSelector")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "fieldSelector", valid_579282
  var valid_579283 = query.getOrDefault("labelSelector")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "labelSelector", valid_579283
  var valid_579284 = query.getOrDefault("$.xgafv")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = newJString("1"))
  if valid_579284 != nil:
    section.add "$.xgafv", valid_579284
  var valid_579285 = query.getOrDefault("limit")
  valid_579285 = validateParameter(valid_579285, JInt, required = false, default = nil)
  if valid_579285 != nil:
    section.add "limit", valid_579285
  var valid_579286 = query.getOrDefault("alt")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = newJString("json"))
  if valid_579286 != nil:
    section.add "alt", valid_579286
  var valid_579287 = query.getOrDefault("uploadType")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "uploadType", valid_579287
  var valid_579288 = query.getOrDefault("quotaUser")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "quotaUser", valid_579288
  var valid_579289 = query.getOrDefault("watch")
  valid_579289 = validateParameter(valid_579289, JBool, required = false, default = nil)
  if valid_579289 != nil:
    section.add "watch", valid_579289
  var valid_579290 = query.getOrDefault("callback")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "callback", valid_579290
  var valid_579291 = query.getOrDefault("resourceVersion")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "resourceVersion", valid_579291
  var valid_579292 = query.getOrDefault("fields")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "fields", valid_579292
  var valid_579293 = query.getOrDefault("access_token")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "access_token", valid_579293
  var valid_579294 = query.getOrDefault("upload_protocol")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "upload_protocol", valid_579294
  var valid_579295 = query.getOrDefault("continue")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "continue", valid_579295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579296: Call_RunNamespacesServicesList_579274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list services.
  ## 
  let valid = call_579296.validator(path, query, header, formData, body)
  let scheme = call_579296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579296.url(scheme.get, call_579296.host, call_579296.base,
                         call_579296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579296, url, valid)

proc call*(call_579297: Call_RunNamespacesServicesList_579274; parent: string;
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
  var path_579298 = newJObject()
  var query_579299 = newJObject()
  add(query_579299, "key", newJString(key))
  add(query_579299, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579299, "prettyPrint", newJBool(prettyPrint))
  add(query_579299, "oauth_token", newJString(oauthToken))
  add(query_579299, "fieldSelector", newJString(fieldSelector))
  add(query_579299, "labelSelector", newJString(labelSelector))
  add(query_579299, "$.xgafv", newJString(Xgafv))
  add(query_579299, "limit", newJInt(limit))
  add(query_579299, "alt", newJString(alt))
  add(query_579299, "uploadType", newJString(uploadType))
  add(query_579299, "quotaUser", newJString(quotaUser))
  add(query_579299, "watch", newJBool(watch))
  add(query_579299, "callback", newJString(callback))
  add(path_579298, "parent", newJString(parent))
  add(query_579299, "resourceVersion", newJString(resourceVersion))
  add(query_579299, "fields", newJString(fields))
  add(query_579299, "access_token", newJString(accessToken))
  add(query_579299, "upload_protocol", newJString(uploadProtocol))
  add(query_579299, "continue", newJString(`continue`))
  result = call_579297.call(path_579298, query_579299, nil, nil, nil)

var runNamespacesServicesList* = Call_RunNamespacesServicesList_579274(
    name: "runNamespacesServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/services",
    validator: validate_RunNamespacesServicesList_579275, base: "/",
    url: url_RunNamespacesServicesList_579276, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesReplaceService_579340 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesReplaceService_579342(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesReplaceService_579341(path: JsonNode;
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
  var valid_579343 = path.getOrDefault("name")
  valid_579343 = validateParameter(valid_579343, JString, required = true,
                                 default = nil)
  if valid_579343 != nil:
    section.add "name", valid_579343
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
  var valid_579344 = query.getOrDefault("key")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "key", valid_579344
  var valid_579345 = query.getOrDefault("prettyPrint")
  valid_579345 = validateParameter(valid_579345, JBool, required = false,
                                 default = newJBool(true))
  if valid_579345 != nil:
    section.add "prettyPrint", valid_579345
  var valid_579346 = query.getOrDefault("oauth_token")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "oauth_token", valid_579346
  var valid_579347 = query.getOrDefault("$.xgafv")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = newJString("1"))
  if valid_579347 != nil:
    section.add "$.xgafv", valid_579347
  var valid_579348 = query.getOrDefault("alt")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = newJString("json"))
  if valid_579348 != nil:
    section.add "alt", valid_579348
  var valid_579349 = query.getOrDefault("uploadType")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "uploadType", valid_579349
  var valid_579350 = query.getOrDefault("quotaUser")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "quotaUser", valid_579350
  var valid_579351 = query.getOrDefault("callback")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "callback", valid_579351
  var valid_579352 = query.getOrDefault("fields")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "fields", valid_579352
  var valid_579353 = query.getOrDefault("access_token")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "access_token", valid_579353
  var valid_579354 = query.getOrDefault("upload_protocol")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "upload_protocol", valid_579354
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

proc call*(call_579356: Call_RunProjectsLocationsServicesReplaceService_579340;
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
  let valid = call_579356.validator(path, query, header, formData, body)
  let scheme = call_579356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579356.url(scheme.get, call_579356.host, call_579356.base,
                         call_579356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579356, url, valid)

proc call*(call_579357: Call_RunProjectsLocationsServicesReplaceService_579340;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesReplaceService
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
  var path_579358 = newJObject()
  var query_579359 = newJObject()
  var body_579360 = newJObject()
  add(query_579359, "key", newJString(key))
  add(query_579359, "prettyPrint", newJBool(prettyPrint))
  add(query_579359, "oauth_token", newJString(oauthToken))
  add(query_579359, "$.xgafv", newJString(Xgafv))
  add(query_579359, "alt", newJString(alt))
  add(query_579359, "uploadType", newJString(uploadType))
  add(query_579359, "quotaUser", newJString(quotaUser))
  add(path_579358, "name", newJString(name))
  if body != nil:
    body_579360 = body
  add(query_579359, "callback", newJString(callback))
  add(query_579359, "fields", newJString(fields))
  add(query_579359, "access_token", newJString(accessToken))
  add(query_579359, "upload_protocol", newJString(uploadProtocol))
  result = call_579357.call(path_579358, query_579359, nil, nil, body_579360)

var runProjectsLocationsServicesReplaceService* = Call_RunProjectsLocationsServicesReplaceService_579340(
    name: "runProjectsLocationsServicesReplaceService", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsServicesReplaceService_579341,
    base: "/", url: url_RunProjectsLocationsServicesReplaceService_579342,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsGet_579321 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsDomainmappingsGet_579323(protocol: Scheme;
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

proc validate_RunProjectsLocationsDomainmappingsGet_579322(path: JsonNode;
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
  var valid_579324 = path.getOrDefault("name")
  valid_579324 = validateParameter(valid_579324, JString, required = true,
                                 default = nil)
  if valid_579324 != nil:
    section.add "name", valid_579324
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
  var valid_579325 = query.getOrDefault("key")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "key", valid_579325
  var valid_579326 = query.getOrDefault("prettyPrint")
  valid_579326 = validateParameter(valid_579326, JBool, required = false,
                                 default = newJBool(true))
  if valid_579326 != nil:
    section.add "prettyPrint", valid_579326
  var valid_579327 = query.getOrDefault("oauth_token")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "oauth_token", valid_579327
  var valid_579328 = query.getOrDefault("$.xgafv")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = newJString("1"))
  if valid_579328 != nil:
    section.add "$.xgafv", valid_579328
  var valid_579329 = query.getOrDefault("alt")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = newJString("json"))
  if valid_579329 != nil:
    section.add "alt", valid_579329
  var valid_579330 = query.getOrDefault("uploadType")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "uploadType", valid_579330
  var valid_579331 = query.getOrDefault("quotaUser")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "quotaUser", valid_579331
  var valid_579332 = query.getOrDefault("callback")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "callback", valid_579332
  var valid_579333 = query.getOrDefault("fields")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "fields", valid_579333
  var valid_579334 = query.getOrDefault("access_token")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "access_token", valid_579334
  var valid_579335 = query.getOrDefault("upload_protocol")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "upload_protocol", valid_579335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579336: Call_RunProjectsLocationsDomainmappingsGet_579321;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to get information about a domain mapping.
  ## 
  let valid = call_579336.validator(path, query, header, formData, body)
  let scheme = call_579336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579336.url(scheme.get, call_579336.host, call_579336.base,
                         call_579336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579336, url, valid)

proc call*(call_579337: Call_RunProjectsLocationsDomainmappingsGet_579321;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsGet
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
  var path_579338 = newJObject()
  var query_579339 = newJObject()
  add(query_579339, "key", newJString(key))
  add(query_579339, "prettyPrint", newJBool(prettyPrint))
  add(query_579339, "oauth_token", newJString(oauthToken))
  add(query_579339, "$.xgafv", newJString(Xgafv))
  add(query_579339, "alt", newJString(alt))
  add(query_579339, "uploadType", newJString(uploadType))
  add(query_579339, "quotaUser", newJString(quotaUser))
  add(path_579338, "name", newJString(name))
  add(query_579339, "callback", newJString(callback))
  add(query_579339, "fields", newJString(fields))
  add(query_579339, "access_token", newJString(accessToken))
  add(query_579339, "upload_protocol", newJString(uploadProtocol))
  result = call_579337.call(path_579338, query_579339, nil, nil, nil)

var runProjectsLocationsDomainmappingsGet* = Call_RunProjectsLocationsDomainmappingsGet_579321(
    name: "runProjectsLocationsDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsGet_579322, base: "/",
    url: url_RunProjectsLocationsDomainmappingsGet_579323, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsDelete_579361 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsDomainmappingsDelete_579363(protocol: Scheme;
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

proc validate_RunProjectsLocationsDomainmappingsDelete_579362(path: JsonNode;
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
  var valid_579364 = path.getOrDefault("name")
  valid_579364 = validateParameter(valid_579364, JString, required = true,
                                 default = nil)
  if valid_579364 != nil:
    section.add "name", valid_579364
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
  var valid_579365 = query.getOrDefault("key")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "key", valid_579365
  var valid_579366 = query.getOrDefault("prettyPrint")
  valid_579366 = validateParameter(valid_579366, JBool, required = false,
                                 default = newJBool(true))
  if valid_579366 != nil:
    section.add "prettyPrint", valid_579366
  var valid_579367 = query.getOrDefault("oauth_token")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "oauth_token", valid_579367
  var valid_579368 = query.getOrDefault("$.xgafv")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = newJString("1"))
  if valid_579368 != nil:
    section.add "$.xgafv", valid_579368
  var valid_579369 = query.getOrDefault("alt")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = newJString("json"))
  if valid_579369 != nil:
    section.add "alt", valid_579369
  var valid_579370 = query.getOrDefault("uploadType")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "uploadType", valid_579370
  var valid_579371 = query.getOrDefault("quotaUser")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "quotaUser", valid_579371
  var valid_579372 = query.getOrDefault("propagationPolicy")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "propagationPolicy", valid_579372
  var valid_579373 = query.getOrDefault("callback")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "callback", valid_579373
  var valid_579374 = query.getOrDefault("apiVersion")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "apiVersion", valid_579374
  var valid_579375 = query.getOrDefault("orphanDependents")
  valid_579375 = validateParameter(valid_579375, JBool, required = false, default = nil)
  if valid_579375 != nil:
    section.add "orphanDependents", valid_579375
  var valid_579376 = query.getOrDefault("kind")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "kind", valid_579376
  var valid_579377 = query.getOrDefault("fields")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "fields", valid_579377
  var valid_579378 = query.getOrDefault("access_token")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "access_token", valid_579378
  var valid_579379 = query.getOrDefault("upload_protocol")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "upload_protocol", valid_579379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579380: Call_RunProjectsLocationsDomainmappingsDelete_579361;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to delete a domain mapping.
  ## 
  let valid = call_579380.validator(path, query, header, formData, body)
  let scheme = call_579380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579380.url(scheme.get, call_579380.host, call_579380.base,
                         call_579380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579380, url, valid)

proc call*(call_579381: Call_RunProjectsLocationsDomainmappingsDelete_579361;
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
  var path_579382 = newJObject()
  var query_579383 = newJObject()
  add(query_579383, "key", newJString(key))
  add(query_579383, "prettyPrint", newJBool(prettyPrint))
  add(query_579383, "oauth_token", newJString(oauthToken))
  add(query_579383, "$.xgafv", newJString(Xgafv))
  add(query_579383, "alt", newJString(alt))
  add(query_579383, "uploadType", newJString(uploadType))
  add(query_579383, "quotaUser", newJString(quotaUser))
  add(path_579382, "name", newJString(name))
  add(query_579383, "propagationPolicy", newJString(propagationPolicy))
  add(query_579383, "callback", newJString(callback))
  add(query_579383, "apiVersion", newJString(apiVersion))
  add(query_579383, "orphanDependents", newJBool(orphanDependents))
  add(query_579383, "kind", newJString(kind))
  add(query_579383, "fields", newJString(fields))
  add(query_579383, "access_token", newJString(accessToken))
  add(query_579383, "upload_protocol", newJString(uploadProtocol))
  result = call_579381.call(path_579382, query_579383, nil, nil, nil)

var runProjectsLocationsDomainmappingsDelete* = Call_RunProjectsLocationsDomainmappingsDelete_579361(
    name: "runProjectsLocationsDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsDelete_579362,
    base: "/", url: url_RunProjectsLocationsDomainmappingsDelete_579363,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsList_579384 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsList_579386(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsList_579385(path: JsonNode; query: JsonNode;
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
  var valid_579387 = path.getOrDefault("name")
  valid_579387 = validateParameter(valid_579387, JString, required = true,
                                 default = nil)
  if valid_579387 != nil:
    section.add "name", valid_579387
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
  var valid_579388 = query.getOrDefault("key")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "key", valid_579388
  var valid_579389 = query.getOrDefault("prettyPrint")
  valid_579389 = validateParameter(valid_579389, JBool, required = false,
                                 default = newJBool(true))
  if valid_579389 != nil:
    section.add "prettyPrint", valid_579389
  var valid_579390 = query.getOrDefault("oauth_token")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "oauth_token", valid_579390
  var valid_579391 = query.getOrDefault("$.xgafv")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = newJString("1"))
  if valid_579391 != nil:
    section.add "$.xgafv", valid_579391
  var valid_579392 = query.getOrDefault("pageSize")
  valid_579392 = validateParameter(valid_579392, JInt, required = false, default = nil)
  if valid_579392 != nil:
    section.add "pageSize", valid_579392
  var valid_579393 = query.getOrDefault("alt")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = newJString("json"))
  if valid_579393 != nil:
    section.add "alt", valid_579393
  var valid_579394 = query.getOrDefault("uploadType")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "uploadType", valid_579394
  var valid_579395 = query.getOrDefault("quotaUser")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "quotaUser", valid_579395
  var valid_579396 = query.getOrDefault("filter")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "filter", valid_579396
  var valid_579397 = query.getOrDefault("pageToken")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "pageToken", valid_579397
  var valid_579398 = query.getOrDefault("callback")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = nil)
  if valid_579398 != nil:
    section.add "callback", valid_579398
  var valid_579399 = query.getOrDefault("fields")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "fields", valid_579399
  var valid_579400 = query.getOrDefault("access_token")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "access_token", valid_579400
  var valid_579401 = query.getOrDefault("upload_protocol")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "upload_protocol", valid_579401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579402: Call_RunProjectsLocationsList_579384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_579402.validator(path, query, header, formData, body)
  let scheme = call_579402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579402.url(scheme.get, call_579402.host, call_579402.base,
                         call_579402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579402, url, valid)

proc call*(call_579403: Call_RunProjectsLocationsList_579384; name: string;
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
  var path_579404 = newJObject()
  var query_579405 = newJObject()
  add(query_579405, "key", newJString(key))
  add(query_579405, "prettyPrint", newJBool(prettyPrint))
  add(query_579405, "oauth_token", newJString(oauthToken))
  add(query_579405, "$.xgafv", newJString(Xgafv))
  add(query_579405, "pageSize", newJInt(pageSize))
  add(query_579405, "alt", newJString(alt))
  add(query_579405, "uploadType", newJString(uploadType))
  add(query_579405, "quotaUser", newJString(quotaUser))
  add(path_579404, "name", newJString(name))
  add(query_579405, "filter", newJString(filter))
  add(query_579405, "pageToken", newJString(pageToken))
  add(query_579405, "callback", newJString(callback))
  add(query_579405, "fields", newJString(fields))
  add(query_579405, "access_token", newJString(accessToken))
  add(query_579405, "upload_protocol", newJString(uploadProtocol))
  result = call_579403.call(path_579404, query_579405, nil, nil, nil)

var runProjectsLocationsList* = Call_RunProjectsLocationsList_579384(
    name: "runProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{name}/locations",
    validator: validate_RunProjectsLocationsList_579385, base: "/",
    url: url_RunProjectsLocationsList_579386, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAuthorizeddomainsList_579406 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsAuthorizeddomainsList_579408(protocol: Scheme;
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

proc validate_RunProjectsLocationsAuthorizeddomainsList_579407(path: JsonNode;
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
  var valid_579409 = path.getOrDefault("parent")
  valid_579409 = validateParameter(valid_579409, JString, required = true,
                                 default = nil)
  if valid_579409 != nil:
    section.add "parent", valid_579409
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
  var valid_579410 = query.getOrDefault("key")
  valid_579410 = validateParameter(valid_579410, JString, required = false,
                                 default = nil)
  if valid_579410 != nil:
    section.add "key", valid_579410
  var valid_579411 = query.getOrDefault("prettyPrint")
  valid_579411 = validateParameter(valid_579411, JBool, required = false,
                                 default = newJBool(true))
  if valid_579411 != nil:
    section.add "prettyPrint", valid_579411
  var valid_579412 = query.getOrDefault("oauth_token")
  valid_579412 = validateParameter(valid_579412, JString, required = false,
                                 default = nil)
  if valid_579412 != nil:
    section.add "oauth_token", valid_579412
  var valid_579413 = query.getOrDefault("$.xgafv")
  valid_579413 = validateParameter(valid_579413, JString, required = false,
                                 default = newJString("1"))
  if valid_579413 != nil:
    section.add "$.xgafv", valid_579413
  var valid_579414 = query.getOrDefault("pageSize")
  valid_579414 = validateParameter(valid_579414, JInt, required = false, default = nil)
  if valid_579414 != nil:
    section.add "pageSize", valid_579414
  var valid_579415 = query.getOrDefault("alt")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = newJString("json"))
  if valid_579415 != nil:
    section.add "alt", valid_579415
  var valid_579416 = query.getOrDefault("uploadType")
  valid_579416 = validateParameter(valid_579416, JString, required = false,
                                 default = nil)
  if valid_579416 != nil:
    section.add "uploadType", valid_579416
  var valid_579417 = query.getOrDefault("quotaUser")
  valid_579417 = validateParameter(valid_579417, JString, required = false,
                                 default = nil)
  if valid_579417 != nil:
    section.add "quotaUser", valid_579417
  var valid_579418 = query.getOrDefault("pageToken")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = nil)
  if valid_579418 != nil:
    section.add "pageToken", valid_579418
  var valid_579419 = query.getOrDefault("callback")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "callback", valid_579419
  var valid_579420 = query.getOrDefault("fields")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "fields", valid_579420
  var valid_579421 = query.getOrDefault("access_token")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "access_token", valid_579421
  var valid_579422 = query.getOrDefault("upload_protocol")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "upload_protocol", valid_579422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579423: Call_RunProjectsLocationsAuthorizeddomainsList_579406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RPC to list authorized domains.
  ## 
  let valid = call_579423.validator(path, query, header, formData, body)
  let scheme = call_579423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579423.url(scheme.get, call_579423.host, call_579423.base,
                         call_579423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579423, url, valid)

proc call*(call_579424: Call_RunProjectsLocationsAuthorizeddomainsList_579406;
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
  var path_579425 = newJObject()
  var query_579426 = newJObject()
  add(query_579426, "key", newJString(key))
  add(query_579426, "prettyPrint", newJBool(prettyPrint))
  add(query_579426, "oauth_token", newJString(oauthToken))
  add(query_579426, "$.xgafv", newJString(Xgafv))
  add(query_579426, "pageSize", newJInt(pageSize))
  add(query_579426, "alt", newJString(alt))
  add(query_579426, "uploadType", newJString(uploadType))
  add(query_579426, "quotaUser", newJString(quotaUser))
  add(query_579426, "pageToken", newJString(pageToken))
  add(query_579426, "callback", newJString(callback))
  add(path_579425, "parent", newJString(parent))
  add(query_579426, "fields", newJString(fields))
  add(query_579426, "access_token", newJString(accessToken))
  add(query_579426, "upload_protocol", newJString(uploadProtocol))
  result = call_579424.call(path_579425, query_579426, nil, nil, nil)

var runProjectsLocationsAuthorizeddomainsList* = Call_RunProjectsLocationsAuthorizeddomainsList_579406(
    name: "runProjectsLocationsAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/authorizeddomains",
    validator: validate_RunProjectsLocationsAuthorizeddomainsList_579407,
    base: "/", url: url_RunProjectsLocationsAuthorizeddomainsList_579408,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsList_579427 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsConfigurationsList_579429(protocol: Scheme;
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

proc validate_RunProjectsLocationsConfigurationsList_579428(path: JsonNode;
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
  var valid_579430 = path.getOrDefault("parent")
  valid_579430 = validateParameter(valid_579430, JString, required = true,
                                 default = nil)
  if valid_579430 != nil:
    section.add "parent", valid_579430
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
  var valid_579431 = query.getOrDefault("key")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = nil)
  if valid_579431 != nil:
    section.add "key", valid_579431
  var valid_579432 = query.getOrDefault("includeUninitialized")
  valid_579432 = validateParameter(valid_579432, JBool, required = false, default = nil)
  if valid_579432 != nil:
    section.add "includeUninitialized", valid_579432
  var valid_579433 = query.getOrDefault("prettyPrint")
  valid_579433 = validateParameter(valid_579433, JBool, required = false,
                                 default = newJBool(true))
  if valid_579433 != nil:
    section.add "prettyPrint", valid_579433
  var valid_579434 = query.getOrDefault("oauth_token")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = nil)
  if valid_579434 != nil:
    section.add "oauth_token", valid_579434
  var valid_579435 = query.getOrDefault("fieldSelector")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = nil)
  if valid_579435 != nil:
    section.add "fieldSelector", valid_579435
  var valid_579436 = query.getOrDefault("labelSelector")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "labelSelector", valid_579436
  var valid_579437 = query.getOrDefault("$.xgafv")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = newJString("1"))
  if valid_579437 != nil:
    section.add "$.xgafv", valid_579437
  var valid_579438 = query.getOrDefault("limit")
  valid_579438 = validateParameter(valid_579438, JInt, required = false, default = nil)
  if valid_579438 != nil:
    section.add "limit", valid_579438
  var valid_579439 = query.getOrDefault("alt")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = newJString("json"))
  if valid_579439 != nil:
    section.add "alt", valid_579439
  var valid_579440 = query.getOrDefault("uploadType")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = nil)
  if valid_579440 != nil:
    section.add "uploadType", valid_579440
  var valid_579441 = query.getOrDefault("quotaUser")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "quotaUser", valid_579441
  var valid_579442 = query.getOrDefault("watch")
  valid_579442 = validateParameter(valid_579442, JBool, required = false, default = nil)
  if valid_579442 != nil:
    section.add "watch", valid_579442
  var valid_579443 = query.getOrDefault("callback")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "callback", valid_579443
  var valid_579444 = query.getOrDefault("resourceVersion")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "resourceVersion", valid_579444
  var valid_579445 = query.getOrDefault("fields")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "fields", valid_579445
  var valid_579446 = query.getOrDefault("access_token")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "access_token", valid_579446
  var valid_579447 = query.getOrDefault("upload_protocol")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "upload_protocol", valid_579447
  var valid_579448 = query.getOrDefault("continue")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "continue", valid_579448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579449: Call_RunProjectsLocationsConfigurationsList_579427;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list configurations.
  ## 
  let valid = call_579449.validator(path, query, header, formData, body)
  let scheme = call_579449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579449.url(scheme.get, call_579449.host, call_579449.base,
                         call_579449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579449, url, valid)

proc call*(call_579450: Call_RunProjectsLocationsConfigurationsList_579427;
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
  var path_579451 = newJObject()
  var query_579452 = newJObject()
  add(query_579452, "key", newJString(key))
  add(query_579452, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579452, "prettyPrint", newJBool(prettyPrint))
  add(query_579452, "oauth_token", newJString(oauthToken))
  add(query_579452, "fieldSelector", newJString(fieldSelector))
  add(query_579452, "labelSelector", newJString(labelSelector))
  add(query_579452, "$.xgafv", newJString(Xgafv))
  add(query_579452, "limit", newJInt(limit))
  add(query_579452, "alt", newJString(alt))
  add(query_579452, "uploadType", newJString(uploadType))
  add(query_579452, "quotaUser", newJString(quotaUser))
  add(query_579452, "watch", newJBool(watch))
  add(query_579452, "callback", newJString(callback))
  add(path_579451, "parent", newJString(parent))
  add(query_579452, "resourceVersion", newJString(resourceVersion))
  add(query_579452, "fields", newJString(fields))
  add(query_579452, "access_token", newJString(accessToken))
  add(query_579452, "upload_protocol", newJString(uploadProtocol))
  add(query_579452, "continue", newJString(`continue`))
  result = call_579450.call(path_579451, query_579452, nil, nil, nil)

var runProjectsLocationsConfigurationsList* = Call_RunProjectsLocationsConfigurationsList_579427(
    name: "runProjectsLocationsConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsList_579428, base: "/",
    url: url_RunProjectsLocationsConfigurationsList_579429,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsCreate_579479 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsDomainmappingsCreate_579481(protocol: Scheme;
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

proc validate_RunProjectsLocationsDomainmappingsCreate_579480(path: JsonNode;
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
  var valid_579482 = path.getOrDefault("parent")
  valid_579482 = validateParameter(valid_579482, JString, required = true,
                                 default = nil)
  if valid_579482 != nil:
    section.add "parent", valid_579482
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
  var valid_579483 = query.getOrDefault("key")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "key", valid_579483
  var valid_579484 = query.getOrDefault("prettyPrint")
  valid_579484 = validateParameter(valid_579484, JBool, required = false,
                                 default = newJBool(true))
  if valid_579484 != nil:
    section.add "prettyPrint", valid_579484
  var valid_579485 = query.getOrDefault("oauth_token")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = nil)
  if valid_579485 != nil:
    section.add "oauth_token", valid_579485
  var valid_579486 = query.getOrDefault("$.xgafv")
  valid_579486 = validateParameter(valid_579486, JString, required = false,
                                 default = newJString("1"))
  if valid_579486 != nil:
    section.add "$.xgafv", valid_579486
  var valid_579487 = query.getOrDefault("alt")
  valid_579487 = validateParameter(valid_579487, JString, required = false,
                                 default = newJString("json"))
  if valid_579487 != nil:
    section.add "alt", valid_579487
  var valid_579488 = query.getOrDefault("uploadType")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = nil)
  if valid_579488 != nil:
    section.add "uploadType", valid_579488
  var valid_579489 = query.getOrDefault("quotaUser")
  valid_579489 = validateParameter(valid_579489, JString, required = false,
                                 default = nil)
  if valid_579489 != nil:
    section.add "quotaUser", valid_579489
  var valid_579490 = query.getOrDefault("callback")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = nil)
  if valid_579490 != nil:
    section.add "callback", valid_579490
  var valid_579491 = query.getOrDefault("fields")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = nil)
  if valid_579491 != nil:
    section.add "fields", valid_579491
  var valid_579492 = query.getOrDefault("access_token")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = nil)
  if valid_579492 != nil:
    section.add "access_token", valid_579492
  var valid_579493 = query.getOrDefault("upload_protocol")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = nil)
  if valid_579493 != nil:
    section.add "upload_protocol", valid_579493
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

proc call*(call_579495: Call_RunProjectsLocationsDomainmappingsCreate_579479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new domain mapping.
  ## 
  let valid = call_579495.validator(path, query, header, formData, body)
  let scheme = call_579495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579495.url(scheme.get, call_579495.host, call_579495.base,
                         call_579495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579495, url, valid)

proc call*(call_579496: Call_RunProjectsLocationsDomainmappingsCreate_579479;
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
  var path_579497 = newJObject()
  var query_579498 = newJObject()
  var body_579499 = newJObject()
  add(query_579498, "key", newJString(key))
  add(query_579498, "prettyPrint", newJBool(prettyPrint))
  add(query_579498, "oauth_token", newJString(oauthToken))
  add(query_579498, "$.xgafv", newJString(Xgafv))
  add(query_579498, "alt", newJString(alt))
  add(query_579498, "uploadType", newJString(uploadType))
  add(query_579498, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579499 = body
  add(query_579498, "callback", newJString(callback))
  add(path_579497, "parent", newJString(parent))
  add(query_579498, "fields", newJString(fields))
  add(query_579498, "access_token", newJString(accessToken))
  add(query_579498, "upload_protocol", newJString(uploadProtocol))
  result = call_579496.call(path_579497, query_579498, nil, nil, body_579499)

var runProjectsLocationsDomainmappingsCreate* = Call_RunProjectsLocationsDomainmappingsCreate_579479(
    name: "runProjectsLocationsDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsCreate_579480,
    base: "/", url: url_RunProjectsLocationsDomainmappingsCreate_579481,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsList_579453 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsDomainmappingsList_579455(protocol: Scheme;
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

proc validate_RunProjectsLocationsDomainmappingsList_579454(path: JsonNode;
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
  var valid_579456 = path.getOrDefault("parent")
  valid_579456 = validateParameter(valid_579456, JString, required = true,
                                 default = nil)
  if valid_579456 != nil:
    section.add "parent", valid_579456
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
  var valid_579457 = query.getOrDefault("key")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = nil)
  if valid_579457 != nil:
    section.add "key", valid_579457
  var valid_579458 = query.getOrDefault("includeUninitialized")
  valid_579458 = validateParameter(valid_579458, JBool, required = false, default = nil)
  if valid_579458 != nil:
    section.add "includeUninitialized", valid_579458
  var valid_579459 = query.getOrDefault("prettyPrint")
  valid_579459 = validateParameter(valid_579459, JBool, required = false,
                                 default = newJBool(true))
  if valid_579459 != nil:
    section.add "prettyPrint", valid_579459
  var valid_579460 = query.getOrDefault("oauth_token")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "oauth_token", valid_579460
  var valid_579461 = query.getOrDefault("fieldSelector")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "fieldSelector", valid_579461
  var valid_579462 = query.getOrDefault("labelSelector")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "labelSelector", valid_579462
  var valid_579463 = query.getOrDefault("$.xgafv")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = newJString("1"))
  if valid_579463 != nil:
    section.add "$.xgafv", valid_579463
  var valid_579464 = query.getOrDefault("limit")
  valid_579464 = validateParameter(valid_579464, JInt, required = false, default = nil)
  if valid_579464 != nil:
    section.add "limit", valid_579464
  var valid_579465 = query.getOrDefault("alt")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = newJString("json"))
  if valid_579465 != nil:
    section.add "alt", valid_579465
  var valid_579466 = query.getOrDefault("uploadType")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "uploadType", valid_579466
  var valid_579467 = query.getOrDefault("quotaUser")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "quotaUser", valid_579467
  var valid_579468 = query.getOrDefault("watch")
  valid_579468 = validateParameter(valid_579468, JBool, required = false, default = nil)
  if valid_579468 != nil:
    section.add "watch", valid_579468
  var valid_579469 = query.getOrDefault("callback")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = nil)
  if valid_579469 != nil:
    section.add "callback", valid_579469
  var valid_579470 = query.getOrDefault("resourceVersion")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "resourceVersion", valid_579470
  var valid_579471 = query.getOrDefault("fields")
  valid_579471 = validateParameter(valid_579471, JString, required = false,
                                 default = nil)
  if valid_579471 != nil:
    section.add "fields", valid_579471
  var valid_579472 = query.getOrDefault("access_token")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = nil)
  if valid_579472 != nil:
    section.add "access_token", valid_579472
  var valid_579473 = query.getOrDefault("upload_protocol")
  valid_579473 = validateParameter(valid_579473, JString, required = false,
                                 default = nil)
  if valid_579473 != nil:
    section.add "upload_protocol", valid_579473
  var valid_579474 = query.getOrDefault("continue")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = nil)
  if valid_579474 != nil:
    section.add "continue", valid_579474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579475: Call_RunProjectsLocationsDomainmappingsList_579453;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list domain mappings.
  ## 
  let valid = call_579475.validator(path, query, header, formData, body)
  let scheme = call_579475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579475.url(scheme.get, call_579475.host, call_579475.base,
                         call_579475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579475, url, valid)

proc call*(call_579476: Call_RunProjectsLocationsDomainmappingsList_579453;
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
  var path_579477 = newJObject()
  var query_579478 = newJObject()
  add(query_579478, "key", newJString(key))
  add(query_579478, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579478, "prettyPrint", newJBool(prettyPrint))
  add(query_579478, "oauth_token", newJString(oauthToken))
  add(query_579478, "fieldSelector", newJString(fieldSelector))
  add(query_579478, "labelSelector", newJString(labelSelector))
  add(query_579478, "$.xgafv", newJString(Xgafv))
  add(query_579478, "limit", newJInt(limit))
  add(query_579478, "alt", newJString(alt))
  add(query_579478, "uploadType", newJString(uploadType))
  add(query_579478, "quotaUser", newJString(quotaUser))
  add(query_579478, "watch", newJBool(watch))
  add(query_579478, "callback", newJString(callback))
  add(path_579477, "parent", newJString(parent))
  add(query_579478, "resourceVersion", newJString(resourceVersion))
  add(query_579478, "fields", newJString(fields))
  add(query_579478, "access_token", newJString(accessToken))
  add(query_579478, "upload_protocol", newJString(uploadProtocol))
  add(query_579478, "continue", newJString(`continue`))
  result = call_579476.call(path_579477, query_579478, nil, nil, nil)

var runProjectsLocationsDomainmappingsList* = Call_RunProjectsLocationsDomainmappingsList_579453(
    name: "runProjectsLocationsDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsList_579454, base: "/",
    url: url_RunProjectsLocationsDomainmappingsList_579455,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsEventtypesList_579500 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsEventtypesList_579502(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsEventtypesList_579501(path: JsonNode;
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
  var valid_579503 = path.getOrDefault("parent")
  valid_579503 = validateParameter(valid_579503, JString, required = true,
                                 default = nil)
  if valid_579503 != nil:
    section.add "parent", valid_579503
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
  var valid_579504 = query.getOrDefault("key")
  valid_579504 = validateParameter(valid_579504, JString, required = false,
                                 default = nil)
  if valid_579504 != nil:
    section.add "key", valid_579504
  var valid_579505 = query.getOrDefault("includeUninitialized")
  valid_579505 = validateParameter(valid_579505, JBool, required = false, default = nil)
  if valid_579505 != nil:
    section.add "includeUninitialized", valid_579505
  var valid_579506 = query.getOrDefault("prettyPrint")
  valid_579506 = validateParameter(valid_579506, JBool, required = false,
                                 default = newJBool(true))
  if valid_579506 != nil:
    section.add "prettyPrint", valid_579506
  var valid_579507 = query.getOrDefault("oauth_token")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "oauth_token", valid_579507
  var valid_579508 = query.getOrDefault("fieldSelector")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "fieldSelector", valid_579508
  var valid_579509 = query.getOrDefault("labelSelector")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "labelSelector", valid_579509
  var valid_579510 = query.getOrDefault("$.xgafv")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = newJString("1"))
  if valid_579510 != nil:
    section.add "$.xgafv", valid_579510
  var valid_579511 = query.getOrDefault("limit")
  valid_579511 = validateParameter(valid_579511, JInt, required = false, default = nil)
  if valid_579511 != nil:
    section.add "limit", valid_579511
  var valid_579512 = query.getOrDefault("alt")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = newJString("json"))
  if valid_579512 != nil:
    section.add "alt", valid_579512
  var valid_579513 = query.getOrDefault("uploadType")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "uploadType", valid_579513
  var valid_579514 = query.getOrDefault("quotaUser")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "quotaUser", valid_579514
  var valid_579515 = query.getOrDefault("watch")
  valid_579515 = validateParameter(valid_579515, JBool, required = false, default = nil)
  if valid_579515 != nil:
    section.add "watch", valid_579515
  var valid_579516 = query.getOrDefault("callback")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "callback", valid_579516
  var valid_579517 = query.getOrDefault("resourceVersion")
  valid_579517 = validateParameter(valid_579517, JString, required = false,
                                 default = nil)
  if valid_579517 != nil:
    section.add "resourceVersion", valid_579517
  var valid_579518 = query.getOrDefault("fields")
  valid_579518 = validateParameter(valid_579518, JString, required = false,
                                 default = nil)
  if valid_579518 != nil:
    section.add "fields", valid_579518
  var valid_579519 = query.getOrDefault("access_token")
  valid_579519 = validateParameter(valid_579519, JString, required = false,
                                 default = nil)
  if valid_579519 != nil:
    section.add "access_token", valid_579519
  var valid_579520 = query.getOrDefault("upload_protocol")
  valid_579520 = validateParameter(valid_579520, JString, required = false,
                                 default = nil)
  if valid_579520 != nil:
    section.add "upload_protocol", valid_579520
  var valid_579521 = query.getOrDefault("continue")
  valid_579521 = validateParameter(valid_579521, JString, required = false,
                                 default = nil)
  if valid_579521 != nil:
    section.add "continue", valid_579521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579522: Call_RunProjectsLocationsEventtypesList_579500;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list EventTypes.
  ## 
  let valid = call_579522.validator(path, query, header, formData, body)
  let scheme = call_579522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579522.url(scheme.get, call_579522.host, call_579522.base,
                         call_579522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579522, url, valid)

proc call*(call_579523: Call_RunProjectsLocationsEventtypesList_579500;
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
  var path_579524 = newJObject()
  var query_579525 = newJObject()
  add(query_579525, "key", newJString(key))
  add(query_579525, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579525, "prettyPrint", newJBool(prettyPrint))
  add(query_579525, "oauth_token", newJString(oauthToken))
  add(query_579525, "fieldSelector", newJString(fieldSelector))
  add(query_579525, "labelSelector", newJString(labelSelector))
  add(query_579525, "$.xgafv", newJString(Xgafv))
  add(query_579525, "limit", newJInt(limit))
  add(query_579525, "alt", newJString(alt))
  add(query_579525, "uploadType", newJString(uploadType))
  add(query_579525, "quotaUser", newJString(quotaUser))
  add(query_579525, "watch", newJBool(watch))
  add(query_579525, "callback", newJString(callback))
  add(path_579524, "parent", newJString(parent))
  add(query_579525, "resourceVersion", newJString(resourceVersion))
  add(query_579525, "fields", newJString(fields))
  add(query_579525, "access_token", newJString(accessToken))
  add(query_579525, "upload_protocol", newJString(uploadProtocol))
  add(query_579525, "continue", newJString(`continue`))
  result = call_579523.call(path_579524, query_579525, nil, nil, nil)

var runProjectsLocationsEventtypesList* = Call_RunProjectsLocationsEventtypesList_579500(
    name: "runProjectsLocationsEventtypesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/eventtypes",
    validator: validate_RunProjectsLocationsEventtypesList_579501, base: "/",
    url: url_RunProjectsLocationsEventtypesList_579502, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRevisionsList_579526 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsRevisionsList_579528(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsRevisionsList_579527(path: JsonNode;
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
  var valid_579529 = path.getOrDefault("parent")
  valid_579529 = validateParameter(valid_579529, JString, required = true,
                                 default = nil)
  if valid_579529 != nil:
    section.add "parent", valid_579529
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
  var valid_579530 = query.getOrDefault("key")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "key", valid_579530
  var valid_579531 = query.getOrDefault("includeUninitialized")
  valid_579531 = validateParameter(valid_579531, JBool, required = false, default = nil)
  if valid_579531 != nil:
    section.add "includeUninitialized", valid_579531
  var valid_579532 = query.getOrDefault("prettyPrint")
  valid_579532 = validateParameter(valid_579532, JBool, required = false,
                                 default = newJBool(true))
  if valid_579532 != nil:
    section.add "prettyPrint", valid_579532
  var valid_579533 = query.getOrDefault("oauth_token")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "oauth_token", valid_579533
  var valid_579534 = query.getOrDefault("fieldSelector")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "fieldSelector", valid_579534
  var valid_579535 = query.getOrDefault("labelSelector")
  valid_579535 = validateParameter(valid_579535, JString, required = false,
                                 default = nil)
  if valid_579535 != nil:
    section.add "labelSelector", valid_579535
  var valid_579536 = query.getOrDefault("$.xgafv")
  valid_579536 = validateParameter(valid_579536, JString, required = false,
                                 default = newJString("1"))
  if valid_579536 != nil:
    section.add "$.xgafv", valid_579536
  var valid_579537 = query.getOrDefault("limit")
  valid_579537 = validateParameter(valid_579537, JInt, required = false, default = nil)
  if valid_579537 != nil:
    section.add "limit", valid_579537
  var valid_579538 = query.getOrDefault("alt")
  valid_579538 = validateParameter(valid_579538, JString, required = false,
                                 default = newJString("json"))
  if valid_579538 != nil:
    section.add "alt", valid_579538
  var valid_579539 = query.getOrDefault("uploadType")
  valid_579539 = validateParameter(valid_579539, JString, required = false,
                                 default = nil)
  if valid_579539 != nil:
    section.add "uploadType", valid_579539
  var valid_579540 = query.getOrDefault("quotaUser")
  valid_579540 = validateParameter(valid_579540, JString, required = false,
                                 default = nil)
  if valid_579540 != nil:
    section.add "quotaUser", valid_579540
  var valid_579541 = query.getOrDefault("watch")
  valid_579541 = validateParameter(valid_579541, JBool, required = false, default = nil)
  if valid_579541 != nil:
    section.add "watch", valid_579541
  var valid_579542 = query.getOrDefault("callback")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = nil)
  if valid_579542 != nil:
    section.add "callback", valid_579542
  var valid_579543 = query.getOrDefault("resourceVersion")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "resourceVersion", valid_579543
  var valid_579544 = query.getOrDefault("fields")
  valid_579544 = validateParameter(valid_579544, JString, required = false,
                                 default = nil)
  if valid_579544 != nil:
    section.add "fields", valid_579544
  var valid_579545 = query.getOrDefault("access_token")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = nil)
  if valid_579545 != nil:
    section.add "access_token", valid_579545
  var valid_579546 = query.getOrDefault("upload_protocol")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = nil)
  if valid_579546 != nil:
    section.add "upload_protocol", valid_579546
  var valid_579547 = query.getOrDefault("continue")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "continue", valid_579547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579548: Call_RunProjectsLocationsRevisionsList_579526;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list revisions.
  ## 
  let valid = call_579548.validator(path, query, header, formData, body)
  let scheme = call_579548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579548.url(scheme.get, call_579548.host, call_579548.base,
                         call_579548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579548, url, valid)

proc call*(call_579549: Call_RunProjectsLocationsRevisionsList_579526;
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
  var path_579550 = newJObject()
  var query_579551 = newJObject()
  add(query_579551, "key", newJString(key))
  add(query_579551, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579551, "prettyPrint", newJBool(prettyPrint))
  add(query_579551, "oauth_token", newJString(oauthToken))
  add(query_579551, "fieldSelector", newJString(fieldSelector))
  add(query_579551, "labelSelector", newJString(labelSelector))
  add(query_579551, "$.xgafv", newJString(Xgafv))
  add(query_579551, "limit", newJInt(limit))
  add(query_579551, "alt", newJString(alt))
  add(query_579551, "uploadType", newJString(uploadType))
  add(query_579551, "quotaUser", newJString(quotaUser))
  add(query_579551, "watch", newJBool(watch))
  add(query_579551, "callback", newJString(callback))
  add(path_579550, "parent", newJString(parent))
  add(query_579551, "resourceVersion", newJString(resourceVersion))
  add(query_579551, "fields", newJString(fields))
  add(query_579551, "access_token", newJString(accessToken))
  add(query_579551, "upload_protocol", newJString(uploadProtocol))
  add(query_579551, "continue", newJString(`continue`))
  result = call_579549.call(path_579550, query_579551, nil, nil, nil)

var runProjectsLocationsRevisionsList* = Call_RunProjectsLocationsRevisionsList_579526(
    name: "runProjectsLocationsRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/revisions",
    validator: validate_RunProjectsLocationsRevisionsList_579527, base: "/",
    url: url_RunProjectsLocationsRevisionsList_579528, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesList_579552 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsRoutesList_579554(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsRoutesList_579553(path: JsonNode;
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
  var valid_579555 = path.getOrDefault("parent")
  valid_579555 = validateParameter(valid_579555, JString, required = true,
                                 default = nil)
  if valid_579555 != nil:
    section.add "parent", valid_579555
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
  var valid_579556 = query.getOrDefault("key")
  valid_579556 = validateParameter(valid_579556, JString, required = false,
                                 default = nil)
  if valid_579556 != nil:
    section.add "key", valid_579556
  var valid_579557 = query.getOrDefault("includeUninitialized")
  valid_579557 = validateParameter(valid_579557, JBool, required = false, default = nil)
  if valid_579557 != nil:
    section.add "includeUninitialized", valid_579557
  var valid_579558 = query.getOrDefault("prettyPrint")
  valid_579558 = validateParameter(valid_579558, JBool, required = false,
                                 default = newJBool(true))
  if valid_579558 != nil:
    section.add "prettyPrint", valid_579558
  var valid_579559 = query.getOrDefault("oauth_token")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = nil)
  if valid_579559 != nil:
    section.add "oauth_token", valid_579559
  var valid_579560 = query.getOrDefault("fieldSelector")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = nil)
  if valid_579560 != nil:
    section.add "fieldSelector", valid_579560
  var valid_579561 = query.getOrDefault("labelSelector")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "labelSelector", valid_579561
  var valid_579562 = query.getOrDefault("$.xgafv")
  valid_579562 = validateParameter(valid_579562, JString, required = false,
                                 default = newJString("1"))
  if valid_579562 != nil:
    section.add "$.xgafv", valid_579562
  var valid_579563 = query.getOrDefault("limit")
  valid_579563 = validateParameter(valid_579563, JInt, required = false, default = nil)
  if valid_579563 != nil:
    section.add "limit", valid_579563
  var valid_579564 = query.getOrDefault("alt")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = newJString("json"))
  if valid_579564 != nil:
    section.add "alt", valid_579564
  var valid_579565 = query.getOrDefault("uploadType")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = nil)
  if valid_579565 != nil:
    section.add "uploadType", valid_579565
  var valid_579566 = query.getOrDefault("quotaUser")
  valid_579566 = validateParameter(valid_579566, JString, required = false,
                                 default = nil)
  if valid_579566 != nil:
    section.add "quotaUser", valid_579566
  var valid_579567 = query.getOrDefault("watch")
  valid_579567 = validateParameter(valid_579567, JBool, required = false, default = nil)
  if valid_579567 != nil:
    section.add "watch", valid_579567
  var valid_579568 = query.getOrDefault("callback")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = nil)
  if valid_579568 != nil:
    section.add "callback", valid_579568
  var valid_579569 = query.getOrDefault("resourceVersion")
  valid_579569 = validateParameter(valid_579569, JString, required = false,
                                 default = nil)
  if valid_579569 != nil:
    section.add "resourceVersion", valid_579569
  var valid_579570 = query.getOrDefault("fields")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = nil)
  if valid_579570 != nil:
    section.add "fields", valid_579570
  var valid_579571 = query.getOrDefault("access_token")
  valid_579571 = validateParameter(valid_579571, JString, required = false,
                                 default = nil)
  if valid_579571 != nil:
    section.add "access_token", valid_579571
  var valid_579572 = query.getOrDefault("upload_protocol")
  valid_579572 = validateParameter(valid_579572, JString, required = false,
                                 default = nil)
  if valid_579572 != nil:
    section.add "upload_protocol", valid_579572
  var valid_579573 = query.getOrDefault("continue")
  valid_579573 = validateParameter(valid_579573, JString, required = false,
                                 default = nil)
  if valid_579573 != nil:
    section.add "continue", valid_579573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579574: Call_RunProjectsLocationsRoutesList_579552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list routes.
  ## 
  let valid = call_579574.validator(path, query, header, formData, body)
  let scheme = call_579574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579574.url(scheme.get, call_579574.host, call_579574.base,
                         call_579574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579574, url, valid)

proc call*(call_579575: Call_RunProjectsLocationsRoutesList_579552; parent: string;
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
  var path_579576 = newJObject()
  var query_579577 = newJObject()
  add(query_579577, "key", newJString(key))
  add(query_579577, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579577, "prettyPrint", newJBool(prettyPrint))
  add(query_579577, "oauth_token", newJString(oauthToken))
  add(query_579577, "fieldSelector", newJString(fieldSelector))
  add(query_579577, "labelSelector", newJString(labelSelector))
  add(query_579577, "$.xgafv", newJString(Xgafv))
  add(query_579577, "limit", newJInt(limit))
  add(query_579577, "alt", newJString(alt))
  add(query_579577, "uploadType", newJString(uploadType))
  add(query_579577, "quotaUser", newJString(quotaUser))
  add(query_579577, "watch", newJBool(watch))
  add(query_579577, "callback", newJString(callback))
  add(path_579576, "parent", newJString(parent))
  add(query_579577, "resourceVersion", newJString(resourceVersion))
  add(query_579577, "fields", newJString(fields))
  add(query_579577, "access_token", newJString(accessToken))
  add(query_579577, "upload_protocol", newJString(uploadProtocol))
  add(query_579577, "continue", newJString(`continue`))
  result = call_579575.call(path_579576, query_579577, nil, nil, nil)

var runProjectsLocationsRoutesList* = Call_RunProjectsLocationsRoutesList_579552(
    name: "runProjectsLocationsRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesList_579553, base: "/",
    url: url_RunProjectsLocationsRoutesList_579554, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesCreate_579604 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesCreate_579606(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsServicesCreate_579605(path: JsonNode;
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
  var valid_579607 = path.getOrDefault("parent")
  valid_579607 = validateParameter(valid_579607, JString, required = true,
                                 default = nil)
  if valid_579607 != nil:
    section.add "parent", valid_579607
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
  var valid_579608 = query.getOrDefault("key")
  valid_579608 = validateParameter(valid_579608, JString, required = false,
                                 default = nil)
  if valid_579608 != nil:
    section.add "key", valid_579608
  var valid_579609 = query.getOrDefault("prettyPrint")
  valid_579609 = validateParameter(valid_579609, JBool, required = false,
                                 default = newJBool(true))
  if valid_579609 != nil:
    section.add "prettyPrint", valid_579609
  var valid_579610 = query.getOrDefault("oauth_token")
  valid_579610 = validateParameter(valid_579610, JString, required = false,
                                 default = nil)
  if valid_579610 != nil:
    section.add "oauth_token", valid_579610
  var valid_579611 = query.getOrDefault("$.xgafv")
  valid_579611 = validateParameter(valid_579611, JString, required = false,
                                 default = newJString("1"))
  if valid_579611 != nil:
    section.add "$.xgafv", valid_579611
  var valid_579612 = query.getOrDefault("alt")
  valid_579612 = validateParameter(valid_579612, JString, required = false,
                                 default = newJString("json"))
  if valid_579612 != nil:
    section.add "alt", valid_579612
  var valid_579613 = query.getOrDefault("uploadType")
  valid_579613 = validateParameter(valid_579613, JString, required = false,
                                 default = nil)
  if valid_579613 != nil:
    section.add "uploadType", valid_579613
  var valid_579614 = query.getOrDefault("quotaUser")
  valid_579614 = validateParameter(valid_579614, JString, required = false,
                                 default = nil)
  if valid_579614 != nil:
    section.add "quotaUser", valid_579614
  var valid_579615 = query.getOrDefault("callback")
  valid_579615 = validateParameter(valid_579615, JString, required = false,
                                 default = nil)
  if valid_579615 != nil:
    section.add "callback", valid_579615
  var valid_579616 = query.getOrDefault("fields")
  valid_579616 = validateParameter(valid_579616, JString, required = false,
                                 default = nil)
  if valid_579616 != nil:
    section.add "fields", valid_579616
  var valid_579617 = query.getOrDefault("access_token")
  valid_579617 = validateParameter(valid_579617, JString, required = false,
                                 default = nil)
  if valid_579617 != nil:
    section.add "access_token", valid_579617
  var valid_579618 = query.getOrDefault("upload_protocol")
  valid_579618 = validateParameter(valid_579618, JString, required = false,
                                 default = nil)
  if valid_579618 != nil:
    section.add "upload_protocol", valid_579618
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

proc call*(call_579620: Call_RunProjectsLocationsServicesCreate_579604;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to create a service.
  ## 
  let valid = call_579620.validator(path, query, header, formData, body)
  let scheme = call_579620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579620.url(scheme.get, call_579620.host, call_579620.base,
                         call_579620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579620, url, valid)

proc call*(call_579621: Call_RunProjectsLocationsServicesCreate_579604;
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
  var path_579622 = newJObject()
  var query_579623 = newJObject()
  var body_579624 = newJObject()
  add(query_579623, "key", newJString(key))
  add(query_579623, "prettyPrint", newJBool(prettyPrint))
  add(query_579623, "oauth_token", newJString(oauthToken))
  add(query_579623, "$.xgafv", newJString(Xgafv))
  add(query_579623, "alt", newJString(alt))
  add(query_579623, "uploadType", newJString(uploadType))
  add(query_579623, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579624 = body
  add(query_579623, "callback", newJString(callback))
  add(path_579622, "parent", newJString(parent))
  add(query_579623, "fields", newJString(fields))
  add(query_579623, "access_token", newJString(accessToken))
  add(query_579623, "upload_protocol", newJString(uploadProtocol))
  result = call_579621.call(path_579622, query_579623, nil, nil, body_579624)

var runProjectsLocationsServicesCreate* = Call_RunProjectsLocationsServicesCreate_579604(
    name: "runProjectsLocationsServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesCreate_579605, base: "/",
    url: url_RunProjectsLocationsServicesCreate_579606, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesList_579578 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesList_579580(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsServicesList_579579(path: JsonNode;
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
  var valid_579581 = path.getOrDefault("parent")
  valid_579581 = validateParameter(valid_579581, JString, required = true,
                                 default = nil)
  if valid_579581 != nil:
    section.add "parent", valid_579581
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
  var valid_579582 = query.getOrDefault("key")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "key", valid_579582
  var valid_579583 = query.getOrDefault("includeUninitialized")
  valid_579583 = validateParameter(valid_579583, JBool, required = false, default = nil)
  if valid_579583 != nil:
    section.add "includeUninitialized", valid_579583
  var valid_579584 = query.getOrDefault("prettyPrint")
  valid_579584 = validateParameter(valid_579584, JBool, required = false,
                                 default = newJBool(true))
  if valid_579584 != nil:
    section.add "prettyPrint", valid_579584
  var valid_579585 = query.getOrDefault("oauth_token")
  valid_579585 = validateParameter(valid_579585, JString, required = false,
                                 default = nil)
  if valid_579585 != nil:
    section.add "oauth_token", valid_579585
  var valid_579586 = query.getOrDefault("fieldSelector")
  valid_579586 = validateParameter(valid_579586, JString, required = false,
                                 default = nil)
  if valid_579586 != nil:
    section.add "fieldSelector", valid_579586
  var valid_579587 = query.getOrDefault("labelSelector")
  valid_579587 = validateParameter(valid_579587, JString, required = false,
                                 default = nil)
  if valid_579587 != nil:
    section.add "labelSelector", valid_579587
  var valid_579588 = query.getOrDefault("$.xgafv")
  valid_579588 = validateParameter(valid_579588, JString, required = false,
                                 default = newJString("1"))
  if valid_579588 != nil:
    section.add "$.xgafv", valid_579588
  var valid_579589 = query.getOrDefault("limit")
  valid_579589 = validateParameter(valid_579589, JInt, required = false, default = nil)
  if valid_579589 != nil:
    section.add "limit", valid_579589
  var valid_579590 = query.getOrDefault("alt")
  valid_579590 = validateParameter(valid_579590, JString, required = false,
                                 default = newJString("json"))
  if valid_579590 != nil:
    section.add "alt", valid_579590
  var valid_579591 = query.getOrDefault("uploadType")
  valid_579591 = validateParameter(valid_579591, JString, required = false,
                                 default = nil)
  if valid_579591 != nil:
    section.add "uploadType", valid_579591
  var valid_579592 = query.getOrDefault("quotaUser")
  valid_579592 = validateParameter(valid_579592, JString, required = false,
                                 default = nil)
  if valid_579592 != nil:
    section.add "quotaUser", valid_579592
  var valid_579593 = query.getOrDefault("watch")
  valid_579593 = validateParameter(valid_579593, JBool, required = false, default = nil)
  if valid_579593 != nil:
    section.add "watch", valid_579593
  var valid_579594 = query.getOrDefault("callback")
  valid_579594 = validateParameter(valid_579594, JString, required = false,
                                 default = nil)
  if valid_579594 != nil:
    section.add "callback", valid_579594
  var valid_579595 = query.getOrDefault("resourceVersion")
  valid_579595 = validateParameter(valid_579595, JString, required = false,
                                 default = nil)
  if valid_579595 != nil:
    section.add "resourceVersion", valid_579595
  var valid_579596 = query.getOrDefault("fields")
  valid_579596 = validateParameter(valid_579596, JString, required = false,
                                 default = nil)
  if valid_579596 != nil:
    section.add "fields", valid_579596
  var valid_579597 = query.getOrDefault("access_token")
  valid_579597 = validateParameter(valid_579597, JString, required = false,
                                 default = nil)
  if valid_579597 != nil:
    section.add "access_token", valid_579597
  var valid_579598 = query.getOrDefault("upload_protocol")
  valid_579598 = validateParameter(valid_579598, JString, required = false,
                                 default = nil)
  if valid_579598 != nil:
    section.add "upload_protocol", valid_579598
  var valid_579599 = query.getOrDefault("continue")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = nil)
  if valid_579599 != nil:
    section.add "continue", valid_579599
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579600: Call_RunProjectsLocationsServicesList_579578;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list services.
  ## 
  let valid = call_579600.validator(path, query, header, formData, body)
  let scheme = call_579600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579600.url(scheme.get, call_579600.host, call_579600.base,
                         call_579600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579600, url, valid)

proc call*(call_579601: Call_RunProjectsLocationsServicesList_579578;
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
  var path_579602 = newJObject()
  var query_579603 = newJObject()
  add(query_579603, "key", newJString(key))
  add(query_579603, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579603, "prettyPrint", newJBool(prettyPrint))
  add(query_579603, "oauth_token", newJString(oauthToken))
  add(query_579603, "fieldSelector", newJString(fieldSelector))
  add(query_579603, "labelSelector", newJString(labelSelector))
  add(query_579603, "$.xgafv", newJString(Xgafv))
  add(query_579603, "limit", newJInt(limit))
  add(query_579603, "alt", newJString(alt))
  add(query_579603, "uploadType", newJString(uploadType))
  add(query_579603, "quotaUser", newJString(quotaUser))
  add(query_579603, "watch", newJBool(watch))
  add(query_579603, "callback", newJString(callback))
  add(path_579602, "parent", newJString(parent))
  add(query_579603, "resourceVersion", newJString(resourceVersion))
  add(query_579603, "fields", newJString(fields))
  add(query_579603, "access_token", newJString(accessToken))
  add(query_579603, "upload_protocol", newJString(uploadProtocol))
  add(query_579603, "continue", newJString(`continue`))
  result = call_579601.call(path_579602, query_579603, nil, nil, nil)

var runProjectsLocationsServicesList* = Call_RunProjectsLocationsServicesList_579578(
    name: "runProjectsLocationsServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesList_579579, base: "/",
    url: url_RunProjectsLocationsServicesList_579580, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsTriggersCreate_579651 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsTriggersCreate_579653(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsTriggersCreate_579652(path: JsonNode;
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
  var valid_579654 = path.getOrDefault("parent")
  valid_579654 = validateParameter(valid_579654, JString, required = true,
                                 default = nil)
  if valid_579654 != nil:
    section.add "parent", valid_579654
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
  var valid_579655 = query.getOrDefault("key")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = nil)
  if valid_579655 != nil:
    section.add "key", valid_579655
  var valid_579656 = query.getOrDefault("prettyPrint")
  valid_579656 = validateParameter(valid_579656, JBool, required = false,
                                 default = newJBool(true))
  if valid_579656 != nil:
    section.add "prettyPrint", valid_579656
  var valid_579657 = query.getOrDefault("oauth_token")
  valid_579657 = validateParameter(valid_579657, JString, required = false,
                                 default = nil)
  if valid_579657 != nil:
    section.add "oauth_token", valid_579657
  var valid_579658 = query.getOrDefault("$.xgafv")
  valid_579658 = validateParameter(valid_579658, JString, required = false,
                                 default = newJString("1"))
  if valid_579658 != nil:
    section.add "$.xgafv", valid_579658
  var valid_579659 = query.getOrDefault("alt")
  valid_579659 = validateParameter(valid_579659, JString, required = false,
                                 default = newJString("json"))
  if valid_579659 != nil:
    section.add "alt", valid_579659
  var valid_579660 = query.getOrDefault("uploadType")
  valid_579660 = validateParameter(valid_579660, JString, required = false,
                                 default = nil)
  if valid_579660 != nil:
    section.add "uploadType", valid_579660
  var valid_579661 = query.getOrDefault("quotaUser")
  valid_579661 = validateParameter(valid_579661, JString, required = false,
                                 default = nil)
  if valid_579661 != nil:
    section.add "quotaUser", valid_579661
  var valid_579662 = query.getOrDefault("callback")
  valid_579662 = validateParameter(valid_579662, JString, required = false,
                                 default = nil)
  if valid_579662 != nil:
    section.add "callback", valid_579662
  var valid_579663 = query.getOrDefault("fields")
  valid_579663 = validateParameter(valid_579663, JString, required = false,
                                 default = nil)
  if valid_579663 != nil:
    section.add "fields", valid_579663
  var valid_579664 = query.getOrDefault("access_token")
  valid_579664 = validateParameter(valid_579664, JString, required = false,
                                 default = nil)
  if valid_579664 != nil:
    section.add "access_token", valid_579664
  var valid_579665 = query.getOrDefault("upload_protocol")
  valid_579665 = validateParameter(valid_579665, JString, required = false,
                                 default = nil)
  if valid_579665 != nil:
    section.add "upload_protocol", valid_579665
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

proc call*(call_579667: Call_RunProjectsLocationsTriggersCreate_579651;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new trigger.
  ## 
  let valid = call_579667.validator(path, query, header, formData, body)
  let scheme = call_579667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579667.url(scheme.get, call_579667.host, call_579667.base,
                         call_579667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579667, url, valid)

proc call*(call_579668: Call_RunProjectsLocationsTriggersCreate_579651;
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
  var path_579669 = newJObject()
  var query_579670 = newJObject()
  var body_579671 = newJObject()
  add(query_579670, "key", newJString(key))
  add(query_579670, "prettyPrint", newJBool(prettyPrint))
  add(query_579670, "oauth_token", newJString(oauthToken))
  add(query_579670, "$.xgafv", newJString(Xgafv))
  add(query_579670, "alt", newJString(alt))
  add(query_579670, "uploadType", newJString(uploadType))
  add(query_579670, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579671 = body
  add(query_579670, "callback", newJString(callback))
  add(path_579669, "parent", newJString(parent))
  add(query_579670, "fields", newJString(fields))
  add(query_579670, "access_token", newJString(accessToken))
  add(query_579670, "upload_protocol", newJString(uploadProtocol))
  result = call_579668.call(path_579669, query_579670, nil, nil, body_579671)

var runProjectsLocationsTriggersCreate* = Call_RunProjectsLocationsTriggersCreate_579651(
    name: "runProjectsLocationsTriggersCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/triggers",
    validator: validate_RunProjectsLocationsTriggersCreate_579652, base: "/",
    url: url_RunProjectsLocationsTriggersCreate_579653, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsTriggersList_579625 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsTriggersList_579627(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsTriggersList_579626(path: JsonNode;
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
  var valid_579628 = path.getOrDefault("parent")
  valid_579628 = validateParameter(valid_579628, JString, required = true,
                                 default = nil)
  if valid_579628 != nil:
    section.add "parent", valid_579628
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
  var valid_579629 = query.getOrDefault("key")
  valid_579629 = validateParameter(valid_579629, JString, required = false,
                                 default = nil)
  if valid_579629 != nil:
    section.add "key", valid_579629
  var valid_579630 = query.getOrDefault("includeUninitialized")
  valid_579630 = validateParameter(valid_579630, JBool, required = false, default = nil)
  if valid_579630 != nil:
    section.add "includeUninitialized", valid_579630
  var valid_579631 = query.getOrDefault("prettyPrint")
  valid_579631 = validateParameter(valid_579631, JBool, required = false,
                                 default = newJBool(true))
  if valid_579631 != nil:
    section.add "prettyPrint", valid_579631
  var valid_579632 = query.getOrDefault("oauth_token")
  valid_579632 = validateParameter(valid_579632, JString, required = false,
                                 default = nil)
  if valid_579632 != nil:
    section.add "oauth_token", valid_579632
  var valid_579633 = query.getOrDefault("fieldSelector")
  valid_579633 = validateParameter(valid_579633, JString, required = false,
                                 default = nil)
  if valid_579633 != nil:
    section.add "fieldSelector", valid_579633
  var valid_579634 = query.getOrDefault("labelSelector")
  valid_579634 = validateParameter(valid_579634, JString, required = false,
                                 default = nil)
  if valid_579634 != nil:
    section.add "labelSelector", valid_579634
  var valid_579635 = query.getOrDefault("$.xgafv")
  valid_579635 = validateParameter(valid_579635, JString, required = false,
                                 default = newJString("1"))
  if valid_579635 != nil:
    section.add "$.xgafv", valid_579635
  var valid_579636 = query.getOrDefault("limit")
  valid_579636 = validateParameter(valid_579636, JInt, required = false, default = nil)
  if valid_579636 != nil:
    section.add "limit", valid_579636
  var valid_579637 = query.getOrDefault("alt")
  valid_579637 = validateParameter(valid_579637, JString, required = false,
                                 default = newJString("json"))
  if valid_579637 != nil:
    section.add "alt", valid_579637
  var valid_579638 = query.getOrDefault("uploadType")
  valid_579638 = validateParameter(valid_579638, JString, required = false,
                                 default = nil)
  if valid_579638 != nil:
    section.add "uploadType", valid_579638
  var valid_579639 = query.getOrDefault("quotaUser")
  valid_579639 = validateParameter(valid_579639, JString, required = false,
                                 default = nil)
  if valid_579639 != nil:
    section.add "quotaUser", valid_579639
  var valid_579640 = query.getOrDefault("watch")
  valid_579640 = validateParameter(valid_579640, JBool, required = false, default = nil)
  if valid_579640 != nil:
    section.add "watch", valid_579640
  var valid_579641 = query.getOrDefault("callback")
  valid_579641 = validateParameter(valid_579641, JString, required = false,
                                 default = nil)
  if valid_579641 != nil:
    section.add "callback", valid_579641
  var valid_579642 = query.getOrDefault("resourceVersion")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "resourceVersion", valid_579642
  var valid_579643 = query.getOrDefault("fields")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "fields", valid_579643
  var valid_579644 = query.getOrDefault("access_token")
  valid_579644 = validateParameter(valid_579644, JString, required = false,
                                 default = nil)
  if valid_579644 != nil:
    section.add "access_token", valid_579644
  var valid_579645 = query.getOrDefault("upload_protocol")
  valid_579645 = validateParameter(valid_579645, JString, required = false,
                                 default = nil)
  if valid_579645 != nil:
    section.add "upload_protocol", valid_579645
  var valid_579646 = query.getOrDefault("continue")
  valid_579646 = validateParameter(valid_579646, JString, required = false,
                                 default = nil)
  if valid_579646 != nil:
    section.add "continue", valid_579646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579647: Call_RunProjectsLocationsTriggersList_579625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list triggers.
  ## 
  let valid = call_579647.validator(path, query, header, formData, body)
  let scheme = call_579647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579647.url(scheme.get, call_579647.host, call_579647.base,
                         call_579647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579647, url, valid)

proc call*(call_579648: Call_RunProjectsLocationsTriggersList_579625;
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
  var path_579649 = newJObject()
  var query_579650 = newJObject()
  add(query_579650, "key", newJString(key))
  add(query_579650, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579650, "prettyPrint", newJBool(prettyPrint))
  add(query_579650, "oauth_token", newJString(oauthToken))
  add(query_579650, "fieldSelector", newJString(fieldSelector))
  add(query_579650, "labelSelector", newJString(labelSelector))
  add(query_579650, "$.xgafv", newJString(Xgafv))
  add(query_579650, "limit", newJInt(limit))
  add(query_579650, "alt", newJString(alt))
  add(query_579650, "uploadType", newJString(uploadType))
  add(query_579650, "quotaUser", newJString(quotaUser))
  add(query_579650, "watch", newJBool(watch))
  add(query_579650, "callback", newJString(callback))
  add(path_579649, "parent", newJString(parent))
  add(query_579650, "resourceVersion", newJString(resourceVersion))
  add(query_579650, "fields", newJString(fields))
  add(query_579650, "access_token", newJString(accessToken))
  add(query_579650, "upload_protocol", newJString(uploadProtocol))
  add(query_579650, "continue", newJString(`continue`))
  result = call_579648.call(path_579649, query_579650, nil, nil, nil)

var runProjectsLocationsTriggersList* = Call_RunProjectsLocationsTriggersList_579625(
    name: "runProjectsLocationsTriggersList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/triggers",
    validator: validate_RunProjectsLocationsTriggersList_579626, base: "/",
    url: url_RunProjectsLocationsTriggersList_579627, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesGetIamPolicy_579672 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesGetIamPolicy_579674(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesGetIamPolicy_579673(path: JsonNode;
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
  var valid_579675 = path.getOrDefault("resource")
  valid_579675 = validateParameter(valid_579675, JString, required = true,
                                 default = nil)
  if valid_579675 != nil:
    section.add "resource", valid_579675
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
  var valid_579676 = query.getOrDefault("key")
  valid_579676 = validateParameter(valid_579676, JString, required = false,
                                 default = nil)
  if valid_579676 != nil:
    section.add "key", valid_579676
  var valid_579677 = query.getOrDefault("prettyPrint")
  valid_579677 = validateParameter(valid_579677, JBool, required = false,
                                 default = newJBool(true))
  if valid_579677 != nil:
    section.add "prettyPrint", valid_579677
  var valid_579678 = query.getOrDefault("oauth_token")
  valid_579678 = validateParameter(valid_579678, JString, required = false,
                                 default = nil)
  if valid_579678 != nil:
    section.add "oauth_token", valid_579678
  var valid_579679 = query.getOrDefault("$.xgafv")
  valid_579679 = validateParameter(valid_579679, JString, required = false,
                                 default = newJString("1"))
  if valid_579679 != nil:
    section.add "$.xgafv", valid_579679
  var valid_579680 = query.getOrDefault("options.requestedPolicyVersion")
  valid_579680 = validateParameter(valid_579680, JInt, required = false, default = nil)
  if valid_579680 != nil:
    section.add "options.requestedPolicyVersion", valid_579680
  var valid_579681 = query.getOrDefault("alt")
  valid_579681 = validateParameter(valid_579681, JString, required = false,
                                 default = newJString("json"))
  if valid_579681 != nil:
    section.add "alt", valid_579681
  var valid_579682 = query.getOrDefault("uploadType")
  valid_579682 = validateParameter(valid_579682, JString, required = false,
                                 default = nil)
  if valid_579682 != nil:
    section.add "uploadType", valid_579682
  var valid_579683 = query.getOrDefault("quotaUser")
  valid_579683 = validateParameter(valid_579683, JString, required = false,
                                 default = nil)
  if valid_579683 != nil:
    section.add "quotaUser", valid_579683
  var valid_579684 = query.getOrDefault("callback")
  valid_579684 = validateParameter(valid_579684, JString, required = false,
                                 default = nil)
  if valid_579684 != nil:
    section.add "callback", valid_579684
  var valid_579685 = query.getOrDefault("fields")
  valid_579685 = validateParameter(valid_579685, JString, required = false,
                                 default = nil)
  if valid_579685 != nil:
    section.add "fields", valid_579685
  var valid_579686 = query.getOrDefault("access_token")
  valid_579686 = validateParameter(valid_579686, JString, required = false,
                                 default = nil)
  if valid_579686 != nil:
    section.add "access_token", valid_579686
  var valid_579687 = query.getOrDefault("upload_protocol")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = nil)
  if valid_579687 != nil:
    section.add "upload_protocol", valid_579687
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579688: Call_RunProjectsLocationsServicesGetIamPolicy_579672;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  let valid = call_579688.validator(path, query, header, formData, body)
  let scheme = call_579688.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579688.url(scheme.get, call_579688.host, call_579688.base,
                         call_579688.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579688, url, valid)

proc call*(call_579689: Call_RunProjectsLocationsServicesGetIamPolicy_579672;
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
  var path_579690 = newJObject()
  var query_579691 = newJObject()
  add(query_579691, "key", newJString(key))
  add(query_579691, "prettyPrint", newJBool(prettyPrint))
  add(query_579691, "oauth_token", newJString(oauthToken))
  add(query_579691, "$.xgafv", newJString(Xgafv))
  add(query_579691, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579691, "alt", newJString(alt))
  add(query_579691, "uploadType", newJString(uploadType))
  add(query_579691, "quotaUser", newJString(quotaUser))
  add(path_579690, "resource", newJString(resource))
  add(query_579691, "callback", newJString(callback))
  add(query_579691, "fields", newJString(fields))
  add(query_579691, "access_token", newJString(accessToken))
  add(query_579691, "upload_protocol", newJString(uploadProtocol))
  result = call_579689.call(path_579690, query_579691, nil, nil, nil)

var runProjectsLocationsServicesGetIamPolicy* = Call_RunProjectsLocationsServicesGetIamPolicy_579672(
    name: "runProjectsLocationsServicesGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_RunProjectsLocationsServicesGetIamPolicy_579673,
    base: "/", url: url_RunProjectsLocationsServicesGetIamPolicy_579674,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesSetIamPolicy_579692 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesSetIamPolicy_579694(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesSetIamPolicy_579693(path: JsonNode;
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
  var valid_579695 = path.getOrDefault("resource")
  valid_579695 = validateParameter(valid_579695, JString, required = true,
                                 default = nil)
  if valid_579695 != nil:
    section.add "resource", valid_579695
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
  var valid_579696 = query.getOrDefault("key")
  valid_579696 = validateParameter(valid_579696, JString, required = false,
                                 default = nil)
  if valid_579696 != nil:
    section.add "key", valid_579696
  var valid_579697 = query.getOrDefault("prettyPrint")
  valid_579697 = validateParameter(valid_579697, JBool, required = false,
                                 default = newJBool(true))
  if valid_579697 != nil:
    section.add "prettyPrint", valid_579697
  var valid_579698 = query.getOrDefault("oauth_token")
  valid_579698 = validateParameter(valid_579698, JString, required = false,
                                 default = nil)
  if valid_579698 != nil:
    section.add "oauth_token", valid_579698
  var valid_579699 = query.getOrDefault("$.xgafv")
  valid_579699 = validateParameter(valid_579699, JString, required = false,
                                 default = newJString("1"))
  if valid_579699 != nil:
    section.add "$.xgafv", valid_579699
  var valid_579700 = query.getOrDefault("alt")
  valid_579700 = validateParameter(valid_579700, JString, required = false,
                                 default = newJString("json"))
  if valid_579700 != nil:
    section.add "alt", valid_579700
  var valid_579701 = query.getOrDefault("uploadType")
  valid_579701 = validateParameter(valid_579701, JString, required = false,
                                 default = nil)
  if valid_579701 != nil:
    section.add "uploadType", valid_579701
  var valid_579702 = query.getOrDefault("quotaUser")
  valid_579702 = validateParameter(valid_579702, JString, required = false,
                                 default = nil)
  if valid_579702 != nil:
    section.add "quotaUser", valid_579702
  var valid_579703 = query.getOrDefault("callback")
  valid_579703 = validateParameter(valid_579703, JString, required = false,
                                 default = nil)
  if valid_579703 != nil:
    section.add "callback", valid_579703
  var valid_579704 = query.getOrDefault("fields")
  valid_579704 = validateParameter(valid_579704, JString, required = false,
                                 default = nil)
  if valid_579704 != nil:
    section.add "fields", valid_579704
  var valid_579705 = query.getOrDefault("access_token")
  valid_579705 = validateParameter(valid_579705, JString, required = false,
                                 default = nil)
  if valid_579705 != nil:
    section.add "access_token", valid_579705
  var valid_579706 = query.getOrDefault("upload_protocol")
  valid_579706 = validateParameter(valid_579706, JString, required = false,
                                 default = nil)
  if valid_579706 != nil:
    section.add "upload_protocol", valid_579706
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

proc call*(call_579708: Call_RunProjectsLocationsServicesSetIamPolicy_579692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  let valid = call_579708.validator(path, query, header, formData, body)
  let scheme = call_579708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579708.url(scheme.get, call_579708.host, call_579708.base,
                         call_579708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579708, url, valid)

proc call*(call_579709: Call_RunProjectsLocationsServicesSetIamPolicy_579692;
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
  var path_579710 = newJObject()
  var query_579711 = newJObject()
  var body_579712 = newJObject()
  add(query_579711, "key", newJString(key))
  add(query_579711, "prettyPrint", newJBool(prettyPrint))
  add(query_579711, "oauth_token", newJString(oauthToken))
  add(query_579711, "$.xgafv", newJString(Xgafv))
  add(query_579711, "alt", newJString(alt))
  add(query_579711, "uploadType", newJString(uploadType))
  add(query_579711, "quotaUser", newJString(quotaUser))
  add(path_579710, "resource", newJString(resource))
  if body != nil:
    body_579712 = body
  add(query_579711, "callback", newJString(callback))
  add(query_579711, "fields", newJString(fields))
  add(query_579711, "access_token", newJString(accessToken))
  add(query_579711, "upload_protocol", newJString(uploadProtocol))
  result = call_579709.call(path_579710, query_579711, nil, nil, body_579712)

var runProjectsLocationsServicesSetIamPolicy* = Call_RunProjectsLocationsServicesSetIamPolicy_579692(
    name: "runProjectsLocationsServicesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_RunProjectsLocationsServicesSetIamPolicy_579693,
    base: "/", url: url_RunProjectsLocationsServicesSetIamPolicy_579694,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesTestIamPermissions_579713 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesTestIamPermissions_579715(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesTestIamPermissions_579714(
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
  var valid_579716 = path.getOrDefault("resource")
  valid_579716 = validateParameter(valid_579716, JString, required = true,
                                 default = nil)
  if valid_579716 != nil:
    section.add "resource", valid_579716
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
  var valid_579717 = query.getOrDefault("key")
  valid_579717 = validateParameter(valid_579717, JString, required = false,
                                 default = nil)
  if valid_579717 != nil:
    section.add "key", valid_579717
  var valid_579718 = query.getOrDefault("prettyPrint")
  valid_579718 = validateParameter(valid_579718, JBool, required = false,
                                 default = newJBool(true))
  if valid_579718 != nil:
    section.add "prettyPrint", valid_579718
  var valid_579719 = query.getOrDefault("oauth_token")
  valid_579719 = validateParameter(valid_579719, JString, required = false,
                                 default = nil)
  if valid_579719 != nil:
    section.add "oauth_token", valid_579719
  var valid_579720 = query.getOrDefault("$.xgafv")
  valid_579720 = validateParameter(valid_579720, JString, required = false,
                                 default = newJString("1"))
  if valid_579720 != nil:
    section.add "$.xgafv", valid_579720
  var valid_579721 = query.getOrDefault("alt")
  valid_579721 = validateParameter(valid_579721, JString, required = false,
                                 default = newJString("json"))
  if valid_579721 != nil:
    section.add "alt", valid_579721
  var valid_579722 = query.getOrDefault("uploadType")
  valid_579722 = validateParameter(valid_579722, JString, required = false,
                                 default = nil)
  if valid_579722 != nil:
    section.add "uploadType", valid_579722
  var valid_579723 = query.getOrDefault("quotaUser")
  valid_579723 = validateParameter(valid_579723, JString, required = false,
                                 default = nil)
  if valid_579723 != nil:
    section.add "quotaUser", valid_579723
  var valid_579724 = query.getOrDefault("callback")
  valid_579724 = validateParameter(valid_579724, JString, required = false,
                                 default = nil)
  if valid_579724 != nil:
    section.add "callback", valid_579724
  var valid_579725 = query.getOrDefault("fields")
  valid_579725 = validateParameter(valid_579725, JString, required = false,
                                 default = nil)
  if valid_579725 != nil:
    section.add "fields", valid_579725
  var valid_579726 = query.getOrDefault("access_token")
  valid_579726 = validateParameter(valid_579726, JString, required = false,
                                 default = nil)
  if valid_579726 != nil:
    section.add "access_token", valid_579726
  var valid_579727 = query.getOrDefault("upload_protocol")
  valid_579727 = validateParameter(valid_579727, JString, required = false,
                                 default = nil)
  if valid_579727 != nil:
    section.add "upload_protocol", valid_579727
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

proc call*(call_579729: Call_RunProjectsLocationsServicesTestIamPermissions_579713;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_579729.validator(path, query, header, formData, body)
  let scheme = call_579729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579729.url(scheme.get, call_579729.host, call_579729.base,
                         call_579729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579729, url, valid)

proc call*(call_579730: Call_RunProjectsLocationsServicesTestIamPermissions_579713;
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
  var path_579731 = newJObject()
  var query_579732 = newJObject()
  var body_579733 = newJObject()
  add(query_579732, "key", newJString(key))
  add(query_579732, "prettyPrint", newJBool(prettyPrint))
  add(query_579732, "oauth_token", newJString(oauthToken))
  add(query_579732, "$.xgafv", newJString(Xgafv))
  add(query_579732, "alt", newJString(alt))
  add(query_579732, "uploadType", newJString(uploadType))
  add(query_579732, "quotaUser", newJString(quotaUser))
  add(path_579731, "resource", newJString(resource))
  if body != nil:
    body_579733 = body
  add(query_579732, "callback", newJString(callback))
  add(query_579732, "fields", newJString(fields))
  add(query_579732, "access_token", newJString(accessToken))
  add(query_579732, "upload_protocol", newJString(uploadProtocol))
  result = call_579730.call(path_579731, query_579732, nil, nil, body_579733)

var runProjectsLocationsServicesTestIamPermissions* = Call_RunProjectsLocationsServicesTestIamPermissions_579713(
    name: "runProjectsLocationsServicesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_RunProjectsLocationsServicesTestIamPermissions_579714,
    base: "/", url: url_RunProjectsLocationsServicesTestIamPermissions_579715,
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
