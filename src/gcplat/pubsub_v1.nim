
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Pub/Sub
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides reliable, many-to-many, asynchronous messaging between applications.
## 
## 
## https://cloud.google.com/pubsub/docs
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "pubsub"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PubsubProjectsTopicsCreate_578610 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsCreate_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsCreate_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the given topic with the given name. See the
  ## <a href="https://cloud.google.com/pubsub/docs/admin#resource_names">
  ## resource name rules</a>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the topic. It must have the format
  ## `"projects/{project}/topics/{topic}"`. `{topic}` must start with a letter,
  ## and contain only letters (`[A-Za-z]`), numbers (`[0-9]`), dashes (`-`),
  ## underscores (`_`), periods (`.`), tildes (`~`), plus (`+`) or percent
  ## signs (`%`). It must be between 3 and 255 characters in length, and it
  ## must not start with `"goog"`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("callback")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "callback", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("access_token")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "access_token", valid_578761
  var valid_578762 = query.getOrDefault("upload_protocol")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "upload_protocol", valid_578762
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

proc call*(call_578786: Call_PubsubProjectsTopicsCreate_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the given topic with the given name. See the
  ## <a href="https://cloud.google.com/pubsub/docs/admin#resource_names">
  ## resource name rules</a>.
  ## 
  let valid = call_578786.validator(path, query, header, formData, body)
  let scheme = call_578786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578786.url(scheme.get, call_578786.host, call_578786.base,
                         call_578786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578786, url, valid)

proc call*(call_578857: Call_PubsubProjectsTopicsCreate_578610; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsCreate
  ## Creates the given topic with the given name. See the
  ## <a href="https://cloud.google.com/pubsub/docs/admin#resource_names">
  ## resource name rules</a>.
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
  ##       : The name of the topic. It must have the format
  ## `"projects/{project}/topics/{topic}"`. `{topic}` must start with a letter,
  ## and contain only letters (`[A-Za-z]`), numbers (`[0-9]`), dashes (`-`),
  ## underscores (`_`), periods (`.`), tildes (`~`), plus (`+`) or percent
  ## signs (`%`). It must be between 3 and 255 characters in length, and it
  ## must not start with `"goog"`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578858 = newJObject()
  var query_578860 = newJObject()
  var body_578861 = newJObject()
  add(query_578860, "key", newJString(key))
  add(query_578860, "prettyPrint", newJBool(prettyPrint))
  add(query_578860, "oauth_token", newJString(oauthToken))
  add(query_578860, "$.xgafv", newJString(Xgafv))
  add(query_578860, "alt", newJString(alt))
  add(query_578860, "uploadType", newJString(uploadType))
  add(query_578860, "quotaUser", newJString(quotaUser))
  add(path_578858, "name", newJString(name))
  if body != nil:
    body_578861 = body
  add(query_578860, "callback", newJString(callback))
  add(query_578860, "fields", newJString(fields))
  add(query_578860, "access_token", newJString(accessToken))
  add(query_578860, "upload_protocol", newJString(uploadProtocol))
  result = call_578857.call(path_578858, query_578860, nil, nil, body_578861)

var pubsubProjectsTopicsCreate* = Call_PubsubProjectsTopicsCreate_578610(
    name: "pubsubProjectsTopicsCreate", meth: HttpMethod.HttpPut,
    host: "pubsub.googleapis.com", route: "/v1/{name}",
    validator: validate_PubsubProjectsTopicsCreate_578611, base: "/",
    url: url_PubsubProjectsTopicsCreate_578612, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsPatch_578900 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsPatch_578902(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsPatch_578901(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing topic. Note that certain properties of a
  ## topic are not modifiable.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the topic. It must have the format
  ## `"projects/{project}/topics/{topic}"`. `{topic}` must start with a letter,
  ## and contain only letters (`[A-Za-z]`), numbers (`[0-9]`), dashes (`-`),
  ## underscores (`_`), periods (`.`), tildes (`~`), plus (`+`) or percent
  ## signs (`%`). It must be between 3 and 255 characters in length, and it
  ## must not start with `"goog"`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578903 = path.getOrDefault("name")
  valid_578903 = validateParameter(valid_578903, JString, required = true,
                                 default = nil)
  if valid_578903 != nil:
    section.add "name", valid_578903
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
  var valid_578904 = query.getOrDefault("key")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "key", valid_578904
  var valid_578905 = query.getOrDefault("prettyPrint")
  valid_578905 = validateParameter(valid_578905, JBool, required = false,
                                 default = newJBool(true))
  if valid_578905 != nil:
    section.add "prettyPrint", valid_578905
  var valid_578906 = query.getOrDefault("oauth_token")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "oauth_token", valid_578906
  var valid_578907 = query.getOrDefault("$.xgafv")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = newJString("1"))
  if valid_578907 != nil:
    section.add "$.xgafv", valid_578907
  var valid_578908 = query.getOrDefault("alt")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = newJString("json"))
  if valid_578908 != nil:
    section.add "alt", valid_578908
  var valid_578909 = query.getOrDefault("uploadType")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "uploadType", valid_578909
  var valid_578910 = query.getOrDefault("quotaUser")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "quotaUser", valid_578910
  var valid_578911 = query.getOrDefault("callback")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "callback", valid_578911
  var valid_578912 = query.getOrDefault("fields")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "fields", valid_578912
  var valid_578913 = query.getOrDefault("access_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "access_token", valid_578913
  var valid_578914 = query.getOrDefault("upload_protocol")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "upload_protocol", valid_578914
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

proc call*(call_578916: Call_PubsubProjectsTopicsPatch_578900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing topic. Note that certain properties of a
  ## topic are not modifiable.
  ## 
  let valid = call_578916.validator(path, query, header, formData, body)
  let scheme = call_578916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578916.url(scheme.get, call_578916.host, call_578916.base,
                         call_578916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578916, url, valid)

proc call*(call_578917: Call_PubsubProjectsTopicsPatch_578900; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsPatch
  ## Updates an existing topic. Note that certain properties of a
  ## topic are not modifiable.
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
  ##       : The name of the topic. It must have the format
  ## `"projects/{project}/topics/{topic}"`. `{topic}` must start with a letter,
  ## and contain only letters (`[A-Za-z]`), numbers (`[0-9]`), dashes (`-`),
  ## underscores (`_`), periods (`.`), tildes (`~`), plus (`+`) or percent
  ## signs (`%`). It must be between 3 and 255 characters in length, and it
  ## must not start with `"goog"`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578918 = newJObject()
  var query_578919 = newJObject()
  var body_578920 = newJObject()
  add(query_578919, "key", newJString(key))
  add(query_578919, "prettyPrint", newJBool(prettyPrint))
  add(query_578919, "oauth_token", newJString(oauthToken))
  add(query_578919, "$.xgafv", newJString(Xgafv))
  add(query_578919, "alt", newJString(alt))
  add(query_578919, "uploadType", newJString(uploadType))
  add(query_578919, "quotaUser", newJString(quotaUser))
  add(path_578918, "name", newJString(name))
  if body != nil:
    body_578920 = body
  add(query_578919, "callback", newJString(callback))
  add(query_578919, "fields", newJString(fields))
  add(query_578919, "access_token", newJString(accessToken))
  add(query_578919, "upload_protocol", newJString(uploadProtocol))
  result = call_578917.call(path_578918, query_578919, nil, nil, body_578920)

var pubsubProjectsTopicsPatch* = Call_PubsubProjectsTopicsPatch_578900(
    name: "pubsubProjectsTopicsPatch", meth: HttpMethod.HttpPatch,
    host: "pubsub.googleapis.com", route: "/v1/{name}",
    validator: validate_PubsubProjectsTopicsPatch_578901, base: "/",
    url: url_PubsubProjectsTopicsPatch_578902, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSnapshotsList_578921 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSnapshotsList_578923(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/snapshots")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSnapshotsList_578922(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the existing snapshots. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The name of the project in which to list snapshots.
  ## Format is `projects/{project-id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578924 = path.getOrDefault("project")
  valid_578924 = validateParameter(valid_578924, JString, required = true,
                                 default = nil)
  if valid_578924 != nil:
    section.add "project", valid_578924
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
  ##           : Maximum number of snapshots to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value returned by the last `ListSnapshotsResponse`; indicates that this
  ## is a continuation of a prior `ListSnapshots` call, and that the system
  ## should return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578925 = query.getOrDefault("key")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "key", valid_578925
  var valid_578926 = query.getOrDefault("prettyPrint")
  valid_578926 = validateParameter(valid_578926, JBool, required = false,
                                 default = newJBool(true))
  if valid_578926 != nil:
    section.add "prettyPrint", valid_578926
  var valid_578927 = query.getOrDefault("oauth_token")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "oauth_token", valid_578927
  var valid_578928 = query.getOrDefault("$.xgafv")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = newJString("1"))
  if valid_578928 != nil:
    section.add "$.xgafv", valid_578928
  var valid_578929 = query.getOrDefault("pageSize")
  valid_578929 = validateParameter(valid_578929, JInt, required = false, default = nil)
  if valid_578929 != nil:
    section.add "pageSize", valid_578929
  var valid_578930 = query.getOrDefault("alt")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("json"))
  if valid_578930 != nil:
    section.add "alt", valid_578930
  var valid_578931 = query.getOrDefault("uploadType")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "uploadType", valid_578931
  var valid_578932 = query.getOrDefault("quotaUser")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "quotaUser", valid_578932
  var valid_578933 = query.getOrDefault("pageToken")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "pageToken", valid_578933
  var valid_578934 = query.getOrDefault("callback")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "callback", valid_578934
  var valid_578935 = query.getOrDefault("fields")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "fields", valid_578935
  var valid_578936 = query.getOrDefault("access_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "access_token", valid_578936
  var valid_578937 = query.getOrDefault("upload_protocol")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "upload_protocol", valid_578937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578938: Call_PubsubProjectsSnapshotsList_578921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the existing snapshots. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ## 
  let valid = call_578938.validator(path, query, header, formData, body)
  let scheme = call_578938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578938.url(scheme.get, call_578938.host, call_578938.base,
                         call_578938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578938, url, valid)

proc call*(call_578939: Call_PubsubProjectsSnapshotsList_578921; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSnapshotsList
  ## Lists the existing snapshots. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of snapshots to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value returned by the last `ListSnapshotsResponse`; indicates that this
  ## is a continuation of a prior `ListSnapshots` call, and that the system
  ## should return the next page of data.
  ##   project: string (required)
  ##          : The name of the project in which to list snapshots.
  ## Format is `projects/{project-id}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578940 = newJObject()
  var query_578941 = newJObject()
  add(query_578941, "key", newJString(key))
  add(query_578941, "prettyPrint", newJBool(prettyPrint))
  add(query_578941, "oauth_token", newJString(oauthToken))
  add(query_578941, "$.xgafv", newJString(Xgafv))
  add(query_578941, "pageSize", newJInt(pageSize))
  add(query_578941, "alt", newJString(alt))
  add(query_578941, "uploadType", newJString(uploadType))
  add(query_578941, "quotaUser", newJString(quotaUser))
  add(query_578941, "pageToken", newJString(pageToken))
  add(path_578940, "project", newJString(project))
  add(query_578941, "callback", newJString(callback))
  add(query_578941, "fields", newJString(fields))
  add(query_578941, "access_token", newJString(accessToken))
  add(query_578941, "upload_protocol", newJString(uploadProtocol))
  result = call_578939.call(path_578940, query_578941, nil, nil, nil)

var pubsubProjectsSnapshotsList* = Call_PubsubProjectsSnapshotsList_578921(
    name: "pubsubProjectsSnapshotsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{project}/snapshots",
    validator: validate_PubsubProjectsSnapshotsList_578922, base: "/",
    url: url_PubsubProjectsSnapshotsList_578923, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsList_578942 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsList_578944(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsList_578943(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists matching subscriptions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The name of the project in which to list subscriptions.
  ## Format is `projects/{project-id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578945 = path.getOrDefault("project")
  valid_578945 = validateParameter(valid_578945, JString, required = true,
                                 default = nil)
  if valid_578945 != nil:
    section.add "project", valid_578945
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
  ##           : Maximum number of subscriptions to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value returned by the last `ListSubscriptionsResponse`; indicates that
  ## this is a continuation of a prior `ListSubscriptions` call, and that the
  ## system should return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578946 = query.getOrDefault("key")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "key", valid_578946
  var valid_578947 = query.getOrDefault("prettyPrint")
  valid_578947 = validateParameter(valid_578947, JBool, required = false,
                                 default = newJBool(true))
  if valid_578947 != nil:
    section.add "prettyPrint", valid_578947
  var valid_578948 = query.getOrDefault("oauth_token")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "oauth_token", valid_578948
  var valid_578949 = query.getOrDefault("$.xgafv")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("1"))
  if valid_578949 != nil:
    section.add "$.xgafv", valid_578949
  var valid_578950 = query.getOrDefault("pageSize")
  valid_578950 = validateParameter(valid_578950, JInt, required = false, default = nil)
  if valid_578950 != nil:
    section.add "pageSize", valid_578950
  var valid_578951 = query.getOrDefault("alt")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = newJString("json"))
  if valid_578951 != nil:
    section.add "alt", valid_578951
  var valid_578952 = query.getOrDefault("uploadType")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "uploadType", valid_578952
  var valid_578953 = query.getOrDefault("quotaUser")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "quotaUser", valid_578953
  var valid_578954 = query.getOrDefault("pageToken")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "pageToken", valid_578954
  var valid_578955 = query.getOrDefault("callback")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "callback", valid_578955
  var valid_578956 = query.getOrDefault("fields")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "fields", valid_578956
  var valid_578957 = query.getOrDefault("access_token")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "access_token", valid_578957
  var valid_578958 = query.getOrDefault("upload_protocol")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "upload_protocol", valid_578958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578959: Call_PubsubProjectsSubscriptionsList_578942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists matching subscriptions.
  ## 
  let valid = call_578959.validator(path, query, header, formData, body)
  let scheme = call_578959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578959.url(scheme.get, call_578959.host, call_578959.base,
                         call_578959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578959, url, valid)

proc call*(call_578960: Call_PubsubProjectsSubscriptionsList_578942;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsList
  ## Lists matching subscriptions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of subscriptions to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value returned by the last `ListSubscriptionsResponse`; indicates that
  ## this is a continuation of a prior `ListSubscriptions` call, and that the
  ## system should return the next page of data.
  ##   project: string (required)
  ##          : The name of the project in which to list subscriptions.
  ## Format is `projects/{project-id}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578961 = newJObject()
  var query_578962 = newJObject()
  add(query_578962, "key", newJString(key))
  add(query_578962, "prettyPrint", newJBool(prettyPrint))
  add(query_578962, "oauth_token", newJString(oauthToken))
  add(query_578962, "$.xgafv", newJString(Xgafv))
  add(query_578962, "pageSize", newJInt(pageSize))
  add(query_578962, "alt", newJString(alt))
  add(query_578962, "uploadType", newJString(uploadType))
  add(query_578962, "quotaUser", newJString(quotaUser))
  add(query_578962, "pageToken", newJString(pageToken))
  add(path_578961, "project", newJString(project))
  add(query_578962, "callback", newJString(callback))
  add(query_578962, "fields", newJString(fields))
  add(query_578962, "access_token", newJString(accessToken))
  add(query_578962, "upload_protocol", newJString(uploadProtocol))
  result = call_578960.call(path_578961, query_578962, nil, nil, nil)

var pubsubProjectsSubscriptionsList* = Call_PubsubProjectsSubscriptionsList_578942(
    name: "pubsubProjectsSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{project}/subscriptions",
    validator: validate_PubsubProjectsSubscriptionsList_578943, base: "/",
    url: url_PubsubProjectsSubscriptionsList_578944, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsList_578963 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsList_578965(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/topics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsList_578964(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists matching topics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The name of the project in which to list topics.
  ## Format is `projects/{project-id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578966 = path.getOrDefault("project")
  valid_578966 = validateParameter(valid_578966, JString, required = true,
                                 default = nil)
  if valid_578966 != nil:
    section.add "project", valid_578966
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
  ##           : Maximum number of topics to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value returned by the last `ListTopicsResponse`; indicates that this is
  ## a continuation of a prior `ListTopics` call, and that the system should
  ## return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578967 = query.getOrDefault("key")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "key", valid_578967
  var valid_578968 = query.getOrDefault("prettyPrint")
  valid_578968 = validateParameter(valid_578968, JBool, required = false,
                                 default = newJBool(true))
  if valid_578968 != nil:
    section.add "prettyPrint", valid_578968
  var valid_578969 = query.getOrDefault("oauth_token")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "oauth_token", valid_578969
  var valid_578970 = query.getOrDefault("$.xgafv")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("1"))
  if valid_578970 != nil:
    section.add "$.xgafv", valid_578970
  var valid_578971 = query.getOrDefault("pageSize")
  valid_578971 = validateParameter(valid_578971, JInt, required = false, default = nil)
  if valid_578971 != nil:
    section.add "pageSize", valid_578971
  var valid_578972 = query.getOrDefault("alt")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = newJString("json"))
  if valid_578972 != nil:
    section.add "alt", valid_578972
  var valid_578973 = query.getOrDefault("uploadType")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "uploadType", valid_578973
  var valid_578974 = query.getOrDefault("quotaUser")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "quotaUser", valid_578974
  var valid_578975 = query.getOrDefault("pageToken")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "pageToken", valid_578975
  var valid_578976 = query.getOrDefault("callback")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "callback", valid_578976
  var valid_578977 = query.getOrDefault("fields")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "fields", valid_578977
  var valid_578978 = query.getOrDefault("access_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "access_token", valid_578978
  var valid_578979 = query.getOrDefault("upload_protocol")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "upload_protocol", valid_578979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578980: Call_PubsubProjectsTopicsList_578963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matching topics.
  ## 
  let valid = call_578980.validator(path, query, header, formData, body)
  let scheme = call_578980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578980.url(scheme.get, call_578980.host, call_578980.base,
                         call_578980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578980, url, valid)

proc call*(call_578981: Call_PubsubProjectsTopicsList_578963; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsList
  ## Lists matching topics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of topics to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value returned by the last `ListTopicsResponse`; indicates that this is
  ## a continuation of a prior `ListTopics` call, and that the system should
  ## return the next page of data.
  ##   project: string (required)
  ##          : The name of the project in which to list topics.
  ## Format is `projects/{project-id}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578982 = newJObject()
  var query_578983 = newJObject()
  add(query_578983, "key", newJString(key))
  add(query_578983, "prettyPrint", newJBool(prettyPrint))
  add(query_578983, "oauth_token", newJString(oauthToken))
  add(query_578983, "$.xgafv", newJString(Xgafv))
  add(query_578983, "pageSize", newJInt(pageSize))
  add(query_578983, "alt", newJString(alt))
  add(query_578983, "uploadType", newJString(uploadType))
  add(query_578983, "quotaUser", newJString(quotaUser))
  add(query_578983, "pageToken", newJString(pageToken))
  add(path_578982, "project", newJString(project))
  add(query_578983, "callback", newJString(callback))
  add(query_578983, "fields", newJString(fields))
  add(query_578983, "access_token", newJString(accessToken))
  add(query_578983, "upload_protocol", newJString(uploadProtocol))
  result = call_578981.call(path_578982, query_578983, nil, nil, nil)

var pubsubProjectsTopicsList* = Call_PubsubProjectsTopicsList_578963(
    name: "pubsubProjectsTopicsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{project}/topics",
    validator: validate_PubsubProjectsTopicsList_578964, base: "/",
    url: url_PubsubProjectsTopicsList_578965, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsGetIamPolicy_578984 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsGetIamPolicy_578986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsGetIamPolicy_578985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_578987 = path.getOrDefault("resource")
  valid_578987 = validateParameter(valid_578987, JString, required = true,
                                 default = nil)
  if valid_578987 != nil:
    section.add "resource", valid_578987
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
  var valid_578988 = query.getOrDefault("key")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "key", valid_578988
  var valid_578989 = query.getOrDefault("prettyPrint")
  valid_578989 = validateParameter(valid_578989, JBool, required = false,
                                 default = newJBool(true))
  if valid_578989 != nil:
    section.add "prettyPrint", valid_578989
  var valid_578990 = query.getOrDefault("oauth_token")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "oauth_token", valid_578990
  var valid_578991 = query.getOrDefault("$.xgafv")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("1"))
  if valid_578991 != nil:
    section.add "$.xgafv", valid_578991
  var valid_578992 = query.getOrDefault("options.requestedPolicyVersion")
  valid_578992 = validateParameter(valid_578992, JInt, required = false, default = nil)
  if valid_578992 != nil:
    section.add "options.requestedPolicyVersion", valid_578992
  var valid_578993 = query.getOrDefault("alt")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("json"))
  if valid_578993 != nil:
    section.add "alt", valid_578993
  var valid_578994 = query.getOrDefault("uploadType")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "uploadType", valid_578994
  var valid_578995 = query.getOrDefault("quotaUser")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "quotaUser", valid_578995
  var valid_578996 = query.getOrDefault("callback")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "callback", valid_578996
  var valid_578997 = query.getOrDefault("fields")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "fields", valid_578997
  var valid_578998 = query.getOrDefault("access_token")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "access_token", valid_578998
  var valid_578999 = query.getOrDefault("upload_protocol")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "upload_protocol", valid_578999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579000: Call_PubsubProjectsTopicsGetIamPolicy_578984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_579000.validator(path, query, header, formData, body)
  let scheme = call_579000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579000.url(scheme.get, call_579000.host, call_579000.base,
                         call_579000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579000, url, valid)

proc call*(call_579001: Call_PubsubProjectsTopicsGetIamPolicy_578984;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
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
  var path_579002 = newJObject()
  var query_579003 = newJObject()
  add(query_579003, "key", newJString(key))
  add(query_579003, "prettyPrint", newJBool(prettyPrint))
  add(query_579003, "oauth_token", newJString(oauthToken))
  add(query_579003, "$.xgafv", newJString(Xgafv))
  add(query_579003, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579003, "alt", newJString(alt))
  add(query_579003, "uploadType", newJString(uploadType))
  add(query_579003, "quotaUser", newJString(quotaUser))
  add(path_579002, "resource", newJString(resource))
  add(query_579003, "callback", newJString(callback))
  add(query_579003, "fields", newJString(fields))
  add(query_579003, "access_token", newJString(accessToken))
  add(query_579003, "upload_protocol", newJString(uploadProtocol))
  result = call_579001.call(path_579002, query_579003, nil, nil, nil)

var pubsubProjectsTopicsGetIamPolicy* = Call_PubsubProjectsTopicsGetIamPolicy_578984(
    name: "pubsubProjectsTopicsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_PubsubProjectsTopicsGetIamPolicy_578985, base: "/",
    url: url_PubsubProjectsTopicsGetIamPolicy_578986, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSetIamPolicy_579004 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsSetIamPolicy_579006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsSetIamPolicy_579005(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579007 = path.getOrDefault("resource")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "resource", valid_579007
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
  var valid_579008 = query.getOrDefault("key")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "key", valid_579008
  var valid_579009 = query.getOrDefault("prettyPrint")
  valid_579009 = validateParameter(valid_579009, JBool, required = false,
                                 default = newJBool(true))
  if valid_579009 != nil:
    section.add "prettyPrint", valid_579009
  var valid_579010 = query.getOrDefault("oauth_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "oauth_token", valid_579010
  var valid_579011 = query.getOrDefault("$.xgafv")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("1"))
  if valid_579011 != nil:
    section.add "$.xgafv", valid_579011
  var valid_579012 = query.getOrDefault("alt")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = newJString("json"))
  if valid_579012 != nil:
    section.add "alt", valid_579012
  var valid_579013 = query.getOrDefault("uploadType")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "uploadType", valid_579013
  var valid_579014 = query.getOrDefault("quotaUser")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "quotaUser", valid_579014
  var valid_579015 = query.getOrDefault("callback")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "callback", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
  var valid_579017 = query.getOrDefault("access_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "access_token", valid_579017
  var valid_579018 = query.getOrDefault("upload_protocol")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "upload_protocol", valid_579018
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

proc call*(call_579020: Call_PubsubProjectsTopicsSetIamPolicy_579004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579020.validator(path, query, header, formData, body)
  let scheme = call_579020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579020.url(scheme.get, call_579020.host, call_579020.base,
                         call_579020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579020, url, valid)

proc call*(call_579021: Call_PubsubProjectsTopicsSetIamPolicy_579004;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
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
  var path_579022 = newJObject()
  var query_579023 = newJObject()
  var body_579024 = newJObject()
  add(query_579023, "key", newJString(key))
  add(query_579023, "prettyPrint", newJBool(prettyPrint))
  add(query_579023, "oauth_token", newJString(oauthToken))
  add(query_579023, "$.xgafv", newJString(Xgafv))
  add(query_579023, "alt", newJString(alt))
  add(query_579023, "uploadType", newJString(uploadType))
  add(query_579023, "quotaUser", newJString(quotaUser))
  add(path_579022, "resource", newJString(resource))
  if body != nil:
    body_579024 = body
  add(query_579023, "callback", newJString(callback))
  add(query_579023, "fields", newJString(fields))
  add(query_579023, "access_token", newJString(accessToken))
  add(query_579023, "upload_protocol", newJString(uploadProtocol))
  result = call_579021.call(path_579022, query_579023, nil, nil, body_579024)

var pubsubProjectsTopicsSetIamPolicy* = Call_PubsubProjectsTopicsSetIamPolicy_579004(
    name: "pubsubProjectsTopicsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_PubsubProjectsTopicsSetIamPolicy_579005, base: "/",
    url: url_PubsubProjectsTopicsSetIamPolicy_579006, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsTestIamPermissions_579025 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsTestIamPermissions_579027(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsTestIamPermissions_579026(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579028 = path.getOrDefault("resource")
  valid_579028 = validateParameter(valid_579028, JString, required = true,
                                 default = nil)
  if valid_579028 != nil:
    section.add "resource", valid_579028
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
  var valid_579029 = query.getOrDefault("key")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "key", valid_579029
  var valid_579030 = query.getOrDefault("prettyPrint")
  valid_579030 = validateParameter(valid_579030, JBool, required = false,
                                 default = newJBool(true))
  if valid_579030 != nil:
    section.add "prettyPrint", valid_579030
  var valid_579031 = query.getOrDefault("oauth_token")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "oauth_token", valid_579031
  var valid_579032 = query.getOrDefault("$.xgafv")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = newJString("1"))
  if valid_579032 != nil:
    section.add "$.xgafv", valid_579032
  var valid_579033 = query.getOrDefault("alt")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("json"))
  if valid_579033 != nil:
    section.add "alt", valid_579033
  var valid_579034 = query.getOrDefault("uploadType")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "uploadType", valid_579034
  var valid_579035 = query.getOrDefault("quotaUser")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "quotaUser", valid_579035
  var valid_579036 = query.getOrDefault("callback")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "callback", valid_579036
  var valid_579037 = query.getOrDefault("fields")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "fields", valid_579037
  var valid_579038 = query.getOrDefault("access_token")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "access_token", valid_579038
  var valid_579039 = query.getOrDefault("upload_protocol")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "upload_protocol", valid_579039
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

proc call*(call_579041: Call_PubsubProjectsTopicsTestIamPermissions_579025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  let valid = call_579041.validator(path, query, header, formData, body)
  let scheme = call_579041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579041.url(scheme.get, call_579041.host, call_579041.base,
                         call_579041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579041, url, valid)

proc call*(call_579042: Call_PubsubProjectsTopicsTestIamPermissions_579025;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
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
  var path_579043 = newJObject()
  var query_579044 = newJObject()
  var body_579045 = newJObject()
  add(query_579044, "key", newJString(key))
  add(query_579044, "prettyPrint", newJBool(prettyPrint))
  add(query_579044, "oauth_token", newJString(oauthToken))
  add(query_579044, "$.xgafv", newJString(Xgafv))
  add(query_579044, "alt", newJString(alt))
  add(query_579044, "uploadType", newJString(uploadType))
  add(query_579044, "quotaUser", newJString(quotaUser))
  add(path_579043, "resource", newJString(resource))
  if body != nil:
    body_579045 = body
  add(query_579044, "callback", newJString(callback))
  add(query_579044, "fields", newJString(fields))
  add(query_579044, "access_token", newJString(accessToken))
  add(query_579044, "upload_protocol", newJString(uploadProtocol))
  result = call_579042.call(path_579043, query_579044, nil, nil, body_579045)

var pubsubProjectsTopicsTestIamPermissions* = Call_PubsubProjectsTopicsTestIamPermissions_579025(
    name: "pubsubProjectsTopicsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{resource}:testIamPermissions",
    validator: validate_PubsubProjectsTopicsTestIamPermissions_579026, base: "/",
    url: url_PubsubProjectsTopicsTestIamPermissions_579027,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSnapshotsGet_579046 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSnapshotsGet_579048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshot" in path, "`snapshot` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "snapshot")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSnapshotsGet_579047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration details of a snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow you to manage message acknowledgments in bulk. That
  ## is, you can set the acknowledgment state of messages in an existing
  ## subscription to the state captured by a snapshot.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshot: JString (required)
  ##           : The name of the snapshot to get.
  ## Format is `projects/{project}/snapshots/{snap}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `snapshot` field"
  var valid_579049 = path.getOrDefault("snapshot")
  valid_579049 = validateParameter(valid_579049, JString, required = true,
                                 default = nil)
  if valid_579049 != nil:
    section.add "snapshot", valid_579049
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
  var valid_579050 = query.getOrDefault("key")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "key", valid_579050
  var valid_579051 = query.getOrDefault("prettyPrint")
  valid_579051 = validateParameter(valid_579051, JBool, required = false,
                                 default = newJBool(true))
  if valid_579051 != nil:
    section.add "prettyPrint", valid_579051
  var valid_579052 = query.getOrDefault("oauth_token")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "oauth_token", valid_579052
  var valid_579053 = query.getOrDefault("$.xgafv")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = newJString("1"))
  if valid_579053 != nil:
    section.add "$.xgafv", valid_579053
  var valid_579054 = query.getOrDefault("alt")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = newJString("json"))
  if valid_579054 != nil:
    section.add "alt", valid_579054
  var valid_579055 = query.getOrDefault("uploadType")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "uploadType", valid_579055
  var valid_579056 = query.getOrDefault("quotaUser")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "quotaUser", valid_579056
  var valid_579057 = query.getOrDefault("callback")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "callback", valid_579057
  var valid_579058 = query.getOrDefault("fields")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "fields", valid_579058
  var valid_579059 = query.getOrDefault("access_token")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "access_token", valid_579059
  var valid_579060 = query.getOrDefault("upload_protocol")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "upload_protocol", valid_579060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579061: Call_PubsubProjectsSnapshotsGet_579046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of a snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow you to manage message acknowledgments in bulk. That
  ## is, you can set the acknowledgment state of messages in an existing
  ## subscription to the state captured by a snapshot.
  ## 
  let valid = call_579061.validator(path, query, header, formData, body)
  let scheme = call_579061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579061.url(scheme.get, call_579061.host, call_579061.base,
                         call_579061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579061, url, valid)

proc call*(call_579062: Call_PubsubProjectsSnapshotsGet_579046; snapshot: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSnapshotsGet
  ## Gets the configuration details of a snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow you to manage message acknowledgments in bulk. That
  ## is, you can set the acknowledgment state of messages in an existing
  ## subscription to the state captured by a snapshot.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   snapshot: string (required)
  ##           : The name of the snapshot to get.
  ## Format is `projects/{project}/snapshots/{snap}`.
  var path_579063 = newJObject()
  var query_579064 = newJObject()
  add(query_579064, "key", newJString(key))
  add(query_579064, "prettyPrint", newJBool(prettyPrint))
  add(query_579064, "oauth_token", newJString(oauthToken))
  add(query_579064, "$.xgafv", newJString(Xgafv))
  add(query_579064, "alt", newJString(alt))
  add(query_579064, "uploadType", newJString(uploadType))
  add(query_579064, "quotaUser", newJString(quotaUser))
  add(query_579064, "callback", newJString(callback))
  add(query_579064, "fields", newJString(fields))
  add(query_579064, "access_token", newJString(accessToken))
  add(query_579064, "upload_protocol", newJString(uploadProtocol))
  add(path_579063, "snapshot", newJString(snapshot))
  result = call_579062.call(path_579063, query_579064, nil, nil, nil)

var pubsubProjectsSnapshotsGet* = Call_PubsubProjectsSnapshotsGet_579046(
    name: "pubsubProjectsSnapshotsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{snapshot}",
    validator: validate_PubsubProjectsSnapshotsGet_579047, base: "/",
    url: url_PubsubProjectsSnapshotsGet_579048, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSnapshotsDelete_579065 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSnapshotsDelete_579067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshot" in path, "`snapshot` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "snapshot")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSnapshotsDelete_579066(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes an existing snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.<br><br>
  ## When the snapshot is deleted, all messages retained in the snapshot
  ## are immediately dropped. After a snapshot is deleted, a new one may be
  ## created with the same name, but the new one has no association with the old
  ## snapshot or its subscription, unless the same subscription is specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshot: JString (required)
  ##           : The name of the snapshot to delete.
  ## Format is `projects/{project}/snapshots/{snap}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `snapshot` field"
  var valid_579068 = path.getOrDefault("snapshot")
  valid_579068 = validateParameter(valid_579068, JString, required = true,
                                 default = nil)
  if valid_579068 != nil:
    section.add "snapshot", valid_579068
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
  var valid_579069 = query.getOrDefault("key")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "key", valid_579069
  var valid_579070 = query.getOrDefault("prettyPrint")
  valid_579070 = validateParameter(valid_579070, JBool, required = false,
                                 default = newJBool(true))
  if valid_579070 != nil:
    section.add "prettyPrint", valid_579070
  var valid_579071 = query.getOrDefault("oauth_token")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "oauth_token", valid_579071
  var valid_579072 = query.getOrDefault("$.xgafv")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = newJString("1"))
  if valid_579072 != nil:
    section.add "$.xgafv", valid_579072
  var valid_579073 = query.getOrDefault("alt")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = newJString("json"))
  if valid_579073 != nil:
    section.add "alt", valid_579073
  var valid_579074 = query.getOrDefault("uploadType")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "uploadType", valid_579074
  var valid_579075 = query.getOrDefault("quotaUser")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "quotaUser", valid_579075
  var valid_579076 = query.getOrDefault("callback")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "callback", valid_579076
  var valid_579077 = query.getOrDefault("fields")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "fields", valid_579077
  var valid_579078 = query.getOrDefault("access_token")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "access_token", valid_579078
  var valid_579079 = query.getOrDefault("upload_protocol")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "upload_protocol", valid_579079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579080: Call_PubsubProjectsSnapshotsDelete_579065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes an existing snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.<br><br>
  ## When the snapshot is deleted, all messages retained in the snapshot
  ## are immediately dropped. After a snapshot is deleted, a new one may be
  ## created with the same name, but the new one has no association with the old
  ## snapshot or its subscription, unless the same subscription is specified.
  ## 
  let valid = call_579080.validator(path, query, header, formData, body)
  let scheme = call_579080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579080.url(scheme.get, call_579080.host, call_579080.base,
                         call_579080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579080, url, valid)

proc call*(call_579081: Call_PubsubProjectsSnapshotsDelete_579065;
          snapshot: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSnapshotsDelete
  ## Removes an existing snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.<br><br>
  ## When the snapshot is deleted, all messages retained in the snapshot
  ## are immediately dropped. After a snapshot is deleted, a new one may be
  ## created with the same name, but the new one has no association with the old
  ## snapshot or its subscription, unless the same subscription is specified.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   snapshot: string (required)
  ##           : The name of the snapshot to delete.
  ## Format is `projects/{project}/snapshots/{snap}`.
  var path_579082 = newJObject()
  var query_579083 = newJObject()
  add(query_579083, "key", newJString(key))
  add(query_579083, "prettyPrint", newJBool(prettyPrint))
  add(query_579083, "oauth_token", newJString(oauthToken))
  add(query_579083, "$.xgafv", newJString(Xgafv))
  add(query_579083, "alt", newJString(alt))
  add(query_579083, "uploadType", newJString(uploadType))
  add(query_579083, "quotaUser", newJString(quotaUser))
  add(query_579083, "callback", newJString(callback))
  add(query_579083, "fields", newJString(fields))
  add(query_579083, "access_token", newJString(accessToken))
  add(query_579083, "upload_protocol", newJString(uploadProtocol))
  add(path_579082, "snapshot", newJString(snapshot))
  result = call_579081.call(path_579082, query_579083, nil, nil, nil)

var pubsubProjectsSnapshotsDelete* = Call_PubsubProjectsSnapshotsDelete_579065(
    name: "pubsubProjectsSnapshotsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1/{snapshot}",
    validator: validate_PubsubProjectsSnapshotsDelete_579066, base: "/",
    url: url_PubsubProjectsSnapshotsDelete_579067, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsGet_579084 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsGet_579086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsGet_579085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration details of a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The name of the subscription to get.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579087 = path.getOrDefault("subscription")
  valid_579087 = validateParameter(valid_579087, JString, required = true,
                                 default = nil)
  if valid_579087 != nil:
    section.add "subscription", valid_579087
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
  var valid_579088 = query.getOrDefault("key")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "key", valid_579088
  var valid_579089 = query.getOrDefault("prettyPrint")
  valid_579089 = validateParameter(valid_579089, JBool, required = false,
                                 default = newJBool(true))
  if valid_579089 != nil:
    section.add "prettyPrint", valid_579089
  var valid_579090 = query.getOrDefault("oauth_token")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "oauth_token", valid_579090
  var valid_579091 = query.getOrDefault("$.xgafv")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = newJString("1"))
  if valid_579091 != nil:
    section.add "$.xgafv", valid_579091
  var valid_579092 = query.getOrDefault("alt")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = newJString("json"))
  if valid_579092 != nil:
    section.add "alt", valid_579092
  var valid_579093 = query.getOrDefault("uploadType")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "uploadType", valid_579093
  var valid_579094 = query.getOrDefault("quotaUser")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "quotaUser", valid_579094
  var valid_579095 = query.getOrDefault("callback")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "callback", valid_579095
  var valid_579096 = query.getOrDefault("fields")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "fields", valid_579096
  var valid_579097 = query.getOrDefault("access_token")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "access_token", valid_579097
  var valid_579098 = query.getOrDefault("upload_protocol")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "upload_protocol", valid_579098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579099: Call_PubsubProjectsSubscriptionsGet_579084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of a subscription.
  ## 
  let valid = call_579099.validator(path, query, header, formData, body)
  let scheme = call_579099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579099.url(scheme.get, call_579099.host, call_579099.base,
                         call_579099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579099, url, valid)

proc call*(call_579100: Call_PubsubProjectsSubscriptionsGet_579084;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsGet
  ## Gets the configuration details of a subscription.
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
  ##   subscription: string (required)
  ##               : The name of the subscription to get.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579101 = newJObject()
  var query_579102 = newJObject()
  add(query_579102, "key", newJString(key))
  add(query_579102, "prettyPrint", newJBool(prettyPrint))
  add(query_579102, "oauth_token", newJString(oauthToken))
  add(query_579102, "$.xgafv", newJString(Xgafv))
  add(query_579102, "alt", newJString(alt))
  add(query_579102, "uploadType", newJString(uploadType))
  add(query_579102, "quotaUser", newJString(quotaUser))
  add(path_579101, "subscription", newJString(subscription))
  add(query_579102, "callback", newJString(callback))
  add(query_579102, "fields", newJString(fields))
  add(query_579102, "access_token", newJString(accessToken))
  add(query_579102, "upload_protocol", newJString(uploadProtocol))
  result = call_579100.call(path_579101, query_579102, nil, nil, nil)

var pubsubProjectsSubscriptionsGet* = Call_PubsubProjectsSubscriptionsGet_579084(
    name: "pubsubProjectsSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}",
    validator: validate_PubsubProjectsSubscriptionsGet_579085, base: "/",
    url: url_PubsubProjectsSubscriptionsGet_579086, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsDelete_579103 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsDelete_579105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsDelete_579104(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing subscription. All messages retained in the subscription
  ## are immediately dropped. Calls to `Pull` after deletion will return
  ## `NOT_FOUND`. After a subscription is deleted, a new one may be created with
  ## the same name, but the new one has no association with the old
  ## subscription or its topic unless the same topic is specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The subscription to delete.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579106 = path.getOrDefault("subscription")
  valid_579106 = validateParameter(valid_579106, JString, required = true,
                                 default = nil)
  if valid_579106 != nil:
    section.add "subscription", valid_579106
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
  var valid_579107 = query.getOrDefault("key")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "key", valid_579107
  var valid_579108 = query.getOrDefault("prettyPrint")
  valid_579108 = validateParameter(valid_579108, JBool, required = false,
                                 default = newJBool(true))
  if valid_579108 != nil:
    section.add "prettyPrint", valid_579108
  var valid_579109 = query.getOrDefault("oauth_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "oauth_token", valid_579109
  var valid_579110 = query.getOrDefault("$.xgafv")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = newJString("1"))
  if valid_579110 != nil:
    section.add "$.xgafv", valid_579110
  var valid_579111 = query.getOrDefault("alt")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = newJString("json"))
  if valid_579111 != nil:
    section.add "alt", valid_579111
  var valid_579112 = query.getOrDefault("uploadType")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "uploadType", valid_579112
  var valid_579113 = query.getOrDefault("quotaUser")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "quotaUser", valid_579113
  var valid_579114 = query.getOrDefault("callback")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "callback", valid_579114
  var valid_579115 = query.getOrDefault("fields")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "fields", valid_579115
  var valid_579116 = query.getOrDefault("access_token")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "access_token", valid_579116
  var valid_579117 = query.getOrDefault("upload_protocol")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "upload_protocol", valid_579117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579118: Call_PubsubProjectsSubscriptionsDelete_579103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing subscription. All messages retained in the subscription
  ## are immediately dropped. Calls to `Pull` after deletion will return
  ## `NOT_FOUND`. After a subscription is deleted, a new one may be created with
  ## the same name, but the new one has no association with the old
  ## subscription or its topic unless the same topic is specified.
  ## 
  let valid = call_579118.validator(path, query, header, formData, body)
  let scheme = call_579118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579118.url(scheme.get, call_579118.host, call_579118.base,
                         call_579118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579118, url, valid)

proc call*(call_579119: Call_PubsubProjectsSubscriptionsDelete_579103;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsDelete
  ## Deletes an existing subscription. All messages retained in the subscription
  ## are immediately dropped. Calls to `Pull` after deletion will return
  ## `NOT_FOUND`. After a subscription is deleted, a new one may be created with
  ## the same name, but the new one has no association with the old
  ## subscription or its topic unless the same topic is specified.
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
  ##   subscription: string (required)
  ##               : The subscription to delete.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579120 = newJObject()
  var query_579121 = newJObject()
  add(query_579121, "key", newJString(key))
  add(query_579121, "prettyPrint", newJBool(prettyPrint))
  add(query_579121, "oauth_token", newJString(oauthToken))
  add(query_579121, "$.xgafv", newJString(Xgafv))
  add(query_579121, "alt", newJString(alt))
  add(query_579121, "uploadType", newJString(uploadType))
  add(query_579121, "quotaUser", newJString(quotaUser))
  add(path_579120, "subscription", newJString(subscription))
  add(query_579121, "callback", newJString(callback))
  add(query_579121, "fields", newJString(fields))
  add(query_579121, "access_token", newJString(accessToken))
  add(query_579121, "upload_protocol", newJString(uploadProtocol))
  result = call_579119.call(path_579120, query_579121, nil, nil, nil)

var pubsubProjectsSubscriptionsDelete* = Call_PubsubProjectsSubscriptionsDelete_579103(
    name: "pubsubProjectsSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}",
    validator: validate_PubsubProjectsSubscriptionsDelete_579104, base: "/",
    url: url_PubsubProjectsSubscriptionsDelete_579105, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsAcknowledge_579122 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsAcknowledge_579124(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":acknowledge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsAcknowledge_579123(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Acknowledges the messages associated with the `ack_ids` in the
  ## `AcknowledgeRequest`. The Pub/Sub system can remove the relevant messages
  ## from the subscription.
  ## 
  ## Acknowledging a message whose ack deadline has expired may succeed,
  ## but such a message may be redelivered later. Acknowledging a message more
  ## than once will not result in an error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The subscription whose message is being acknowledged.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579125 = path.getOrDefault("subscription")
  valid_579125 = validateParameter(valid_579125, JString, required = true,
                                 default = nil)
  if valid_579125 != nil:
    section.add "subscription", valid_579125
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
  var valid_579126 = query.getOrDefault("key")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "key", valid_579126
  var valid_579127 = query.getOrDefault("prettyPrint")
  valid_579127 = validateParameter(valid_579127, JBool, required = false,
                                 default = newJBool(true))
  if valid_579127 != nil:
    section.add "prettyPrint", valid_579127
  var valid_579128 = query.getOrDefault("oauth_token")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "oauth_token", valid_579128
  var valid_579129 = query.getOrDefault("$.xgafv")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = newJString("1"))
  if valid_579129 != nil:
    section.add "$.xgafv", valid_579129
  var valid_579130 = query.getOrDefault("alt")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = newJString("json"))
  if valid_579130 != nil:
    section.add "alt", valid_579130
  var valid_579131 = query.getOrDefault("uploadType")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "uploadType", valid_579131
  var valid_579132 = query.getOrDefault("quotaUser")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "quotaUser", valid_579132
  var valid_579133 = query.getOrDefault("callback")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "callback", valid_579133
  var valid_579134 = query.getOrDefault("fields")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "fields", valid_579134
  var valid_579135 = query.getOrDefault("access_token")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "access_token", valid_579135
  var valid_579136 = query.getOrDefault("upload_protocol")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "upload_protocol", valid_579136
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

proc call*(call_579138: Call_PubsubProjectsSubscriptionsAcknowledge_579122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges the messages associated with the `ack_ids` in the
  ## `AcknowledgeRequest`. The Pub/Sub system can remove the relevant messages
  ## from the subscription.
  ## 
  ## Acknowledging a message whose ack deadline has expired may succeed,
  ## but such a message may be redelivered later. Acknowledging a message more
  ## than once will not result in an error.
  ## 
  let valid = call_579138.validator(path, query, header, formData, body)
  let scheme = call_579138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579138.url(scheme.get, call_579138.host, call_579138.base,
                         call_579138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579138, url, valid)

proc call*(call_579139: Call_PubsubProjectsSubscriptionsAcknowledge_579122;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsAcknowledge
  ## Acknowledges the messages associated with the `ack_ids` in the
  ## `AcknowledgeRequest`. The Pub/Sub system can remove the relevant messages
  ## from the subscription.
  ## 
  ## Acknowledging a message whose ack deadline has expired may succeed,
  ## but such a message may be redelivered later. Acknowledging a message more
  ## than once will not result in an error.
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
  ##   subscription: string (required)
  ##               : The subscription whose message is being acknowledged.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579140 = newJObject()
  var query_579141 = newJObject()
  var body_579142 = newJObject()
  add(query_579141, "key", newJString(key))
  add(query_579141, "prettyPrint", newJBool(prettyPrint))
  add(query_579141, "oauth_token", newJString(oauthToken))
  add(query_579141, "$.xgafv", newJString(Xgafv))
  add(query_579141, "alt", newJString(alt))
  add(query_579141, "uploadType", newJString(uploadType))
  add(query_579141, "quotaUser", newJString(quotaUser))
  add(path_579140, "subscription", newJString(subscription))
  if body != nil:
    body_579142 = body
  add(query_579141, "callback", newJString(callback))
  add(query_579141, "fields", newJString(fields))
  add(query_579141, "access_token", newJString(accessToken))
  add(query_579141, "upload_protocol", newJString(uploadProtocol))
  result = call_579139.call(path_579140, query_579141, nil, nil, body_579142)

var pubsubProjectsSubscriptionsAcknowledge* = Call_PubsubProjectsSubscriptionsAcknowledge_579122(
    name: "pubsubProjectsSubscriptionsAcknowledge", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}:acknowledge",
    validator: validate_PubsubProjectsSubscriptionsAcknowledge_579123, base: "/",
    url: url_PubsubProjectsSubscriptionsAcknowledge_579124,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsModifyAckDeadline_579143 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsModifyAckDeadline_579145(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":modifyAckDeadline")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsModifyAckDeadline_579144(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the ack deadline for a specific message. This method is useful
  ## to indicate that more time is needed to process a message by the
  ## subscriber, or to make the message available for redelivery if the
  ## processing was interrupted. Note that this does not modify the
  ## subscription-level `ackDeadlineSeconds` used for subsequent messages.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The name of the subscription.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579146 = path.getOrDefault("subscription")
  valid_579146 = validateParameter(valid_579146, JString, required = true,
                                 default = nil)
  if valid_579146 != nil:
    section.add "subscription", valid_579146
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
  var valid_579147 = query.getOrDefault("key")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "key", valid_579147
  var valid_579148 = query.getOrDefault("prettyPrint")
  valid_579148 = validateParameter(valid_579148, JBool, required = false,
                                 default = newJBool(true))
  if valid_579148 != nil:
    section.add "prettyPrint", valid_579148
  var valid_579149 = query.getOrDefault("oauth_token")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "oauth_token", valid_579149
  var valid_579150 = query.getOrDefault("$.xgafv")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = newJString("1"))
  if valid_579150 != nil:
    section.add "$.xgafv", valid_579150
  var valid_579151 = query.getOrDefault("alt")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = newJString("json"))
  if valid_579151 != nil:
    section.add "alt", valid_579151
  var valid_579152 = query.getOrDefault("uploadType")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "uploadType", valid_579152
  var valid_579153 = query.getOrDefault("quotaUser")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "quotaUser", valid_579153
  var valid_579154 = query.getOrDefault("callback")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "callback", valid_579154
  var valid_579155 = query.getOrDefault("fields")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "fields", valid_579155
  var valid_579156 = query.getOrDefault("access_token")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "access_token", valid_579156
  var valid_579157 = query.getOrDefault("upload_protocol")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "upload_protocol", valid_579157
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

proc call*(call_579159: Call_PubsubProjectsSubscriptionsModifyAckDeadline_579143;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the ack deadline for a specific message. This method is useful
  ## to indicate that more time is needed to process a message by the
  ## subscriber, or to make the message available for redelivery if the
  ## processing was interrupted. Note that this does not modify the
  ## subscription-level `ackDeadlineSeconds` used for subsequent messages.
  ## 
  let valid = call_579159.validator(path, query, header, formData, body)
  let scheme = call_579159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579159.url(scheme.get, call_579159.host, call_579159.base,
                         call_579159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579159, url, valid)

proc call*(call_579160: Call_PubsubProjectsSubscriptionsModifyAckDeadline_579143;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsModifyAckDeadline
  ## Modifies the ack deadline for a specific message. This method is useful
  ## to indicate that more time is needed to process a message by the
  ## subscriber, or to make the message available for redelivery if the
  ## processing was interrupted. Note that this does not modify the
  ## subscription-level `ackDeadlineSeconds` used for subsequent messages.
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
  ##   subscription: string (required)
  ##               : The name of the subscription.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579161 = newJObject()
  var query_579162 = newJObject()
  var body_579163 = newJObject()
  add(query_579162, "key", newJString(key))
  add(query_579162, "prettyPrint", newJBool(prettyPrint))
  add(query_579162, "oauth_token", newJString(oauthToken))
  add(query_579162, "$.xgafv", newJString(Xgafv))
  add(query_579162, "alt", newJString(alt))
  add(query_579162, "uploadType", newJString(uploadType))
  add(query_579162, "quotaUser", newJString(quotaUser))
  add(path_579161, "subscription", newJString(subscription))
  if body != nil:
    body_579163 = body
  add(query_579162, "callback", newJString(callback))
  add(query_579162, "fields", newJString(fields))
  add(query_579162, "access_token", newJString(accessToken))
  add(query_579162, "upload_protocol", newJString(uploadProtocol))
  result = call_579160.call(path_579161, query_579162, nil, nil, body_579163)

var pubsubProjectsSubscriptionsModifyAckDeadline* = Call_PubsubProjectsSubscriptionsModifyAckDeadline_579143(
    name: "pubsubProjectsSubscriptionsModifyAckDeadline",
    meth: HttpMethod.HttpPost, host: "pubsub.googleapis.com",
    route: "/v1/{subscription}:modifyAckDeadline",
    validator: validate_PubsubProjectsSubscriptionsModifyAckDeadline_579144,
    base: "/", url: url_PubsubProjectsSubscriptionsModifyAckDeadline_579145,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsModifyPushConfig_579164 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsModifyPushConfig_579166(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":modifyPushConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsModifyPushConfig_579165(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the `PushConfig` for a specified subscription.
  ## 
  ## This may be used to change a push subscription to a pull one (signified by
  ## an empty `PushConfig`) or vice versa, or change the endpoint URL and other
  ## attributes of a push subscription. Messages will accumulate for delivery
  ## continuously through the call regardless of changes to the `PushConfig`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The name of the subscription.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579167 = path.getOrDefault("subscription")
  valid_579167 = validateParameter(valid_579167, JString, required = true,
                                 default = nil)
  if valid_579167 != nil:
    section.add "subscription", valid_579167
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
  var valid_579168 = query.getOrDefault("key")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "key", valid_579168
  var valid_579169 = query.getOrDefault("prettyPrint")
  valid_579169 = validateParameter(valid_579169, JBool, required = false,
                                 default = newJBool(true))
  if valid_579169 != nil:
    section.add "prettyPrint", valid_579169
  var valid_579170 = query.getOrDefault("oauth_token")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "oauth_token", valid_579170
  var valid_579171 = query.getOrDefault("$.xgafv")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = newJString("1"))
  if valid_579171 != nil:
    section.add "$.xgafv", valid_579171
  var valid_579172 = query.getOrDefault("alt")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = newJString("json"))
  if valid_579172 != nil:
    section.add "alt", valid_579172
  var valid_579173 = query.getOrDefault("uploadType")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "uploadType", valid_579173
  var valid_579174 = query.getOrDefault("quotaUser")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "quotaUser", valid_579174
  var valid_579175 = query.getOrDefault("callback")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "callback", valid_579175
  var valid_579176 = query.getOrDefault("fields")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "fields", valid_579176
  var valid_579177 = query.getOrDefault("access_token")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "access_token", valid_579177
  var valid_579178 = query.getOrDefault("upload_protocol")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "upload_protocol", valid_579178
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

proc call*(call_579180: Call_PubsubProjectsSubscriptionsModifyPushConfig_579164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the `PushConfig` for a specified subscription.
  ## 
  ## This may be used to change a push subscription to a pull one (signified by
  ## an empty `PushConfig`) or vice versa, or change the endpoint URL and other
  ## attributes of a push subscription. Messages will accumulate for delivery
  ## continuously through the call regardless of changes to the `PushConfig`.
  ## 
  let valid = call_579180.validator(path, query, header, formData, body)
  let scheme = call_579180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579180.url(scheme.get, call_579180.host, call_579180.base,
                         call_579180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579180, url, valid)

proc call*(call_579181: Call_PubsubProjectsSubscriptionsModifyPushConfig_579164;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsModifyPushConfig
  ## Modifies the `PushConfig` for a specified subscription.
  ## 
  ## This may be used to change a push subscription to a pull one (signified by
  ## an empty `PushConfig`) or vice versa, or change the endpoint URL and other
  ## attributes of a push subscription. Messages will accumulate for delivery
  ## continuously through the call regardless of changes to the `PushConfig`.
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
  ##   subscription: string (required)
  ##               : The name of the subscription.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579182 = newJObject()
  var query_579183 = newJObject()
  var body_579184 = newJObject()
  add(query_579183, "key", newJString(key))
  add(query_579183, "prettyPrint", newJBool(prettyPrint))
  add(query_579183, "oauth_token", newJString(oauthToken))
  add(query_579183, "$.xgafv", newJString(Xgafv))
  add(query_579183, "alt", newJString(alt))
  add(query_579183, "uploadType", newJString(uploadType))
  add(query_579183, "quotaUser", newJString(quotaUser))
  add(path_579182, "subscription", newJString(subscription))
  if body != nil:
    body_579184 = body
  add(query_579183, "callback", newJString(callback))
  add(query_579183, "fields", newJString(fields))
  add(query_579183, "access_token", newJString(accessToken))
  add(query_579183, "upload_protocol", newJString(uploadProtocol))
  result = call_579181.call(path_579182, query_579183, nil, nil, body_579184)

var pubsubProjectsSubscriptionsModifyPushConfig* = Call_PubsubProjectsSubscriptionsModifyPushConfig_579164(
    name: "pubsubProjectsSubscriptionsModifyPushConfig",
    meth: HttpMethod.HttpPost, host: "pubsub.googleapis.com",
    route: "/v1/{subscription}:modifyPushConfig",
    validator: validate_PubsubProjectsSubscriptionsModifyPushConfig_579165,
    base: "/", url: url_PubsubProjectsSubscriptionsModifyPushConfig_579166,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsPull_579185 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsPull_579187(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":pull")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsPull_579186(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pulls messages from the server. The server may return `UNAVAILABLE` if
  ## there are too many concurrent pull requests pending for the given
  ## subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The subscription from which messages should be pulled.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579188 = path.getOrDefault("subscription")
  valid_579188 = validateParameter(valid_579188, JString, required = true,
                                 default = nil)
  if valid_579188 != nil:
    section.add "subscription", valid_579188
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
  var valid_579189 = query.getOrDefault("key")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "key", valid_579189
  var valid_579190 = query.getOrDefault("prettyPrint")
  valid_579190 = validateParameter(valid_579190, JBool, required = false,
                                 default = newJBool(true))
  if valid_579190 != nil:
    section.add "prettyPrint", valid_579190
  var valid_579191 = query.getOrDefault("oauth_token")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "oauth_token", valid_579191
  var valid_579192 = query.getOrDefault("$.xgafv")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = newJString("1"))
  if valid_579192 != nil:
    section.add "$.xgafv", valid_579192
  var valid_579193 = query.getOrDefault("alt")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = newJString("json"))
  if valid_579193 != nil:
    section.add "alt", valid_579193
  var valid_579194 = query.getOrDefault("uploadType")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "uploadType", valid_579194
  var valid_579195 = query.getOrDefault("quotaUser")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "quotaUser", valid_579195
  var valid_579196 = query.getOrDefault("callback")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "callback", valid_579196
  var valid_579197 = query.getOrDefault("fields")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "fields", valid_579197
  var valid_579198 = query.getOrDefault("access_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "access_token", valid_579198
  var valid_579199 = query.getOrDefault("upload_protocol")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "upload_protocol", valid_579199
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

proc call*(call_579201: Call_PubsubProjectsSubscriptionsPull_579185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pulls messages from the server. The server may return `UNAVAILABLE` if
  ## there are too many concurrent pull requests pending for the given
  ## subscription.
  ## 
  let valid = call_579201.validator(path, query, header, formData, body)
  let scheme = call_579201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579201.url(scheme.get, call_579201.host, call_579201.base,
                         call_579201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579201, url, valid)

proc call*(call_579202: Call_PubsubProjectsSubscriptionsPull_579185;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsPull
  ## Pulls messages from the server. The server may return `UNAVAILABLE` if
  ## there are too many concurrent pull requests pending for the given
  ## subscription.
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
  ##   subscription: string (required)
  ##               : The subscription from which messages should be pulled.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579203 = newJObject()
  var query_579204 = newJObject()
  var body_579205 = newJObject()
  add(query_579204, "key", newJString(key))
  add(query_579204, "prettyPrint", newJBool(prettyPrint))
  add(query_579204, "oauth_token", newJString(oauthToken))
  add(query_579204, "$.xgafv", newJString(Xgafv))
  add(query_579204, "alt", newJString(alt))
  add(query_579204, "uploadType", newJString(uploadType))
  add(query_579204, "quotaUser", newJString(quotaUser))
  add(path_579203, "subscription", newJString(subscription))
  if body != nil:
    body_579205 = body
  add(query_579204, "callback", newJString(callback))
  add(query_579204, "fields", newJString(fields))
  add(query_579204, "access_token", newJString(accessToken))
  add(query_579204, "upload_protocol", newJString(uploadProtocol))
  result = call_579202.call(path_579203, query_579204, nil, nil, body_579205)

var pubsubProjectsSubscriptionsPull* = Call_PubsubProjectsSubscriptionsPull_579185(
    name: "pubsubProjectsSubscriptionsPull", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}:pull",
    validator: validate_PubsubProjectsSubscriptionsPull_579186, base: "/",
    url: url_PubsubProjectsSubscriptionsPull_579187, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsSeek_579206 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsSeek_579208(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":seek")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsSeek_579207(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Seeks an existing subscription to a point in time or to a given snapshot,
  ## whichever is provided in the request. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot. Note that both the subscription and the snapshot
  ## must be on the same topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The subscription to affect.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579209 = path.getOrDefault("subscription")
  valid_579209 = validateParameter(valid_579209, JString, required = true,
                                 default = nil)
  if valid_579209 != nil:
    section.add "subscription", valid_579209
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
  var valid_579210 = query.getOrDefault("key")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "key", valid_579210
  var valid_579211 = query.getOrDefault("prettyPrint")
  valid_579211 = validateParameter(valid_579211, JBool, required = false,
                                 default = newJBool(true))
  if valid_579211 != nil:
    section.add "prettyPrint", valid_579211
  var valid_579212 = query.getOrDefault("oauth_token")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "oauth_token", valid_579212
  var valid_579213 = query.getOrDefault("$.xgafv")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = newJString("1"))
  if valid_579213 != nil:
    section.add "$.xgafv", valid_579213
  var valid_579214 = query.getOrDefault("alt")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = newJString("json"))
  if valid_579214 != nil:
    section.add "alt", valid_579214
  var valid_579215 = query.getOrDefault("uploadType")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "uploadType", valid_579215
  var valid_579216 = query.getOrDefault("quotaUser")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "quotaUser", valid_579216
  var valid_579217 = query.getOrDefault("callback")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "callback", valid_579217
  var valid_579218 = query.getOrDefault("fields")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "fields", valid_579218
  var valid_579219 = query.getOrDefault("access_token")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "access_token", valid_579219
  var valid_579220 = query.getOrDefault("upload_protocol")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "upload_protocol", valid_579220
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

proc call*(call_579222: Call_PubsubProjectsSubscriptionsSeek_579206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Seeks an existing subscription to a point in time or to a given snapshot,
  ## whichever is provided in the request. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot. Note that both the subscription and the snapshot
  ## must be on the same topic.
  ## 
  let valid = call_579222.validator(path, query, header, formData, body)
  let scheme = call_579222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579222.url(scheme.get, call_579222.host, call_579222.base,
                         call_579222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579222, url, valid)

proc call*(call_579223: Call_PubsubProjectsSubscriptionsSeek_579206;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsSeek
  ## Seeks an existing subscription to a point in time or to a given snapshot,
  ## whichever is provided in the request. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot. Note that both the subscription and the snapshot
  ## must be on the same topic.
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
  ##   subscription: string (required)
  ##               : The subscription to affect.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579224 = newJObject()
  var query_579225 = newJObject()
  var body_579226 = newJObject()
  add(query_579225, "key", newJString(key))
  add(query_579225, "prettyPrint", newJBool(prettyPrint))
  add(query_579225, "oauth_token", newJString(oauthToken))
  add(query_579225, "$.xgafv", newJString(Xgafv))
  add(query_579225, "alt", newJString(alt))
  add(query_579225, "uploadType", newJString(uploadType))
  add(query_579225, "quotaUser", newJString(quotaUser))
  add(path_579224, "subscription", newJString(subscription))
  if body != nil:
    body_579226 = body
  add(query_579225, "callback", newJString(callback))
  add(query_579225, "fields", newJString(fields))
  add(query_579225, "access_token", newJString(accessToken))
  add(query_579225, "upload_protocol", newJString(uploadProtocol))
  result = call_579223.call(path_579224, query_579225, nil, nil, body_579226)

var pubsubProjectsSubscriptionsSeek* = Call_PubsubProjectsSubscriptionsSeek_579206(
    name: "pubsubProjectsSubscriptionsSeek", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}:seek",
    validator: validate_PubsubProjectsSubscriptionsSeek_579207, base: "/",
    url: url_PubsubProjectsSubscriptionsSeek_579208, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsGet_579227 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsGet_579229(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "topic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsGet_579228(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration of a topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : The name of the topic to get.
  ## Format is `projects/{project}/topics/{topic}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_579230 = path.getOrDefault("topic")
  valid_579230 = validateParameter(valid_579230, JString, required = true,
                                 default = nil)
  if valid_579230 != nil:
    section.add "topic", valid_579230
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
  var valid_579231 = query.getOrDefault("key")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "key", valid_579231
  var valid_579232 = query.getOrDefault("prettyPrint")
  valid_579232 = validateParameter(valid_579232, JBool, required = false,
                                 default = newJBool(true))
  if valid_579232 != nil:
    section.add "prettyPrint", valid_579232
  var valid_579233 = query.getOrDefault("oauth_token")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "oauth_token", valid_579233
  var valid_579234 = query.getOrDefault("$.xgafv")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = newJString("1"))
  if valid_579234 != nil:
    section.add "$.xgafv", valid_579234
  var valid_579235 = query.getOrDefault("alt")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = newJString("json"))
  if valid_579235 != nil:
    section.add "alt", valid_579235
  var valid_579236 = query.getOrDefault("uploadType")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "uploadType", valid_579236
  var valid_579237 = query.getOrDefault("quotaUser")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "quotaUser", valid_579237
  var valid_579238 = query.getOrDefault("callback")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "callback", valid_579238
  var valid_579239 = query.getOrDefault("fields")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "fields", valid_579239
  var valid_579240 = query.getOrDefault("access_token")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "access_token", valid_579240
  var valid_579241 = query.getOrDefault("upload_protocol")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "upload_protocol", valid_579241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579242: Call_PubsubProjectsTopicsGet_579227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration of a topic.
  ## 
  let valid = call_579242.validator(path, query, header, formData, body)
  let scheme = call_579242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579242.url(scheme.get, call_579242.host, call_579242.base,
                         call_579242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579242, url, valid)

proc call*(call_579243: Call_PubsubProjectsTopicsGet_579227; topic: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsGet
  ## Gets the configuration of a topic.
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
  ##   topic: string (required)
  ##        : The name of the topic to get.
  ## Format is `projects/{project}/topics/{topic}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579244 = newJObject()
  var query_579245 = newJObject()
  add(query_579245, "key", newJString(key))
  add(query_579245, "prettyPrint", newJBool(prettyPrint))
  add(query_579245, "oauth_token", newJString(oauthToken))
  add(query_579245, "$.xgafv", newJString(Xgafv))
  add(query_579245, "alt", newJString(alt))
  add(query_579245, "uploadType", newJString(uploadType))
  add(query_579245, "quotaUser", newJString(quotaUser))
  add(path_579244, "topic", newJString(topic))
  add(query_579245, "callback", newJString(callback))
  add(query_579245, "fields", newJString(fields))
  add(query_579245, "access_token", newJString(accessToken))
  add(query_579245, "upload_protocol", newJString(uploadProtocol))
  result = call_579243.call(path_579244, query_579245, nil, nil, nil)

var pubsubProjectsTopicsGet* = Call_PubsubProjectsTopicsGet_579227(
    name: "pubsubProjectsTopicsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{topic}",
    validator: validate_PubsubProjectsTopicsGet_579228, base: "/",
    url: url_PubsubProjectsTopicsGet_579229, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsDelete_579246 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsDelete_579248(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "topic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsDelete_579247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the topic with the given name. Returns `NOT_FOUND` if the topic
  ## does not exist. After a topic is deleted, a new topic may be created with
  ## the same name; this is an entirely new topic with none of the old
  ## configuration or subscriptions. Existing subscriptions to this topic are
  ## not deleted, but their `topic` field is set to `_deleted-topic_`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : Name of the topic to delete.
  ## Format is `projects/{project}/topics/{topic}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_579249 = path.getOrDefault("topic")
  valid_579249 = validateParameter(valid_579249, JString, required = true,
                                 default = nil)
  if valid_579249 != nil:
    section.add "topic", valid_579249
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
  var valid_579250 = query.getOrDefault("key")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "key", valid_579250
  var valid_579251 = query.getOrDefault("prettyPrint")
  valid_579251 = validateParameter(valid_579251, JBool, required = false,
                                 default = newJBool(true))
  if valid_579251 != nil:
    section.add "prettyPrint", valid_579251
  var valid_579252 = query.getOrDefault("oauth_token")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "oauth_token", valid_579252
  var valid_579253 = query.getOrDefault("$.xgafv")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = newJString("1"))
  if valid_579253 != nil:
    section.add "$.xgafv", valid_579253
  var valid_579254 = query.getOrDefault("alt")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = newJString("json"))
  if valid_579254 != nil:
    section.add "alt", valid_579254
  var valid_579255 = query.getOrDefault("uploadType")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "uploadType", valid_579255
  var valid_579256 = query.getOrDefault("quotaUser")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "quotaUser", valid_579256
  var valid_579257 = query.getOrDefault("callback")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "callback", valid_579257
  var valid_579258 = query.getOrDefault("fields")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "fields", valid_579258
  var valid_579259 = query.getOrDefault("access_token")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "access_token", valid_579259
  var valid_579260 = query.getOrDefault("upload_protocol")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "upload_protocol", valid_579260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579261: Call_PubsubProjectsTopicsDelete_579246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the topic with the given name. Returns `NOT_FOUND` if the topic
  ## does not exist. After a topic is deleted, a new topic may be created with
  ## the same name; this is an entirely new topic with none of the old
  ## configuration or subscriptions. Existing subscriptions to this topic are
  ## not deleted, but their `topic` field is set to `_deleted-topic_`.
  ## 
  let valid = call_579261.validator(path, query, header, formData, body)
  let scheme = call_579261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579261.url(scheme.get, call_579261.host, call_579261.base,
                         call_579261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579261, url, valid)

proc call*(call_579262: Call_PubsubProjectsTopicsDelete_579246; topic: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsDelete
  ## Deletes the topic with the given name. Returns `NOT_FOUND` if the topic
  ## does not exist. After a topic is deleted, a new topic may be created with
  ## the same name; this is an entirely new topic with none of the old
  ## configuration or subscriptions. Existing subscriptions to this topic are
  ## not deleted, but their `topic` field is set to `_deleted-topic_`.
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
  ##   topic: string (required)
  ##        : Name of the topic to delete.
  ## Format is `projects/{project}/topics/{topic}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579263 = newJObject()
  var query_579264 = newJObject()
  add(query_579264, "key", newJString(key))
  add(query_579264, "prettyPrint", newJBool(prettyPrint))
  add(query_579264, "oauth_token", newJString(oauthToken))
  add(query_579264, "$.xgafv", newJString(Xgafv))
  add(query_579264, "alt", newJString(alt))
  add(query_579264, "uploadType", newJString(uploadType))
  add(query_579264, "quotaUser", newJString(quotaUser))
  add(path_579263, "topic", newJString(topic))
  add(query_579264, "callback", newJString(callback))
  add(query_579264, "fields", newJString(fields))
  add(query_579264, "access_token", newJString(accessToken))
  add(query_579264, "upload_protocol", newJString(uploadProtocol))
  result = call_579262.call(path_579263, query_579264, nil, nil, nil)

var pubsubProjectsTopicsDelete* = Call_PubsubProjectsTopicsDelete_579246(
    name: "pubsubProjectsTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1/{topic}",
    validator: validate_PubsubProjectsTopicsDelete_579247, base: "/",
    url: url_PubsubProjectsTopicsDelete_579248, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSnapshotsList_579265 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsSnapshotsList_579267(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "topic"),
               (kind: ConstantSegment, value: "/snapshots")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsSnapshotsList_579266(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the names of the snapshots on this topic. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : The name of the topic that snapshots are attached to.
  ## Format is `projects/{project}/topics/{topic}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_579268 = path.getOrDefault("topic")
  valid_579268 = validateParameter(valid_579268, JString, required = true,
                                 default = nil)
  if valid_579268 != nil:
    section.add "topic", valid_579268
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
  ##           : Maximum number of snapshot names to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value returned by the last `ListTopicSnapshotsResponse`; indicates
  ## that this is a continuation of a prior `ListTopicSnapshots` call, and
  ## that the system should return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579269 = query.getOrDefault("key")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "key", valid_579269
  var valid_579270 = query.getOrDefault("prettyPrint")
  valid_579270 = validateParameter(valid_579270, JBool, required = false,
                                 default = newJBool(true))
  if valid_579270 != nil:
    section.add "prettyPrint", valid_579270
  var valid_579271 = query.getOrDefault("oauth_token")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "oauth_token", valid_579271
  var valid_579272 = query.getOrDefault("$.xgafv")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = newJString("1"))
  if valid_579272 != nil:
    section.add "$.xgafv", valid_579272
  var valid_579273 = query.getOrDefault("pageSize")
  valid_579273 = validateParameter(valid_579273, JInt, required = false, default = nil)
  if valid_579273 != nil:
    section.add "pageSize", valid_579273
  var valid_579274 = query.getOrDefault("alt")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = newJString("json"))
  if valid_579274 != nil:
    section.add "alt", valid_579274
  var valid_579275 = query.getOrDefault("uploadType")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "uploadType", valid_579275
  var valid_579276 = query.getOrDefault("quotaUser")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "quotaUser", valid_579276
  var valid_579277 = query.getOrDefault("pageToken")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "pageToken", valid_579277
  var valid_579278 = query.getOrDefault("callback")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "callback", valid_579278
  var valid_579279 = query.getOrDefault("fields")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "fields", valid_579279
  var valid_579280 = query.getOrDefault("access_token")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "access_token", valid_579280
  var valid_579281 = query.getOrDefault("upload_protocol")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "upload_protocol", valid_579281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579282: Call_PubsubProjectsTopicsSnapshotsList_579265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the names of the snapshots on this topic. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ## 
  let valid = call_579282.validator(path, query, header, formData, body)
  let scheme = call_579282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579282.url(scheme.get, call_579282.host, call_579282.base,
                         call_579282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579282, url, valid)

proc call*(call_579283: Call_PubsubProjectsTopicsSnapshotsList_579265;
          topic: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsSnapshotsList
  ## Lists the names of the snapshots on this topic. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of snapshot names to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value returned by the last `ListTopicSnapshotsResponse`; indicates
  ## that this is a continuation of a prior `ListTopicSnapshots` call, and
  ## that the system should return the next page of data.
  ##   topic: string (required)
  ##        : The name of the topic that snapshots are attached to.
  ## Format is `projects/{project}/topics/{topic}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579284 = newJObject()
  var query_579285 = newJObject()
  add(query_579285, "key", newJString(key))
  add(query_579285, "prettyPrint", newJBool(prettyPrint))
  add(query_579285, "oauth_token", newJString(oauthToken))
  add(query_579285, "$.xgafv", newJString(Xgafv))
  add(query_579285, "pageSize", newJInt(pageSize))
  add(query_579285, "alt", newJString(alt))
  add(query_579285, "uploadType", newJString(uploadType))
  add(query_579285, "quotaUser", newJString(quotaUser))
  add(query_579285, "pageToken", newJString(pageToken))
  add(path_579284, "topic", newJString(topic))
  add(query_579285, "callback", newJString(callback))
  add(query_579285, "fields", newJString(fields))
  add(query_579285, "access_token", newJString(accessToken))
  add(query_579285, "upload_protocol", newJString(uploadProtocol))
  result = call_579283.call(path_579284, query_579285, nil, nil, nil)

var pubsubProjectsTopicsSnapshotsList* = Call_PubsubProjectsTopicsSnapshotsList_579265(
    name: "pubsubProjectsTopicsSnapshotsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{topic}/snapshots",
    validator: validate_PubsubProjectsTopicsSnapshotsList_579266, base: "/",
    url: url_PubsubProjectsTopicsSnapshotsList_579267, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSubscriptionsList_579286 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsSubscriptionsList_579288(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "topic"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsSubscriptionsList_579287(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the names of the subscriptions on this topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : The name of the topic that subscriptions are attached to.
  ## Format is `projects/{project}/topics/{topic}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_579289 = path.getOrDefault("topic")
  valid_579289 = validateParameter(valid_579289, JString, required = true,
                                 default = nil)
  if valid_579289 != nil:
    section.add "topic", valid_579289
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
  ##           : Maximum number of subscription names to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value returned by the last `ListTopicSubscriptionsResponse`; indicates
  ## that this is a continuation of a prior `ListTopicSubscriptions` call, and
  ## that the system should return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579290 = query.getOrDefault("key")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "key", valid_579290
  var valid_579291 = query.getOrDefault("prettyPrint")
  valid_579291 = validateParameter(valid_579291, JBool, required = false,
                                 default = newJBool(true))
  if valid_579291 != nil:
    section.add "prettyPrint", valid_579291
  var valid_579292 = query.getOrDefault("oauth_token")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "oauth_token", valid_579292
  var valid_579293 = query.getOrDefault("$.xgafv")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = newJString("1"))
  if valid_579293 != nil:
    section.add "$.xgafv", valid_579293
  var valid_579294 = query.getOrDefault("pageSize")
  valid_579294 = validateParameter(valid_579294, JInt, required = false, default = nil)
  if valid_579294 != nil:
    section.add "pageSize", valid_579294
  var valid_579295 = query.getOrDefault("alt")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = newJString("json"))
  if valid_579295 != nil:
    section.add "alt", valid_579295
  var valid_579296 = query.getOrDefault("uploadType")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "uploadType", valid_579296
  var valid_579297 = query.getOrDefault("quotaUser")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "quotaUser", valid_579297
  var valid_579298 = query.getOrDefault("pageToken")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "pageToken", valid_579298
  var valid_579299 = query.getOrDefault("callback")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "callback", valid_579299
  var valid_579300 = query.getOrDefault("fields")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "fields", valid_579300
  var valid_579301 = query.getOrDefault("access_token")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "access_token", valid_579301
  var valid_579302 = query.getOrDefault("upload_protocol")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "upload_protocol", valid_579302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579303: Call_PubsubProjectsTopicsSubscriptionsList_579286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the names of the subscriptions on this topic.
  ## 
  let valid = call_579303.validator(path, query, header, formData, body)
  let scheme = call_579303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579303.url(scheme.get, call_579303.host, call_579303.base,
                         call_579303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579303, url, valid)

proc call*(call_579304: Call_PubsubProjectsTopicsSubscriptionsList_579286;
          topic: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsSubscriptionsList
  ## Lists the names of the subscriptions on this topic.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of subscription names to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value returned by the last `ListTopicSubscriptionsResponse`; indicates
  ## that this is a continuation of a prior `ListTopicSubscriptions` call, and
  ## that the system should return the next page of data.
  ##   topic: string (required)
  ##        : The name of the topic that subscriptions are attached to.
  ## Format is `projects/{project}/topics/{topic}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579305 = newJObject()
  var query_579306 = newJObject()
  add(query_579306, "key", newJString(key))
  add(query_579306, "prettyPrint", newJBool(prettyPrint))
  add(query_579306, "oauth_token", newJString(oauthToken))
  add(query_579306, "$.xgafv", newJString(Xgafv))
  add(query_579306, "pageSize", newJInt(pageSize))
  add(query_579306, "alt", newJString(alt))
  add(query_579306, "uploadType", newJString(uploadType))
  add(query_579306, "quotaUser", newJString(quotaUser))
  add(query_579306, "pageToken", newJString(pageToken))
  add(path_579305, "topic", newJString(topic))
  add(query_579306, "callback", newJString(callback))
  add(query_579306, "fields", newJString(fields))
  add(query_579306, "access_token", newJString(accessToken))
  add(query_579306, "upload_protocol", newJString(uploadProtocol))
  result = call_579304.call(path_579305, query_579306, nil, nil, nil)

var pubsubProjectsTopicsSubscriptionsList* = Call_PubsubProjectsTopicsSubscriptionsList_579286(
    name: "pubsubProjectsTopicsSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{topic}/subscriptions",
    validator: validate_PubsubProjectsTopicsSubscriptionsList_579287, base: "/",
    url: url_PubsubProjectsTopicsSubscriptionsList_579288, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsPublish_579307 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsPublish_579309(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "topic"),
               (kind: ConstantSegment, value: ":publish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsPublish_579308(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds one or more messages to the topic. Returns `NOT_FOUND` if the topic
  ## does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : The messages in the request will be published on this topic.
  ## Format is `projects/{project}/topics/{topic}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_579310 = path.getOrDefault("topic")
  valid_579310 = validateParameter(valid_579310, JString, required = true,
                                 default = nil)
  if valid_579310 != nil:
    section.add "topic", valid_579310
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
  var valid_579311 = query.getOrDefault("key")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "key", valid_579311
  var valid_579312 = query.getOrDefault("prettyPrint")
  valid_579312 = validateParameter(valid_579312, JBool, required = false,
                                 default = newJBool(true))
  if valid_579312 != nil:
    section.add "prettyPrint", valid_579312
  var valid_579313 = query.getOrDefault("oauth_token")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "oauth_token", valid_579313
  var valid_579314 = query.getOrDefault("$.xgafv")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = newJString("1"))
  if valid_579314 != nil:
    section.add "$.xgafv", valid_579314
  var valid_579315 = query.getOrDefault("alt")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = newJString("json"))
  if valid_579315 != nil:
    section.add "alt", valid_579315
  var valid_579316 = query.getOrDefault("uploadType")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "uploadType", valid_579316
  var valid_579317 = query.getOrDefault("quotaUser")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "quotaUser", valid_579317
  var valid_579318 = query.getOrDefault("callback")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "callback", valid_579318
  var valid_579319 = query.getOrDefault("fields")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "fields", valid_579319
  var valid_579320 = query.getOrDefault("access_token")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "access_token", valid_579320
  var valid_579321 = query.getOrDefault("upload_protocol")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "upload_protocol", valid_579321
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

proc call*(call_579323: Call_PubsubProjectsTopicsPublish_579307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds one or more messages to the topic. Returns `NOT_FOUND` if the topic
  ## does not exist.
  ## 
  let valid = call_579323.validator(path, query, header, formData, body)
  let scheme = call_579323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579323.url(scheme.get, call_579323.host, call_579323.base,
                         call_579323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579323, url, valid)

proc call*(call_579324: Call_PubsubProjectsTopicsPublish_579307; topic: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsPublish
  ## Adds one or more messages to the topic. Returns `NOT_FOUND` if the topic
  ## does not exist.
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
  ##   topic: string (required)
  ##        : The messages in the request will be published on this topic.
  ## Format is `projects/{project}/topics/{topic}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579325 = newJObject()
  var query_579326 = newJObject()
  var body_579327 = newJObject()
  add(query_579326, "key", newJString(key))
  add(query_579326, "prettyPrint", newJBool(prettyPrint))
  add(query_579326, "oauth_token", newJString(oauthToken))
  add(query_579326, "$.xgafv", newJString(Xgafv))
  add(query_579326, "alt", newJString(alt))
  add(query_579326, "uploadType", newJString(uploadType))
  add(query_579326, "quotaUser", newJString(quotaUser))
  add(path_579325, "topic", newJString(topic))
  if body != nil:
    body_579327 = body
  add(query_579326, "callback", newJString(callback))
  add(query_579326, "fields", newJString(fields))
  add(query_579326, "access_token", newJString(accessToken))
  add(query_579326, "upload_protocol", newJString(uploadProtocol))
  result = call_579324.call(path_579325, query_579326, nil, nil, body_579327)

var pubsubProjectsTopicsPublish* = Call_PubsubProjectsTopicsPublish_579307(
    name: "pubsubProjectsTopicsPublish", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{topic}:publish",
    validator: validate_PubsubProjectsTopicsPublish_579308, base: "/",
    url: url_PubsubProjectsTopicsPublish_579309, schemes: {Scheme.Https})
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
